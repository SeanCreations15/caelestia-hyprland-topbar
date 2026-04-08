# caelestia-hyprland-topbar

A personal customisation and take on the Caelestia Quickshell setup for Hyprland, including a top bar layout and centered launcher.

## Attribution

This is a personal derivative setup based on the original Caelestia shell/config work by its original author(s).

Original project:

- `caelestia-dots / https://github.com/caelestia-dots/shell?tab=readme-ov-file`

My changes in this repo include personal Hyprland integration and local Caelestia layout changes, including the custom top bar and centered launcher behavior.

I am not claiming the original Caelestia project as my own work. This repo is only my modified personal configuration backup.

## Included Paths

- `.config/quickshell/caelestia`
- `.config/caelestia`
- `.config/hypr`

## Restore

From the repo root:

```bash
./install.sh
```

This copies the tracked config back into `~/.config`.

## Update Backup

From the repo root:

```bash
./backup.sh "Describe change"
```

This stages changes, creates a commit, and pushes to GitHub.

## Start Shell

```bash
qs -p ~/.config/quickshell/caelestia/shell.qml -d
```

## Notes

- The local shell is the source of truth, not `/etc/xdg/quickshell/caelestia`.
- Hyprland is configured to autostart the local shell path.
- If you publish this repo, keep the original project credit above and preserve the upstream license for copied files.
