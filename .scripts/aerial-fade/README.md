# aerial-fade SDDM theme

Login theme installed to `/usr/share/sddm/themes/aerial-fade`.

`theme/` is [3ximus/aerial-sddm-theme](https://github.com/3ximus/aerial-sddm-theme)
master plus my branches in `~/repos/aerial-sddm-theme` (`fade-in-first-frame`,
`refresh-playlists`, `local-videos`, `bold-font-option`), with
`metadata.desktop` renamed and my
`theme.conf.user`. If those get merged upstream, this can go back to the AUR
`sddm-theme-aerial-git` package plus `theme.conf.user`.

- `sudo ./install` copies the theme, gives `$SUDO_USER` the videos dir and
  local playlist, links `~/Videos/aerial-sddm-theme`, and points SDDM at it
  (including the VA-API decoder rank fix). Safe to re-run; keeps videos.
- `~/.scripts/aerial-fetch [N]` downloads N more videos (H.264, for hardware
  decoding on the Skylake iGPU) and rebuilds the playlist.
