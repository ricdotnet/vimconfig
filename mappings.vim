" Useful hints:
" i -> insert mode
" v -> visual mode
" n -> normal mode
" t -> terminal mode
" with the keys above we can then remap commands for the different modes
"   available
" <CR> stands for carriage return but we can also use <Enter>

let mapleader = '.'

" command mappings
nnoremap <Leader>ff :Telescope find_files<Enter>
tnoremap <Esc> <C-\><C-n>

nnoremap <Leader>ss :w<Enter>

" move lines mappings
nnoremap <A-Up> :m .-2<CR>==
nnoremap <A-Down> :m .+1<CR>==
inoremap <A-Up> <Esc>:m .-2<CR>==gi
inoremap <A-Down> <Esc>:m .+1<CR>==gi
tnoremap <A-Up> :m '<-2<CR>gv=gv
tnoremap <A-Down> :m '>+1<CR>gv=gv

" duplicate lines
nnoremap <S-d> 0v$y<ESC><CR>P
"inoremap <S-d> <ESC>0v$y<ESC><CR>P

" reload configs
nnoremap <leader>sv :source $MYVIMRC<CR>
