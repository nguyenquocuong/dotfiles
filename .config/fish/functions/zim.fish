function zim
    set dir (zoxide query -l | fzf)
    if test -n "$dir"
        z "$dir" && nvim +NvimTreeToggle
    end
end
