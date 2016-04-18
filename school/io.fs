\ io.fs
\ Glenn G. Chappell
\ 23 Mar 2016
\
\ For CS 331 Spring 2016
\ Code from 3/23: Forth I/O


cr cr
." This file contains sample code from March 23, 2016." cr
." It will execute, but it is not intended to do anything" cr
." particularly useful." cr
cr
." The point is to have code that you can mess with. Open" cr
." the source in an editor. Try typing the suggested lines" cr
." in Gforth. Modify the code and see what happens." cr
cr


\ ***** Characters *****


\ codechar
\ Given an integer n, print it as number (right justified in 3-character
\ field), then a blank, then print it as character.
\ Helper function for asciiTable.
: codechar  { n -- }
  n 100 < if 32 emit then  \ Print a leading blank for numbers < 100
  n .
  n emit
;

\ asciitable
\ Print a table of all printable ASCII: codes & characters.
: asciitable  ( -- )
  cr
  16 0 ?do
    i { k }
    6 0 ?do
      k i 16 * + 32 + { n }  \ Character code
      n 127 <> if
        n codeChar
        k 15 < i 5 < and i 4 < or if
          s"     " type
        then
      then
    loop
    cr
  loop
;

\ Try:
\   asciitable

\ backtype
\ Given a string (as addr/len), print it backwards.
: backtype { addr len -- }
  len 0 ?do
    len 1 - i -  \ Stack: index-of-char-to-print
    addr +       \ Stack: addr-of-char-to-print
    c@           \ Stack: char-to-print
    emit
  loop
;

\ Try:
\   s" Hello, there!" backtype


\ ***** Input *****


\ reverseit
\ Input a line, with prompt, and print it forward & backward
: reverseit
  1000 { buff-len }
  buff-len allocate { buff-addr buff-fail? }
  buff-fail? if
    ." ERROR: Could not allocate buffer"
    cr
  else
    begin
      cr
      ." Type something (blank line to end): "
      buff-addr buff-len accept { line-len }
      line-len 0 <> while
      cr
      ." You typed: "
      buff-addr line-len type
      cr
      ." Backward: "
      buff-addr line-len backtype
      cr
    repeat
  then
  cr
  buff-addr free { free-fail? }
;

\ Try:
\   reverseit


\ ***** File I/O *****


\ backfile
\ Given filename (as addr/len) print contents of file with line numbers,
\ lines printed backwards.
: backfile { fname-addr fname-len -- }
  fname-addr fname-len r/o open-file { file-id open-fail? }
  open-fail? if
    ." ERROR: Could not open file '"
    fname-addr fname-len type
    ." '"
    cr
  else
    0 { line-num }
    1000 { buff-len }
    buff-len allocate { buff-addr buff-fail? }
    buff-fail? if
      ." ERROR: Could not allocate buffer"
      cr
    else
      cr
      begin
        buff-addr buff-len file-id read-line { line-len flag read-fail? }
      flag read-fail? invert and while
        line-num 1 + to line-num    \ Increment line number
        line-num .                  \ Print line number
        buff-addr line-len backtype cr  \ print line
      repeat
      buff-addr free { free-fail? }
      file-id close-file { close-fail? }
    then
  then
;

\ Try:
\   s" io.fs" backfile

