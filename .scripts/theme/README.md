# theme

Light/dark theme switching: a wallpaper of the right brightness plus its pywal
colorscheme, and GTK's Arc / Arc-Dark. Switches at sunrise/sunset, or can be
forced light or dark.

| File | What it does |
| --- | --- |
| `mode` | `mode set auto\|light\|dark`, `mode wallpaper` (i3: `$super+t`, `$super+w`) |
| `apply` | Applies a mode: picks a wallpaper, runs `wal`, switches GTK |
| `darkman-run` | darkman's `ExecStart`; passes it the location only in auto mode |
| `wal-set` | Run by `wal -o`: restarts dunst and polybar with the new colors |

Elsewhere:

- `~/.config/location`: `LAT=` / `LNG=`, untracked; written by
  `arch-install/arch-user-setup.sh`
- `~/Pictures/Wallpapers/wallpapers.json`: each wallpaper is `"light"`,
  `"dark"`, or `"both"`
- `~/.local/share/darkman/theme`: darkman's hook, calls `apply`
- `~/.config/darkman/`, `~/.config/systemd/user/darkman.service.d/`: darkman
  config and the `darkman-run` override
- `~/.config/xdg-desktop-portal/portals.conf`: darkman provides the portal's
  color scheme (Firefox, GTK4)
- `~/.config/polybar/scripts/theme-icon.sh`: the bar's sun/moon
- `~/.scripts/wm-settings.sh`: starts xsettingsd (live GTK3 switching) and
  darkman at login
