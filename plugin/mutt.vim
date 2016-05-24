" Tip: Place the cursor in the optimal position, editing email messages.
" Author: Davide Alberani
" Version: 0.1
" Date: 24 May 2006
" Description: if you use Vim to edit your emails, having to manually
" move the cursor to the right position can be quite annoying.
" This command will place the cursor (and enter insert mode)
" in the more logical place: at the Subject header if it's
" empty or at the first line of the body (also taking
" care of the attribution, to handle replies messages).
" Usage: I like to call the Fip command by setting the command that is used
" by my mail reader (mutt) to execute Vim. E.g. in my muttrc I have:
" set editor="vim -c ':Fip'"
" Obviously you can prefer to call it using an autocmd:
" " Modify according to your needs and put this in your vimrc:
" au BufRead mutt* :Fip
" Hints: read the comments in the code and modify it according to your needs.
" Keywords: email, vim, edit, reply, attribution, subject, cursor, place.

" Function used to identify where to place the cursor, editing an email.
function! FirstInPost (...) range
  let cur = a:firstline
  while cur <= a:lastline
    let str = getline(cur)
    " Found an _empty_ subject in the headers.
    " NOTE: you can put similar checks to handle other empty headers
    " like To, From, Newgroups, ...
    if str == 'Subject: '
      execute cur
      :start!
      break
    endif
    " We have reached the end of the headers.
    if str == ''
      let cur = cur + 1
      " If the first line of the body is an attribution, put
      " the cursor _after_ that line, otherwise the cursor is
      " leaved right after the headers (assuming we're writing
      " a new mail, and not editing a reply).
      " NOTE: modify the regexp to match your mail client's attribution!
      if strlen(matchstr(getline(cur), '^\*\s.*\[.*\].*')) > 0
        let cur = cur + 2
      endif
	  while strlen(matchstr(getline(cur), '^>.*')) > 0
        let cur = cur + 1
      endwhile
      execute cur
      :start
      :execute "normal i\<End>\n\n"
      break
    endif
    let cur = cur + 1
  endwhile
endfunction

" Command to be called.
com Fip :set tw=0<Bar>:%call FirstInPost()
