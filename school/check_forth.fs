\ check_forth.fs
\ Glenn G. Chappell
\ 11 Feb 2016
\
\ For CS 331 Spring 2016
\ A Forth Program to Run
\ Used in Assignment 3, Exercise A


999 constant end-mark  \ End marker for pushed data


\ push-data
\ Push our data on stack.
: push-data ( -- <lots of numbers, end-mark pushed first> )
  end-mark
  68 6 10 -41 -44
  12 60 12 -2 -3
  -41 -38 69 3 12
  -84 69 14 -30 -75
;


\ do-stuff
\ Given a number, do ... whatever operations we are supposed to do.
\ (Pretty mysterious, eh?)
: do-stuff { n -- }
  push-data
  begin
    dup end-mark <> while
    n swap - dup to n emit
  repeat
  drop
;


\ Now do it
cr cr
." Secret message #3:"
cr cr
10 do-stuff
cr cr

