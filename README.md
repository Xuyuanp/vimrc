vimrc
=====

My vimrc configuration.

# Setup

## Mac OS X / Linux

`curl https://raw.githubusercontent.com/Xuyuanp/vimrc/master/install.sh | sh`

**warning** Only tested in Mac OS X and Archlinux

## Windows

* Fuck Windows.

# Plugins

Plugins managed using [NeoBundle](https://github.com/Shougo/neobundle.vim). You can easily install, update or remove plugin with NeoBundle.

## [Neocomplcache](https://github.com/Shougo/neocomplcache.vim) or [Neocomplete](https://github.com/Shougo/neocomplete.vim)
  Neocomplcache is an amazing autocomplete plugin with additional support for snippets. It can complete simulatiously from the dictionary, buffer, omnicomplete and snippets. This is the one true plugin that brings Vim autocomplete on par with the best editors.

  Neocomplete is the next generation completion framework after neocomplcache. It is faster than neocomplcache, but requires Vim 7.3.885+ with Lua enabled.

  **Just keep typing**, it will autocomplete where possible.

  **Key-map**:

  * `<TAB>`:autoselect.

  * `<C-N>/<C-P>`:select next/prev.

  * `<C-K>`:complete snippets.

## [NERDTree](https://github.com/scrooloose/nerdtree) with [nerdtree-git-plugin](https://github.com/Xuyuanp/nerdtree-git-plugin)

The NERD tree allows you to explore your filesystem and to open files and directories. It presents the filesystem to you in the form of a tree which you manipulate with the keyboard and/or mouse. It also allows you to perform simple filesystem operations.

  **Note:** nerdtree-git-plugin is a plugin of NERDTree showing git status. Set `let g:NERDTreeShowGitStatus = 0` to disable it.

  **Key-map**

  * `<C-E>`:toggle nerdtree
  * `]c`: jump to next change
  * `[c`: jump to prev change

## [Fugitive](https://github.com/tpope/vim-fugitive)

Fugitive is a git wrapper.

  **Command**: `:h fugitive` for details.

## To be continue...
