\ collcount.fs
\ Jimmy Von Holle
\ 19 Apr 2016
\ CS 331

\ Defining % as MOD because I'm lazy
: % MOD ;

\ advance
\ pops n off the stack
\     checks if its even or odd
\     does collatz on it, pushes result
\  Collatz:
\       C(n) = { n / 2 if even
\              { 3 * n + 1 if odd
: advance { n -- C[n] }
  n 2 % 0 = if
    n 2 /
  else
    n 3 * 1 +
  then
;

\ collcount
\ counts how many times it takes to get from n
\ to 1 using Collatz function as described above
\ only pushes count to stack
variable count
: collcount { n -- c }
  n
  0 count !
  begin
  dup
    1 > while
    advance
    count @ 1 + count !
  repeat
  count @
  swap
  drop
;