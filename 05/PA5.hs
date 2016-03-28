-- PA5.hs
-- Jimmy Von Holle
-- 3-29-2016
-- CS 331 Homework 5 exB

module PA5 where

import Data.Fixed -- for mod`

-- collatzCounts
-- list of integers where i is the number of iterations
--   it takes to get from i+1 to 1
--
--   ex:
--      first 10 [0,1,7,2,5,8,16,3,19,6]
-- 
-- Collatz function is the following:
--     c(n) = 3n + 1 if n is odd
--     c(n) = n/2 if n is even

collatz 0 = 1
collatz n = 
            if n `mod` 2 == 0 then n/2
            else 3*n + 1

countCollatz n = 0

collatzCounts a = map countCollatz[0..]

findList a b = Just 0 

a ## b = 2

filterAB boolfunct list1 list2 = [0..]
sumEvenOdd list1 = 0
