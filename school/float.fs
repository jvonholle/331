\ float.fs
\ Glenn G. Chappell
\ 25 Mar 2016
\
\ For CS 331 Spring 2016
\ Code from 3/25: Forth Floating Point


cr cr
." This file contains sample code from March 25, 2016." cr
." It will execute, but it is not intended to do anything" cr
." particularly useful." cr
cr
." The point is to have code that you can mess with. Open" cr
." the source in an editor. Try typing the suggested lines" cr
." in Gforth. Modify the code and see what happens." cr
cr


\ ***** Floating-Point *****


\ sqrtsout
\ Prints numbers 1 .. 10 and their decimal square roots.
: sqrtsout  ( -- )
  1e
  cr
  11 1 ?do
    fdup f.
    ."    "
    fdup fsqrt f.
    cr
    1e f+
  loop
;

\ Try:
\   sqrtsout

