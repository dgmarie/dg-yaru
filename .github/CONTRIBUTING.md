## Build and install themes from source

## Dependencies
- Arch based distros: `sudo pacman -S sassc git ninja meson rsync`

- Debian based distros: `sudo apt install sassc git ninja-build meson`

- Fedora: `sudo dnf install sassc git ninja-build meson`

- openSUSE: `sudo zypper install sassc git ninja meson`

# Download the repository from github
```bash
git clone https://github.com/dgmarie/dg-yaru.git
cd dg-yaru
# Initialize build system (only required once per repo)
meson build
# Take a look at the configuration and modify it if needed
meson configure build 
# Build and install
sudo ninja -C build install
```
