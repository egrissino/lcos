# lcos

Docker images for running and developing on [LCOS](https://github.com/BryanLunduke/LCOS) 0.8, a
Linux distribution based on Devuan excalibur (Debian 13), with an XFCE desktop you reach over VNC.

Two images are built:

| Image | Built by | Contents |
|---|---|---|
| `lcos` | `setup.sh` | The LCOS 0.8 root filesystem, taken from the release ISO and imported as-is |
| `lcos-dev` | `build-image.sh` (`Dockerfile`) | `lcos` plus Xvfb, x11vnc and SSH, a user account, and [PhotoC](https://github.com/egrissino/photoc) built natively from its `lcos-support` branch |

## Requirements

- Docker
- `sudo`, loop-device mounting and `squashfs-tools` (`unsquashfs`) to unpack the ISO
- About 10 GB of free disk space

## Build

```sh
# 1. Download the LCOS ISO, unpack its root filesystem and import it as the lcos image
./setup.sh

# 2. Build lcos-dev on top of it (the account is named after you)
./build-image.sh
```

`setup.sh` leaves `lcos-08.iso`, `rootfs/` (the mounted ISO) and `unsquashfs/` behind. When the
import is done, clean up with `sudo umount rootfs && sudo rm -rf rootfs unsquashfs lcos-08.iso`.

## Run

```sh
./run.sh
```

This replaces any existing `lcos-dev` container and starts a new one in the background. On start,
`startup.sh` launches SSH, an Xvfb display (`:0`, 1920×1080), the XFCE desktop and x11vnc.

Connect a VNC client (e.g. Remmina) to **`localhost:5900`** with password **`test`**. The
container's hostname `lcos-dev` doesn't resolve from the host, so connect through the published
port.

For a shell instead: `docker exec -it lcos-dev bash`.

| Account | Password |
|---|---|
| Your username (from `build-image.sh`), or `guest` when built without the build argument | `password` |
| VNC | `test` |

These are fixed development credentials. Don't expose the container beyond your machine.

## PhotoC

The image clones PhotoC and builds it with `native-setup.sh` and `build.sh`.
It installs:

- `photoc` and `photoc-cli` in `/usr/local/bin`
- the launcher `~/.local/share/applications/photoc.desktop`
- its icon, `~/.local/share/icons/hicolor/256x256/apps/photoc.png`

## Files

| File | Purpose |
|---|---|
| `setup.sh` | ISO → `lcos` image |
| `Dockerfile` | `lcos` → `lcos-dev` image |
| `build-image.sh` | Builds `lcos-dev`, removing the old container and image first |
| `run.sh` | Starts the `lcos-dev` container with VNC on port 5900 |
| `startup.sh` | Container start command: SSH, Xvfb, XFCE, x11vnc |
