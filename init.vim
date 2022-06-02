source $HOME/.config/nvim/auto-complete.vim
source $HOME/.config/nvim/mappings.vim
source $HOME/.config/nvim/plugins.vim
source $HOME/.config/nvim/status-bar.vim

" {{{
  set number
  set relativenumber

  set tabstop=2
  set shiftwidth=2
  set expandtab

  let g:netrw_liststyle = 3

  set foldmethod=marker
  set foldmarker={{{,}}}

  if (has("termguicolors"))
    set termguicolors
  endif
  syntax enable

  let g:material_style = "deep ocean"
  colorscheme material

" }}}

