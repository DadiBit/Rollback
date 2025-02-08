# Rollback

A simple GNOME Snapper interface, bundled as flatpak.

> [!WARNING]
> This is alpha software: stuff will break.

## Setup

### 1. Install [Snapper](https://github.com/openSUSE/snapper/)

You can build the program from source, or, as an alternative, you may install it with your favorite package manager.

For Debian, Ubuntu, Raspberry Pi OS & other Debian based distros:

```
sudo apt install snapper
```

For Arch, Manjaro, Steam OS & other Arch based distros:

```
sudo pacman -S snapper
```

For Fedora Silverblue & other Fedora immutable distros:

```
rpm-ostree install snapper
```

> [!TIP]
> If running an immutable distro (Vanilla OS 2, Fedora Silverblue etc.) you probably don't want to create a configuration for your root partition, since the rollback is already baked in the system.

### 2. Enable snapper timers

```
sudo systemctl enable --now snapper-timeline.timer
sudo systemctl enable --now snapper-cleanup.timer
```

## Why?

Cuz noobs like me struggle to rollback btrfs snapshots made by snapper.
I loved btrfs, until I had to understand how it worked to recover my data (it took too much time).

Yep, personal skill issue.

