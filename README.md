# dotfiles

This repo contains configuration files for Neovim and a number of tools and apps in daily use.

[chezmoi](https://www.chezmoi.io/quick-start/) makes managing personal configuration
files across multiple machines and distributions a ~~little~~ **lot** easier.

## Inclusions of note

I mostly run dwm or dwl window managers rather than the Gnome desktop
environment; I've configured dwm and dwl to act as similarly as possible. Those
configurations will be available here as patch files _soon_.

There's nothing distribution-specific in here; fwiw I run [Void
Linux](https://voidlinux.org/) on desktop and laptops and and openSUSE MicroOS for
containerized workloads elsewhere.

- Sane and simple bash prompt, indication when root, and Window Title updating for terminals
- LazyVim based configuration for NeoVim.
- .config/gnome-terminal: nordfox.sh script to add the colour palette for those rare times I'm in Gnome
- .config/nvim: LazyVim based Neovim configuration
- fuzzel menu, foot terminal for `dwl` (dwm for Wayland)
- rofi menu, alacritty terminal for dwm on Xorg

## quick-start for chezmoi newbies:

To set up a new machine or user account:

    # git write
    chezmoi init git@github.com:mwyvr/dotfiles.git
    # git read only (I use this on remote servers, all tweaks are done on my laptop/desktop)
    chezmoi init --apply https://github.com/mwyvr/dotfiles.git

Edit files within `chezmoi edit` to avoid confusion or missing updates.

    chezmoi edit # launch your editor in ~/.local/share/chezmoi/
    # then commit and push in git

Don't forget to push your changes to your repo.

_You can use [chezmoi re-add](https://www.chezmoi.io/user-guide/frequently-asked-questions/usage/#how-do-i-edit-my-dotfiles-with-chezmoi) for files you have edited outside of chezmoi._

Apply future changes to your running config.

    chezmoi apply
    # or pull and apply in one go
    chezmoi update

You won't want to live with bare git again.
