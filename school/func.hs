-- func.hs
-- Glenn G. Chappell
-- 24 Feb 2016
--
-- For CS 331 Spring 2016
-- Code from 2/24: Haskell Functions

module Main where

main = do
    putStrLn ""
    putStrLn "This file contains sample code from February 24, 2016."
    putStrLn "It will execute, but it is not intended to do anything"
    putStrLn "particularly useful."
    putStrLn ""
    putStrLn "The point is to have code that you can mess with. Open"
    putStrLn "the source in an editor. Try typing the suggested lines"
    putStrLn "in GHCi. Modify the code and see what happens."
    putStrLn ""


-- ***** Defining Functions & Operators *****


-- Ordinary function
addem a b = a+b

-- Infix operator
a +$+ b = 2*(a+b)

-- Try:
--   addem 2 3
--   2 +$+ 3

-- We can use a normal function as an infix operator
-- Try:
--   2 `addem` 3

-- And we can use an operator as a normal function
-- Try:
--   (+$+) 2 3

-- Function types
-- Try:
--   :t addem
--   :t (+$+)
--   :t 4.5


-- ***** Local Definitions *****


-- Use "where" to introduce a block (indent!) of local definitions

plus_minus_times a b c d = a_plus_b * c_minus_d where
    a_plus_b = a + b
    c_minus_d = c - d

-- Try:
--   plus_minus_times 1 2 3 4
--   a_plus_b
-- Above, the first should work, but the second should result in an
-- error; the definition of a_plus_b is *local*.

-- We can nest blocks

twicefactorial n = twice (factorial n) where
    twice k = two*k where
        two = one + one where
            one = 1
    factorial 0 = 1
    factorial curr = curr * factorial prev where
        prev = curr-1


-- ***** Function Application & Currying *****


-- Try:
--   (addem 2) 3

-- Try:
--   addem (2 3)
-- You should get an error.

add2 = addem 2

-- Try:
--   add2 3
--   add2 7
--  :t add2


-- ***** Higher-Order Functions *****


-- We can write functions that toss around functions.

-- rev
-- If f is a 2-argument function, then (rev f) is a 2-argument
--  function that takes its arguments in the opposite order.
rev f a b = f b a

sub a b = a-b
rsub = rev sub

-- Try:
--   sub 7 4
--   sub 4 7
--
--   rsub 7 4
--   rsub 4 7


-- ***** Lambda Expressions *****


-- Two ways to define a function
square x = x*x

square' = \ x -> x*x  -- \ x -> x*x is an unnamed function
                      --  ("lambda expression" or "lambda function")

-- Try:
--   square' 5
--   (\ x -> x*x) 5

-- The following do the same computation as function addem
addem' = \ x y -> x+y

addem'' a = \ y -> a+y

addem''' = \ x -> (\ y -> x+y)

