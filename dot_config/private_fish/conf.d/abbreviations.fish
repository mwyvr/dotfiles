# some things make more sense as an alias
alias ls "ls --color=always"
alias l. "ls -d .*"

# dotfiles management
abbr -a cm chezmoi
abbr -a cma chezmoi apply
abbr -a cmu chezmoi update
abbr -a cmcd chezmoi cd
abbr -a cme chezmoi edit

# editor
abbr -a vi hx
abbr -a vim hx

# git
abbr -a gl lazygit
abbr -a gs git status
abbr -a gc git commit
abbr -a gu git pull
abbr -a gp git push
abbr -a forkup git pull --rebase upstream master

# processes
abbr -a pst ps -o pid,ppid,stat,user,comm -AH
# abbr -a update doas apk update && doas apk upgrade
