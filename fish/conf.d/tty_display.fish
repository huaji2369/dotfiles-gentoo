if test $XDG_SESSION_TYPE = "tty"
    set -x DISPLAY :0
    set -x WAYLAND_DISPLAY wayland-1
end
