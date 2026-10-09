set fish_greeting
set fish_color_command blue

switch (uname)
    case Darwin
        /opt/homebrew/bin/brew shellenv fish | source
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

# Homebrew's vendor_conf.d/mise-activate.fish may already have activated mise
if type -q mise; and not functions -q __mise_env_eval
    if status is-interactive
        mise activate fish | source
    else
        mise activate fish --shims | source
    end
end

if status is-interactive
    zoxide init fish | source
end
