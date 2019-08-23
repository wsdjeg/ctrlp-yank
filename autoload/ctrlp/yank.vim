if exists('g:loaded_ctrlp_yank') && g:loaded_ctrlp_yank
  finish
endif
let g:loaded_ctrlp_yank = 1

let s:register_var = {
      \  'init':   'ctrlp#yank#init()',
      \  'exit':   'ctrlp#yank#exit()',
      \  'accept': 'ctrlp#yank#accept',
      \  'lname':  'menu',
      \  'sname':  'menu',
      \  'type':   'menu',
      \  'sort':   0,
      \}

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  let g:ctrlp_ext_vars = add(g:ctrlp_ext_vars, s:register_var)
else
  let g:ctrlp_ext_vars = [s:register_var]
endif

function! ctrlp#yank#init()
  call neoyank#update()
  let histories = neoyank#_get_yank_histories()
  let reg_history = get(histories, '"', [])
  let selection = 0
  let command = 'p'
  return map(
        \ copy(reg_history),
        \ 'command . "\t" . selection . "\t" . v:val[1] . "\t"  . v:val[0]')
endfunc

function! ctrlp#yank#accept(mode, str)
  call ctrlp#exit()
  let parts = split(a:str, "\t", 1)
  let command = parts[0]
  let selection = str2nr(parts[1])
  let regtype = parts[2]
  let text = join(parts[3:], "\t")
  call s:paste(text, command, regtype, selection)
endfunction

function! s:paste(text, command, type, selection)
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')

  call setreg('"', a:text, a:type)
  try
    execute 'normal! ' . (a:selection ? 'gv' : '') . '""' . a:command
  finally
    call setreg('"', old_reg, old_regtype)
  endtry
endfunction

function! ctrlp#yank#exit()
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
function! ctrlp#yank#id()
  return s:id
endfunction

" vim:fen:fdl=0:ts=2:sw=2:sts=2
