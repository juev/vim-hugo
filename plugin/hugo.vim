" hugo.vim
" Author:  Denis Evsyukov <denis@evsyukov.org>
" URL:     https://github.com/juev/vim-hugo
" Version: 0.1.0
" License: Same as Vim itself (see :help license)

if exists('g:loaded_hugo') || &cp || v:version < 700
  finish
endif
let g:loaded_hugo = 1

" Configuration {{{

if ! exists('g:hugo_path')
  let g:hugo_path = "~/blog"
endif

if ! exists('g:hugo_post_dirs')
  let g:hugo_post_dirs = "/content/posts/"
endif

if !exists('g:hugo_post_suffix')
  let g:hugo_post_suffix = "markdown"
endif

if !exists('g:hugo_title_pattern')
  let g:hugo_title_pattern = "[ '\"]"
endif

" }}}

" Utility functions {{{

function! s:esctitle(str)
  let str = a:str
  let str = tolower(str)
  let str = substitute(str, g:hugo_title_pattern, '-', 'g')
  let str = substitute(str, '\(--\)\+', '-', 'g')
  let str = substitute(str, '\(^-\|-$\)', '', 'g')
  return str
endfunction

function! s:error(str)
  echohl ErrorMsg
  echomsg a:str
  echohl None
  let v:errmsg = a:str
endfunction

" }}}

" Post functions {{{

function! HugoPost(title)
  let created = strftime("%FT%T%z") " 2019-10-24T08:56:12+03:00
  let title = a:title
  if title == ''
    let title = input("Post title: ")
  endif
  if title != ''
    let file_name = strftime("%Y-%m-%d-") . s:esctitle(title) . "." . g:hugo_post_suffix
    echo "Making that post " . file_name
    exe "e " . g:hugo_path . g:hugo_post_dirs . file_name

    let template = ["---", "title: \"" . title . "\"", "date: " . created, "image: ", "tags: ", "  - "]
    call extend(template,["---", ""])

    let err = append(0, template)
  else
    call s:error("You must specify a title")
  endif
endfunction
command! -nargs=? HugoPost :call HugoPost(<q-args>)

" }}}

" vim:ft=vim:fdm=marker:ts=2:sw=2:sts=2:et
