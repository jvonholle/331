\ var.fs
\ Glenn G. Chappell
\ 21 Mar 2016
\
\ For CS 331 Spring 2016
\ Code from 3/21: Forth Variables & Allocation


cr cr
." This file contains sample code from March 21, 2016." cr
." It will execute, but it is not intended to do anything" cr
." particularly useful." cr
cr
." The point is to have code that you can mess with. Open" cr
." the source in an editor. Try typing the suggested lines" cr
." in Gforth. Modify the code and see what happens." cr
cr


\ ***** Constants *****


\ Define a constant:
\   VALUE constant ID

10 constant qq

\ Try:
\   qq .


\ ***** Global Variables *****


\ To allocate space for an int and create a word that pushes a pointer
\ to it:
\   variable ID

variable p

\ The above is more or less equivalent to the following C++:
\   int * p = new int;

\ Try:
\   p .
\ Remember that p pushes a pointer.

\ To get the value stored at an address - fetch:
\   @  ( addr -- value )

\ To change the value stored at an address - store:
\   !  ( value addr -- )

\ Try:
\   23 34 + p !

\ The above is more or less equivalent to the following C++:
\  (*p) = 23 + 34;

\ Try:
\   p @ .

\ The above is more or less equivalent to the following C++:
\  cout << (*p) << " ";

\ Below is a fast fibo WITHOUT variables.

\ advance
\ Given pair of consecutive Fibonacci numbers (F[n], F[n+1]), returns
\ next such pair (F[n+1] F[n+2]).
\ Used by fibofast.
: advance  ( a b -- b a+b )
  swap over +
;

\ fibofast
\ Compute F[n]: the nth Fibonacci number.
\ F[0] = 0. F[1] = 1. For n >= 2, F[n] = F[n-2] + F[n-1].
\ Uses fast iterative algorithm.
\ Gives correct results:
\ - On 32-bit systems, for n = 0 .. 46
\ - On 64-bit systems, for n = 0 .. 92
: fibofast  ( n -- F[n] )
  1 0
  rot 0 ?do
    advance
  loop
  nip
;

\ And below is a fast fibo WITH variables.

variable n
: fibofast2  ( n -- F[n] )
  n !  \ Store parameter in memory pointed to by n
  1 0
  n @ 0 ?do
    advance
  loop
  nip
;

\ Try:
\   30 fibofast2 .


\ ***** Arrays *****


\ Allocate an array of ints:
\   allocate  ( len -- addr failure )
\ Above, "failure" is an error code. It will be zero if the array was
\ successfully allocated. IMPORTANT: len is number of BYTES, not
\ number of ints. You may assume that an int is 8 bytes.

variable arr          \ Will hold pointer to array
8 10 * allocate drop  \ No error checking; I'm a bad, bad person. :-(
arr !                 \ Now arr holds a pointer to an array of ten
                      \  8-byte integers

\ We can access the array using set & fetch.

\ arr@ - fetch from above array
: arr@  { index -- value }
  arr @       \ Address of array
  index 8 *   \ Byte index of desired item
  +           \ Stack: address-of-item
  @
;

\ arr! - store in above array
: arr!  { value index -- }
  arr @       \ Address of array
  index 8 *   \ Byte index of desired item
  +           \ Stack: address-of-item
  value swap  \ Stack: value address-of-item
  !
;

\ Try:
\   25 5 arr!
\   36 6 arr!
\   5 arr@ .
\   6 arr@ .


\ Note: the s" syntax is for constant strings. Do not use it to allocate
\ memory whose contents you wish to modify.


\ ***** Named Parameters *****


\ Make named parameters by changing parentheses to braces in the
\ stack-effect notation comment in a word's definition.

\ Here is a swap using named parameters.

: myswap  { a b -- b a }
  b a
;

\ The above pops two values off the stack, and calls them b and a.
\ Anything after the "--" is just a comment. Inside the definition of
\ myswap, a pushes the first parameter (no "fetch" necessary!) and b
\ pushes the second.

\ Here is the "advance" operation for the fast Fibonacci computation,
\ implemented using named parameters.

: advancex  { a b -- b a+b }
  b
  a b +
;

\ Below is a fast fibo using named parameters.

: fibofastx  { n -- F[n] }
  1 0
  n 0 ?do
    advancex
  loop
  nip
;

\ Try:
\   30 fibofastx .

\ And below is a slow fibo using named parameters.

: fibox  { n -- F[n] }
  n 2 < if
    n
  else
    n 2 - recurse
    n 1 - recurse
    +
  then
;

\ The named-parameter syntax may be used at any point in the definition
\ of a word. It pops values off the stack and binds names to them. If
\ there is nothing after the "--", then it may be omitted.

: fibox2  { n -- F[n] }
  n 2 < if
    n
  else
    n 2 - recurse { f2 }
    n 1 - recurse { f1 }
    f1 f2 +
  then
;

\ Change a named parameter as follows:
\   VALUE to ID

\ Below is a fast fibo using this idea with the general-iteration
\ construction.

: fibofastx2  { n -- F[n] }
  1 0
  begin
    n 0 > while
    advancex
    n 1 - to n
  repeat
  nip
;

\ Try:
\   30 fibofastx2

