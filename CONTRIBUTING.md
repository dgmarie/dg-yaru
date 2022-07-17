## Build and install themes from source

## Dependencies
Ubuntu: `sassc` `git` `ninja-build` `meson`

Fedora: `sassc` `git` `ninja-build` `meson`

Arch: `sassc` `git` `ninja` `meson`

# Download the repository from github
```bash
git clone https://github.com/dgmarie/dg-yaru.git
cd dg-yaru
# Initialize build system (only required once per repo)
meson build
cd build
# Build and install
sudo ninja install
```
