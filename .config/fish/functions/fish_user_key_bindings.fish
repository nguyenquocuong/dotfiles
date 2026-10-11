function fish_user_key_bindings
    # tmux passes ctrl-alt-l on to nested sessions (see tmux.conf), so clear with it too
    bind ctrl-alt-l clear-screen
end
