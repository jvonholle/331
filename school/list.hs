-- list.hs
-- Glenn G. Chappell
-- 26 Feb 2016
--
-- For CS 331 Spring 2016
-- Code from 2/26: Haskell Lists

module Main where

main = do
    putStrLn ""
    putStrLn "This file contains sample code from February 26, 2016."
    putStrLn "It will execute, but it is not intended to do anything"
    putStrLn "particularly useful."
    putStrLn ""
    putStrLn "The point is to have code that you can mess with. Open"
    putStrLn "the source in an editor. Try typing the suggested lines"
    putStrLn "in GHCi. Modify the code and see what happens."
    putStrLn ""


-- ***** Lists & Tuples ****


a1 = [3,8,2,9]           -- 4-item list
a2 = []                  -- Empty list

-- List items can be any type, but must be all same type.

a3 = [[8.32,-3.0],[],[4.6]]
                         -- List of lists of Double

fa1 x = x+1
fa2 x = x+2
fa3 x = x+3
a4 = [fa1, fa2, fa3]     -- List of functions (all same function type!)

--   a5 = [1, [2]]       -- Will not compile; different item types

-- Type of list written as brackets around type of item.
-- Try:
--   :t [True, False]

-- A string (double quotes) is a list of characters (single quotes).
sc1 = "abc"
sc1' = ['a', 'b', 'c']   -- Same as sc1

-- Tuples -- which are NOT lists -- can have items of different types

a5 = (3, False, [2.7])   -- 3-item tuple

-- Try:
--   :t a5

-- Try:
--   :t [1, 2]
--   :t [1, 2, 3]
--   :t (1, 2)
--   :t (1, 2, 3)

-- Haskell also has arrays, but they are neither as convenient nor as
-- efficient as the arrays we are used to. I would not worry about them
-- too much.


-- ***** List Primitives *****


-- 3 primitive operations on lists:

-- (1) Empty-list construction
b1 = []

-- (2) Cons (make list from item+list), using colon (:) operator
b2 = 2:[3,8,4]           -- b2 is [2,8,3,4]
b3 = 2:3:8:4:[]          -- b3 is [2,8,3,4] (":" is right-associative)
b4 = 5:b3                -- b4 is [5,2,8,3,4]

-- Basic list syntax is syntactic sugar around primitives (1) & (2)
-- [1,2] is same as 1:2:[]

-- (3) Pattern matching for lists
isEmpty [] = True
isEmpty (x:xs) = False   -- Parens: func application is high precedence!
-- Pattern x:xs matches nonempty lists. x is bound to the first item,
-- and xs is bound to a list holding the rest of the items. Think of xs
-- as a plural: "x and some xs".

-- We can also use a pattern like "(a:b:c:d:as)". This will match any
-- with at least 4 items.


-- ***** Other List Syntax *****


-- Range syntax uses ".."

-- There are 4 (and only 4) ways of doing ranges:
c1 = [7..20]            -- [7,8,9,10,11,12,13,14,15,16,17,18,19,20]
c2 = [7..]              -- infinite list: [7,8,9,10, ...
c3 = [7,10..20]         -- [7,10,13,16,19]
c4 = [7,10..]           -- infinite list: [7,10,13,16, ...

-- Above are wrappers around functions overloaded using the Enum type
-- class.
c1' = enumFromTo 7 20   -- Same as c1; below are similar
c2' = enumFrom 7
c3' = enumFromThenTo 7 10 20
c4' = enumFromThen 7 10

-- List comprehensions

c5 = [x*x | x <- [1..5]]
                         -- [1,4,9,16,25]
c6 = [x | x <- [1..12], mod x 2 == 1]
                         -- [1,3,5,7,9,11]
c7 = [[x,y] | x <- [1..5], y <- [1..4], x < y]
                         -- [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]]


-- ***** Lists & Recursion *****


-- Common way of doing recursion on lists:
-- - base case is [],
-- - recursive case is (x:xs)

-- mySize
-- Return the size of a given list.
--   mySize [1..10]
-- gives
--   10
mySize [] = 0
mySize (x:xs) = 1 + mySize xs

-- Try:
--   mySize [1000..10000]
--   mySize "Hello!"
-- This operation is available in the standard function "length".
--   length [1000..10000]
--   length "Hello!"

-- myConcat
-- Return the concatenation of two given lists.
--   myConcat [1,5] [4,8,3]
-- gives
--   [1,5,4,8,3]
myConcat [] ys = ys
myConcat (x:xs) ys = x:(myConcat xs ys)
    -- 2nd set of parens in previous line is only for clarity

-- Try:
--   myConcat "aard" "vark"
-- This operation is available in the standard operator "++".
-- Try:
--   "aard" ++ "vark"

-- square
-- Returns the square of its parameter.
-- Function to use with myMap, map.
square x = x*x

-- myMap
-- Apply a function to each item of a list.
--   myMap (\x -> x*x) [1,7,3]
-- gives
--   [1,49,9]
myMap _ [] = []
myMap f (x:xs) = (f x):(myMap f xs)
-- The pattern "_", above, matches anything, like a variable, but
-- cannot be used on the right-hand side. It thus marks an unused parameter.

-- Try:
--   myMap square [1..10]
-- This operation is available in the standard function "map".
-- Try:
--   map square [1..10]

-- A list recursion that does not follow the above pattern:

-- lookInd
-- Lookup by index, zero-based.
--   lookInd 2 [8,3,7,4,99]
-- gives
--   7
lookInd 0 (x:xs) = x
lookInd n (x:xs) = lookInd (n-1) xs

-- Try:
--   lookInd 1 [5,8,3]
--   lookInd 20 [5,8,3]
-- This operation is available in the standard operator "!!".
-- Try:
--   [5,8,3] !! 1

