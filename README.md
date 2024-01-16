# dotfiles
Configuration files for my Void Linux and openSUSE MicroOS and Aeon machines.

 [chezmoi](https://www.chezmoi.io/quick-start/) makes managing personal configuration 
 files across multiple machines and distributions a little easier.

## quick-start

To set up a new machine or user account:

    # git write access
    chezmoi init git@github.com:solutionroute/dotfiles.git
    # git read only
    chezmoi init https://github.com/solutionroute/dotfiles.git

Edit the files within `chezmoi` to avoid confusion or missing updates.

    chezmoi edit # launch your editor in ~/.local/share/chezmoi/

Apply the changes to your running config.

    chezmoi apply

Don't forget to push your changes to your repo.
