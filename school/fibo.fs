\ fibo.fs
\ Glenn G. Chappell
\ 11 Mar 2016
\
\ For CS 331 Spring 2016
\ Compute Fibonacci Numbers


\ fibo
\ Compute F[n]: the nth Fibonacci number.
\ F[0] = 0. F[1] = 1. For n >= 2, F[n] = F[n-2] + F[n-1].
\ Uses slow recursive algorithm.
\ Gives correct results:
\ - On 32-bit systems, for n = 0 .. 46
\ - On 64-bit systems, for n = 0 .. 92
: fibo  ( n -- F[n] )
  dup 2 < if
      \ Stack: n
      \ Nothing left to do
  else
      dup 1 - recurse swap 2 - recurse +
      \ Stack: F(n)
  then
;


\ advance
\ Given pair of consecutive Fibonacci numbers (F[n], F[n+1]), returns
\ next such pair (F[n+1] F[n+2]).
\ Used by fibofast.
: advance  ( a b -- b a+b )
  swap    \ Stack: b a
  over    \ Stack: b a b
  +       \ Stack: b a+b
;


\ fibofast
\ Compute F[n]: the nth Fibonacci number.
\ F[0] = 0. F[1] = 1. For n >= 2, F[n] = F[n-2] + F[n-1].
\ Uses fast iterative algorithm.
\ Gives correct results:
\ - On 32-bit systems, for n = 0 .. 46
\ - On 64-bit systems, for n = 0 .. 92
: fibofast  ( n -- F[n] )
  1 0     \ Stack: n 1 0
  rot     \ Stack: 1 0 n
  0 ?do   \ Counted loop
    advance
  loop
          \ Stack: F[n-1] F[n]
  nip     \ Stack: F[n]
;


\ printfibos
\ Print i & Fibonacci number i, for i = 0..n, each on a separate line.
: printfibos  ( n -- )
  cr
  1 + 0 ?do
    i .
    i fibofast . cr
  loop
;


\ Main program
\ Print header, then first few Fibonacci numbers.
cr
." Fibonacci Numbers" cr
46  \ n for last F[n] to print; can change to 92 on a 64-bit system
printfibos

