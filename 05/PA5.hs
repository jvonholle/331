-- PA5.hs
-- Jimmy Von Holle
-- 3-29-2016
-- CS 331 Homework 5B

module PA5 where

import Data.Fixed -- for `mod`



-- collatz
-- given number and count
-- returns number of calls it takes to reach 0 case
collatz 1 count = count
collatz n count = 
    if n `mod` 2 == 0 then collatz (div n 2) (count+1)
    else collatz (3*n + 1) (count+1)
    
-- collatzS
-- given number
-- calls collatz with starting value of 0
collatzS n = collatz (n+1) 0
            
-- collatzCounts
-- list of integers where the value at i is the number of iterations
--   it takes to get from i+1 to 1 using the Collatz function
--
--   ex:
--      first 10 [0,1,7,2,5,8,16,3,19,6]
-- 
-- Collatz function is the following:
--     c(n) = 3n + 1 if n is odd
--     c(n) = n/2 if n is even
collatzCounts = map collatzS [0..]

-- listfinder
-- helper function for findList
listfinder list0 list1 count pos start pos1 = 
    if (length list0) <= 0 then 0
    else if pos1 >= (length list0) then start
    else if pos >= (length list1) && pos1 == 0 then (-10)
    else if pos >= (length list1) then listfinder list0 list1 (count+1) (pos+1) start (0)
    else if list0 !! pos1 == list1 !! pos && start == -10 then listfinder list0 list1 (count+1) (pos+1) pos (pos1+1)
    else if list0 !! pos1 == list1 !! pos then listfinder list0 list1 (count+1) (pos+1) start (pos1+1)
    else (listfinder list0 list1 0 (pos+1) (-10) 0)

-- findList
-- given two lists
-- if first list is found in second
-- returns index where it starts
-- otherwise returns "Nothing"
findList list0 list1 
    | (listfinder list0 list1 0 0 (-10) 0) /= (-10) = Just (listfinder list0 list1 0 0 (-10) 0)
    | otherwise = Nothing
            
-- finder
-- helper function for ## operator
finder list0 list1 pos count = 
    if pos >= (length list0) || pos >= (length list1) then count
    else if list0 !! pos == list1 !! pos then finder list0 list1 (pos+1) (count+1)
    else finder list0 list1 (pos+1) count

-- Infix operator ##
-- takes two lists of the same type
-- returns count of matching indexes
list0 ## list1 = finder list0 list1 0 0

-- filterAB
-- takes a boolean function and two lists
-- if index i of the first list makes the function true
-- returns i of the second list
filterAB boolfunct [] [] = []
filterAB boolfunct [] (list:lists) = []
filterAB boolfunct (list:lists) [] = []
filterAB boolfunct (list0:list0s) (list1:list1s)  
    | boolfunct list0 = list1:rest
    | otherwise = rest where
    rest = filterAB boolfunct list0s list1s
        
-- filterEO
-- helper function for sumEvenOdd
filterEO list pos rlist0 rlist1 = 
    if pos >= (length list) then (foldl (+) 0 rlist1, foldl (+) 0 rlist0)
    else if pos `mod` 2 == 0 then filterEO list (pos+1) rlist0 (list !! pos : rlist1)
    else filterEO list (pos+1) (list !! pos : rlist0) rlist1

-- sumEvenOdd
-- taks a list of numbers
-- returns sum of the even and a sum of the odd indexes as a tuple
sumEvenOdd list = filterEO list 0 [] []
