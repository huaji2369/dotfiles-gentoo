#!/bin/fish

if ! test -e /bin/cotp
    notify-send -u critical "cotp is not installed"
    exit 1
end

set -l cotp_password (
    fuzzel \
    --dmenu \
    --mesg "Enter cotp password" \
    --prompt-only "Password:" \
    --password
)

if test -z "$cotp_password"
    exit 1
end

set -l cotp_output (echo "$cotp_password" | cotp --password-stdin list)

if test $status -ne 0
    notify-send -u critical "Error unlocking cotp database" "$cotp_output"
    exit 1
end

for apps in $cotp_output[2..]
    set -l apps (string trim -- "$apps")
    if test -n "$apps"
        set cotp_apps $cotp_apps (echo $apps | awk '{print $1". "$2" - "$3}')
    end
end

if test (count $cotp_apps) -eq 0
    notify-send -u critical "COTP" "No applications found in database"
    exit 1
end

set -l display_lines_count (count $cotp_apps)
if test $display_lines_count -gt 10
    set display_lines_count 10
end

set -l selected_index (printf '%s\n' $cotp_apps |
    fuzzel \
    --dmenu \
    --mesg "Select application" \
    --hide-prompt \
    --width 40 \
    --lines $display_lines_count \
    --index
)

if test -z "$selected_index"
    exit 1
end

echo "$cotp_password" |\
cotp --password-stdin extract --index "$selected_index" |\
tr -d '\n' |\
wl-copy

notify-send "COTP" "OTP copied to clipboard"
