# dotfiles
Configuration files for my Void Linux and openSUSE MicroOS and Aeon machines.

 [chezmoi](https://www.chezmoi.io/quick-start/) makes managing personal configuration 
 files across multiple machines and distributions a little easier.

## Inclusions of note

* .config/gnome-terminal: nordfox.sh script to add the colour palette
* .config/nvim: LazyVim based Neovim configuration

## quick-start

To set up a new machine or user account:

    # git write access
    chezmoi init git@github.com:solutionroute/dotfiles.git
    # git read only
    chezmoi init https://github.com/solutionroute/dotfiles.git

Edit files within `chezmoi edit` to avoid confusion or missing updates.

    chezmoi edit # launch your editor in ~/.local/share/chezmoi/

*You can use [chezmoi re-add](https://www.chezmoi.io/user-guide/frequently-asked-questions/usage/#how-do-i-edit-my-dotfiles-with-chezmoi) for files you have edited outside of chezmoi.*

Apply the changes to your running config.

    chezmoi apply

Don't forget to push your changes to your repo.
