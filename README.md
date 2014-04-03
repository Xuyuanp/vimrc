vimrc
=====

My vimrc configuration.

# Setup

## Mac OS X / Linux

1. Clone repository.

    `git clone https://github.com/Xuyuanp/vimrc.git`

    or

    `git clone https://github.com/Xuyuanp/vimrc.git ~/.vim`

2. Execute the `install.sh` file.

    `source install.sh`

**warning** Only tested in Mac OS X and Archlinux

## Windows

* Fuck Windows.

# Plugins

Plugins managed using [Vundle](https://github.com/gmarik/Vundle.vim). You can easily install, update or remove plugin with Vundle.

## [Neocomplcache](https://github.com/Shougo/neocomplcache.vim) or [Neocomplete](https://github.com/Shougo/neocomplete.vim)
  Neocomplcache is an amazing autocomplete plugin with additional support for snippets. It can complete simulatiously from the dictionary, buffer, omnicomplete and snippets. This is the one true plugin that brings Vim autocomplete on par with the best editors.

  Neocomplete is the next generation completion framework after neocomplcache. It is faster than neocomplcache, but requires Vim 7.3.885+ with Lua enabled.

  **Just keep typing**, it will autocomplete where possible.

  **Key-map**:

  * `<TAB>`:autoselect.

  * `<C-N>/<C-P>`:select next/prev.

  * `<C-K>`:complete snippets.

## [git-NERDTree](https://github.com/Xuyuanp/git-nerdtree)

The NERD tree allows you to explore your filesystem and to open files and directories. It presents the filesystem to you in the form of a tree which you manipulate with the keyboard and/or mouse. It also allows you to perform simple filesystem operations.

  **Note:** This is my forked version. I add git status support for it. Set `let g:NERDTreeShowGitStatus = 0` to disable it.

  **Key-map**

  * `<C-E>`:toggle nerdtree
  * `]c`: jump to next change
  * `[c`: jump to prev change

## [Fugitive](https://github.com/tpope/vim-fugitive)

Fugitive is a git wrapper.

  **Command**: `:h fugitive` for details.

## To be contineue...
