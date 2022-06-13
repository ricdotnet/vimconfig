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

  " let g:material_style = "deep ocean"
  " colorscheme material
  let g:gruvbox_termcolors = "16"
  let g:gruvbox_contrast_dark = "hard"
  colorscheme gruvbox

  set completeopt=menu,menuone,noselect

" }}}

luafile $HOME/.config/nvim/auto-complete.lua
