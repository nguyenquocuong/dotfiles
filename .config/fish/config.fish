set fish_greeting
set fish_color_command blue

if status is-interactive
    # Commands to run in interactive sessions can go here
  fenv source /etc/profile
end

if status is-login
    if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
	exec startx -- -keeptty
    end
end

eval $(ssh-agent -c) &>/dev/null

