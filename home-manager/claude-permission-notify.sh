# Claude Code PermissionRequest hook. When Claude Code asks for permission to
# run a tool, this script posts a macOS notification with Allow and Deny
# buttons. Allow approves the tool call and Deny rejects it.
#
# Requires jq and alerter (https://github.com/vjeantet/alerter).
#
# To install, copy this script to a path of your choice, for example
# ~/.claude/hooks/permission-notify, add a "#!/usr/bin/env bash" first line and
# make it executable. Then register it in ~/.claude/settings.json:
#
#   {
#     "hooks": {
#       "PermissionRequest": [
#         {
#           "matcher": "Bash",
#           "hooks": [
#             {
#               "type": "command",
#               "command": "~/.claude/hooks/permission-notify",
#               "timeout": 70
#             }
#           ]
#         }
#       ]
#     }
#   }
#

# Keep below the hook timeout in ~/.claude/settings.json, so the notification
# closes itself before Claude Code gives up on this hook.
timeout=60

input=$(cat)
tool=$(jq -r '.tool_name' <<<"$input")
session=$(jq -r '.session_id' <<<"$input")
command=$(jq -r '.tool_input.command // (.tool_input | tostring)' <<<"$input")
description=$(jq -r '.tool_input.description // .tool_name' <<<"$input")

# --group keeps one notification per session, so a new request replaces the
# stale one rather than stacking up. --json reports how the notification was
# answered, which is clearer than the plain-text answer.
answer=$(alerter \
  --title "Claude Code needs permission: $tool" \
  --subtitle "$description" \
  --message "$command" \
  --actions Allow \
  --close-label Deny \
  --timeout "$timeout" \
  --group "claude-permission-$session" \
  --sound Glass \
  --json 2>/dev/null) || true

# The Deny button is the notification's close button, so it answers "closed".
# Dismissal of the notification another way also answers "closed", and denial is
# the safe reading of that. A "timeout" answer, or "contentsClicked" from a click
# on the notification body, decides nothing and leaves the request to the
# permission dialog in the Claude Code client.
jq -rn --argjson a "${answer:-null}" '
  if ($a.activationType == "actionClicked" and $a.activationValue == "Allow") then
    {hookSpecificOutput: {hookEventName: "PermissionRequest", decision: {behavior: "allow"}}}
  elif ($a.activationType == "closed") then
    {hookSpecificOutput: {hookEventName: "PermissionRequest", decision: {
      behavior: "deny",
      message: "The user denied this command from the macOS notification."}}}
  else empty
  end' 2>/dev/null || true
