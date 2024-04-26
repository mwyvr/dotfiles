# Neovim Configuration

## Why?

While I'm a big fan of the pre-configured [LazyVim](https://www.lazyvim.org/)
setup, in April 2024 on an emerging and interesting (to me) Linux distribution
(Chimera Linux, musl libc only) I ran into a problem with yanking text that I
couldn't solve.

For whatever reason, Neovim would just silently quite with issuing a `yy` or
`Vy` command to grab a line; not on a `vey` or other word/character selections.

Searching LazyVim's code for clipboard related issues, Yank, unnamedplus, etc 
has turned up nothing. 

Starting Neovim without LazyVim configuration `nvim --clean` - no issues.

I spent a month using Helix and while I like it, a lot, there are some gaps there
that can only be solved when they release plugin support. I love that it does 92%
of what I need, out of the box, unlike vim/neovim which requires heavy plugin use
to get to 80% and beyond.

I will eventually puzzle this out, but the experience has taught me that I'd
prefer to include only that which I really need in Neovim.

## What

This config has as goals or includes:

- Simplicity but not at the expense of functionality
- lazy.nvim plugin manager
- LSP support, Mason
- Configured for Lua, Go, html, templ, Javascript, Python, bash, toml, conf,
  and other language and filetypes commonly encountered in my development and
  sysadmin tasks.

As a side goal, to make it easier to use or one day migrate to Helix, I may try
to align keymappings for functionality with Helix. There will be no attempt to
mimic Helix's inverted (compared to vim) *selection-action* model.
