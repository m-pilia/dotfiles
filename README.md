[![](https://github.com/m-pilia/dotfiles/workflows/Checks/badge.svg)](https://github.com/m-pilia/dotfiles/actions?query=workflow%3AChecks)

# My shell configuration and some of my dotfiles

This repository hosts my shell configuration and some of my dotfiles.

# Dependencies

Example for Arch Linux:

```sh
pacman -S \
    ccache \
    fd \
    fzf \
    ksshaskpass \
    pax-utils \
    powerline-fonts \
    ripgrep \
    thefuck \
    tmux \
    ttf-cascadia-code \
    zsh \

yay -S \
    autojump-rs \

```

# Caveat emptor

* This configuration assumes that tools and `zsh` plugins are installed at
  system level.
* This configuration is designed for Arch Linux, therefore eventual paths
  contained in it are written according to how software components are packaged
  on Arch.
* The `install.sh` is an helper script that creates symlinks to the
  configuration files in the right places. It is a DIY and less sophisticated
  version of dotfile management tools like
  [homesick](https://github.com/technicalpickles/homesick) and
  [homeshick](https://github.com/andsens/homeshick).
* The `install_third_party.sh` is an helper script that fetches a copy of third
  party dependencies, making it possible to use the `zsh` configuration and run
  basic tools (such as [fzf](https://github.com/junegunn/fzf) and
  [fd](https://github.com/sharkdp/fd)) even without the relevant system
  packages. This is more of an emergency tool, and allows to quickly use this
  configuration on a different system (e.g. Ubuntu).
* The `master` branch contains "stable" commits, i.e. pieces of configuration
  that, after some battle testing, I find to be satisfactory enough. The
  `develop` branch contains "experimental" commits that I want to try more
  extensively in my daily usage of vim before merging them to master. Note that
  the commits in the `develop` branch that are not already merged to `master`
  may be amended, in case their code turns out to be faulty, since keeping a
  clean history is a top priority for this repository. The history of the
  `master` branch, on the other hand, is never rewritten.
* This configuration is for my personal use. Therefore, differently than all my
  other repositories on GitHub, I do not accept contributions here. The issue
  tracker is disabled, and pull requests will be closed and locked
  automatically.

# License

The content of this repository is available under the MIT license, whose full
text is available in the [LICENSE
file](https://github.com/m-pilia/dotfiles/blob/master/LICENSE).
