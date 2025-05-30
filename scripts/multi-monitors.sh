#!/bin/sh

case ${MONS_NUMBER} in
    1)
        mons -o
        # feh --no-fehbg --bg-fill "${HOME}/wallpapers/a.jpg"
        ;;
    2)
        # mons -e top
        mons -s
        # feh --no-fehbg --bg-fill "${HOME}/wallpapers/a.jpg" \
        #                --bg-fill "${HOME}/wallpapers/b.jpg"
        ;;
    *)
        # Handle it manually
        ;;
esac
