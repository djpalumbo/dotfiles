# Sourced by the lockers: run_i3lock <i3lock options> returns once i3lock exits.
#
# When xss-lock runs a locker for a suspend (--transfer-sleep-lock), it passes
# the logind sleep-delay lock as XSS_SLEEP_LOCK_FD. Hold it until i3lock has
# grabbed the keyboard and pointer, so the system never suspends with input
# ungrabbed (which can drop key releases and leave modifiers stuck on resume).
#
# This must run in the locker's own shell (hence sourced, not executed): the
# lock is only released once every copy of the fd is closed, and the locker
# process holds the copy xss-lock handed it.

run_i3lock() {
    if [[ -e /dev/fd/${XSS_SLEEP_LOCK_FD:--1} ]]; then
        kill_i3lock() { pkill -xu "$EUID" "$@" i3lock; }
        trap kill_i3lock TERM INT

        # Without -n, i3lock forks only after its grabs succeed. Keep the lock
        # fd out of i3lock so that closing ours below is what releases it.
        i3lock "$@" {XSS_SLEEP_LOCK_FD}<&-

        # Grabbed, but i3lock only paints its image after forking, and picom
        # then fades the window in (0.2s open animation). Give both time to
        # finish, or the screen suspends mid-fade and the desktop shows briefly
        # on resume.
        sleep 0.5

        # Locked and painted: let the suspend proceed
        exec {XSS_SLEEP_LOCK_FD}<&-

        while kill_i3lock -0; do sleep 0.5; done
    else
        trap 'kill %%' TERM INT
        i3lock -n "$@" &
        wait
    fi
}
