# shellcheck shell=sh
# Origem: zeigt im Hacker-Theme beim Öffnen eines Terminals ein kurzes Intro.
# Abschalten: ORIGEM_KEIN_INTRO=1 setzen oder ein anderes Theme wählen.
case $- in
    *i*) ;;
    *) return 0 2>/dev/null || exit 0 ;;
esac

if [ -z "${ORIGEM_INTRO_GEZEIGT:-}" ] && [ -z "${ORIGEM_KEIN_INTRO:-}" ] && [ -t 1 ] \
   && [ -z "${SSH_CONNECTION:-}" ] && [ -z "${TOOLBOX_PATH:-}" ] \
   && [ "$(cat "${XDG_CONFIG_HOME:-$HOME/.config}/origem/terminal-intro" 2>/dev/null)" = "matrix" ]; then
    export ORIGEM_INTRO_GEZEIGT=1
    /usr/bin/origem-intro
fi
