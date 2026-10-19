set fish_greeting
set fish_color_command blue

switch (uname)
    case Darwin
        /opt/homebrew/bin/brew shellenv fish | source

        # SSH clients often do not forward LANG; without a UTF-8 locale, tmux renders non-ASCII as "_"
        test -n "$LANG"; or set -gx LANG en_US.UTF-8
    case Linux
        if status is-interactive
            fenv source /etc/profile
        end

        if status is-login
            if test -z "$DISPLAY" -a "$XDG_VTNR" = 1
                exec startx -- -keeptty
            end
        end

        eval $(ssh-agent -c) &>/dev/null
end

fish_add_path --global ~/.local/bin ~/.cargo/bin

# Homebrew's vendor_conf.d/mise-activate.fish activates mise before this file runs,
# then `brew shellenv` above puts /opt/homebrew/bin first again and brew binaries
# (like a node or python3 pulled in as a dependency) shadow mise tools. Activate again so mise wins.
if type -q mise
    if status is-interactive
        mise activate fish | source
    else
        mise activate fish --shims | source
    end
end

if status is-interactive
    zoxide init fish | source
end
