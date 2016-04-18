\ word.fs
\ Glenn G. Chappell
\ 11 Mar 2016
\
\ For CS 331 Spring 2016
\ Code from 3/11: Forth Words


cr cr
." This file contains sample code from March 11, 2016." cr
." It will execute, but it is not intended to do anything" cr
." particularly useful." cr
cr
." The point is to have code that you can mess with. Open" cr
." the source in an editor. Try typing the suggested lines" cr
." in Gforth. Modify the code and see what happens." cr
cr


\ ***** Basics *****


\ Backslash begins single-line comment
( Multiline
  comment
  in parentheses )

\ Words are case-insentitive: dup is the same as DUP

\ A number pushes that number on the stack.
\ .s shows the stack, top on the right.
\ clearstack clears the stack.

\ Try:
\   10 .s
\   1 2 3 .s
\   clearstack .s

\ . pops an integer off the stack and prints it, followed by a blank.

\ Try:
\   42 .
\   2 .s . .s
\   1 2 3 . . .

\ Popping with an empty stack is an error.

\ Try:
\   clearstack .

\ Arithmetic operators ( +, -, *, / ) pop two stack items, operate on
\ them, and push the result.

\ Try:
\   1 2 + .
\   5 10 * 5 5 * 3 * + .


\ ***** Defining Words *****


\ Stack-effect notation: ( STACK-BEFORE -- STACK-AFTER )
\ Examples:
\   3  ( -- 3 )
\   .  ( k -- )
\   +  ( a b -- a+b )

\ Define a word using
\   : WORD DEFINITION... ;
\ Stack-effect notation is a common comment.

\ f (version 1)
\ Multiplies by 2
: f  ( x -- 2x )
  2 *
;

\ Try:
\   5 f .
\ Note: If you defined f by including this file, then the above will not
\ print 10, since f is redefined below.

\ Using a word calls the PREVIOUSLY DEFINED version of that word.
\ Below, g uses the existing version of f.

\ g
\ Multiplies by 4
: g  ( x -- 4x )
  f f
;

\ See the definition of a word with
\   see WORD

\ Try:
\   see g

\ We can redefine words. For example, f is redefined below, but g still
\ uses the old version.

\ f (version 2)
\ Adds 7
: f  ( x -- x+7 )
  7 +
;

\ Try:
\   10 g .
\   10 f .
\   see f

\ We can redefine pretty much anything.

: 666 42 ;  \ Evil!!!

\ Try:
\   666 .
\   1 666 + .


\ ***** Stack Manipulation *****


\ Standard stack-manipulation words:
\   drop  ( a -- )
\   dup   ( a -- a a )
\   swap  ( a b -- b a )
\   rot   ( a b c -- b c a )
\   -rot  ( a b c -- c a b )
\   nip   ( a b -- b )
\   tuck  ( a b -- b a b )
\   over  ( a b -- a b a )

\ Note that there is no general principle behind rot & -rot -- these are
\ just two different words. They happen to be defined to have an
\ opposite effect.

\ Try:
\   1 2 3 drop .s
\   1 2 3 dup .s
\   1 2 3 swap .s
\ Etc.

\ Stack-manipulation words for dealing with pairs:
\   2drop  ( a1 a2 -- )
\   2dup   ( a1 a2 -- a1 a2  a1 a2 )
\   2swap  ( a1 a2  b1 b2 -- b1 b2  a1 a2 )
\   2rot   ( a1 a2  b1 b2  c1 c2 -- b1 b2  c1 c2  a1 a2 )
\   2nip   ( a1 a2  b1 b2 -- b1 b2 )
\   2tuck  ( a1 a2  b1 b2 -- b1 b2  a1 a2  b1 b2 )
\   2over  ( a1 a2  b1 b2 -- a1 a2  b1 b2  a1 a2 )

\ Try:
\   1 2 3 4 2drop .s
\ Etc.


\ ***** Flow of Control *****


\ Using a word in its own definition calls the PREVIOUSLY DEFINED
\ version of the word. To do a decursive call to word currently being
\ defined:
\   recurse

\ Selection:
\   COND if ... else ... endif

\ fibo
\ Compute F[n]: the nth Fibonacci number.
\ F[0] = 0. F[1] = 1. For n >= 2, F[n] = F[n-2] + F[n-1].
\ Uses slow recursive algorithm.
\ Gives correct results:
\ - On 32-bit systems, for n = 0 .. 46
\ - On 64-bit systems, for n = 0 .. 92
: fibo  ( n -- F[n] )
  dup        \ Stack: n n
  2 <        \ Stack: n n<2
  if
             \ Stack: n
             \ F[n] = n, so nothing left to do
  else
    dup      \ Stack: n n
    2 -      \ Stack: n n-2
    recurse  \ Stack: n F[n-2]
    swap     \ Stack: F[n-2] n
    1 -      \ Stack: F[n-2] n-1
    recurse  \ Stack: F[n-2] F[n-1]
    +        \ Stack: F[n]
  then
;

\ Try:
\   6 fibo .
\   35 fibo .

\ General Iteration:
\   begin ... COND while ... loop

\ Counted Loop
\ In C++:
\   for (int i = a; i < b; ++i)
\       ... i ...
\ In Forth:
\   b a ?do
\     ... i ...
\   loop

\ print1to10
\ Prints the numbers 1 to 10, all on a single line, each followed by a
\ blank, with a trailing newline.
: print1to10  ( -- )
  11 1 ?do
    i .  \ i pushes the loop counter
  loop
  cr     \ Print a newline
;

\ Try:
\   print1to10


\ ***** Strings *****


\ A standard way to represent a string is with two ints. The first is a pointer to the start of the string. The second is the number of characters in it.

\ Create such a string with "s followed by a single blank, then the string and a final double quote
\  "s ..."  ( addr len -- )

\ Try:
\   s" Hello!" .s

\ To print a string:
\   type  ( add len -- )

\ Try:
\   s" Hello!" type

\ To print a newline:
\   cr  ( -- )

: hello-world  ( -- )
  s" Hello, world!"
  type
  cr
;

\ Try:
\   hello-world

\ Combine s" and type with ."

\ Try:
\   ." Hello!"

