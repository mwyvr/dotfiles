# dotfiles

This repo contains configuration files for Neovim and a number of tools and apps in daily use.

 [chezmoi](https://www.chezmoi.io/quick-start/) makes managing personal configuration 
 files across multiple machines and distributions a ~~little~~ **lot** easier.

## Inclusions of note

I mostly run dwm or dwl window managers rather than the Gnome desktop
environment; I've configured dwm and dwl to act as similarly as possible. Those
configurations will be available here as patch files *soon*.

There's nothing distribution-specific in here; fwiw I run [Void
Linux](https://voidlinux.org/) on desktop and laptops and some office machines.


* LazyVim based configuration for NeoVim.
* .config/gnome-terminal: nordfox.sh script to add the colour palette for those rare times I'm in Gnome
* .config/nvim: LazyVim based Neovim configuration
* fuzzel menu, foot terminal for `dwl` (dwm for Wayland)
* rofi menu, alacritty terminal for dwm on Xorg

## quick-start for chezmoi newbies:

To set up a new machine or user account:

    # git write access for me
    chezmoi init git@github.com:solutionroute/dotfiles.git
    # git read only (I use this on remote machines, all tweaks are done on laptop/desktop)
    chezmoi init https://github.com/solutionroute/dotfiles.git

Edit files within `chezmoi edit` to avoid confusion or missing updates.

    chezmoi edit # launch your editor in ~/.local/share/chezmoi/

*You can use [chezmoi re-add](https://www.chezmoi.io/user-guide/frequently-asked-questions/usage/#how-do-i-edit-my-dotfiles-with-chezmoi) for files you have edited outside of chezmoi.*

Apply the changes to your running config.

    chezmoi apply

Don't forget to push your changes to your repo.
