""
" @section Introduction, intro
" @stylized ctrlp-yank
" @library
" @order intro version dicts functions exceptions layers api faq
" ctrlp-yank is a neoyank plugin for ctrlp


let g:ctrlp_menu_name = ''

""
" Open yank history
command! CtrlPNeoyank call ctrlp#init(ctrlp#yank#id())

