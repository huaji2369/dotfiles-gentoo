#!/usr/bin/env fish

set -l power_operation (printf "poweroff\nreboot\nsuspend\nhibernate" |\
    fuzzel \
    --dmenu \
    --mesg "Select power operation" \
    --hide-prompt \
    --lines 4)

if test -z "$power_operation"
    exit 1
end
switch $power_operation
    case "poweroff"
        loginctl poweroff
    case "reboot"
        loginctl reboot
    case "suspend"
        loginctl suspend
    case "hibernate"
        loginctl hibernate
end