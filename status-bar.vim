set laststatus=2
set statusline=
"set statusline+=\ %F\ %M\ %Y\ %R
"set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%

set statusline+=%1*%{CurrentMode()}
set statusline+=%3*\ 
set statusline+=%2*%f\ git:%{CurrentGitBranch()}\ %m
set statusline+=%3*\ 
set statusline+=%2*Ln\ %l,\ Col\ %c
set statusline+=%3*


" current mode
function! CurrentMode()
  let l:mode=mode()
  if l:mode=="n"
    return "NORMAL"
  elseif l:mode=="i"
    return "INSERT"
  elseif l:mode=="R"
    return "REPLACE MULTI"
  elseif l:mode=="v"
    return "VISUAL"
  elseif l:mode=="c"
    return "COMMAND"
  endif
  "return l:mode
endfunction

" get current git branch if any
function! CurrentGitBranch() 
  let b:gitbranch=""
  if &modifiable
    try
      let l:dir=expand('%:p:h')
      let l:gitrevparse = system("git -C ".l:dir." rev-parse --abbrev-ref HEAD")
      if !v:shell_error
        let b:gitbranch="(".substitute(l:gitrevparse, '\n', '', 'g').")"
      endif
    catch
    endtry
  endif

  return b:gitbranch
endfunction

" set statusline colors
function! StatuslineColors()
  autocmd VimEnter,ColorScheme * hi User1 guifg=black guibg=lightgreen
  autocmd VimEnter,ColorScheme * hi User2 guifg=white guibg=gray23
  autocmd VimEnter,ColorScheme * hi User3 guifg=white guibg=black
endfunction

call StatuslineColors()
