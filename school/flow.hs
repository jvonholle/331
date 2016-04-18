-- flow.hs
-- Glenn G. Chappell
-- 29 Feb 2016
--
-- For CS 331 Spring 2016
-- Code from 2/29: Haskell Flow of Control

module Main where

main = do
    putStrLn ""
    putStrLn "This file contains sample code from February 29, 2016."
    putStrLn "It will execute, but it is not intended to do anything"
    putStrLn "particularly useful."
    putStrLn ""
    putStrLn "The point is to have code that you can mess with. Open"
    putStrLn "the source in an editor. Try typing the suggested lines"
    putStrLn "in GHCi. Modify the code and see what happens."
    putStrLn ""


-- ***** Pattern Matching & Recursion *****


-- mySize
-- (mySize xs) returns length of given list.
-- So (mySize [4,5,2]) returns 3.
-- Same as Standard Library function length.
mySize [] = 0
mySize (x:xs) = 1 + mySize xs

-- Try:
--   mySize [1..50]

-- myIf
-- Returns 2nd argument if 1st is true, 3rd if 1st is false.
myIf True  tval _    = tval
myIf False _    fval = fval

-- Try:
--   myIf (3 > 4) "yes" "no"


-- ***** Selection *****


-- Guards

-- myAbs
-- Returns absolute value of argument.
-- Same as Standard Library function abs.
myAbs x
    | x >= 0     = x   -- First line with True expression is used
    | otherwise  = -x  -- "otherwise" same as "True"

-- stringSign
-- Returns sign of argument, as string ("positive", "negative", "zero").
stringSign x
    | x > 0      = "positive"
    | x < 0      = "negative"
    | otherwise  = "zero"

-- Try:
--   stringSign (3-6)

-- If-Then-Else

-- Another version of myAbs.
myAbs' x = if x >= 0 then x else (-x)

-- Try:
--   myAbs' (-3)


-- Case

-- fibocase
-- Like good 'ol fibo, but using a case construction.
fibo n = case n of
    0 -> 0
    1 -> 1
    _ -> fibo (n-2) + fibo (n-1)


-- ***** Fatal Errors *****


-- error :: String -> a
-- Crashes program on execution, displaying given error message.

-- lookInd'
-- Lookup by index, zero-based.
-- Like lookInd from last time.
lookInd' n [] = error "lookInd': Subscript out of range"
lookInd' 0 (x:_) = x
lookInd' n (_:xs) = lookInd' (n-1) xs

-- Try:
--   lookInd' 2 [1,2,3,4]
--   lookInd' 20 [1,2,3,4]

-- undefined :: a
-- Crashes program on execution, displaying fixed error message.

-- fiboFast'
-- Improved Fibonacci function.
fiboFast' n
    | n < 0      = undefined
    | otherwise  = a where
        (a, b) = fiboPair n
        fiboPair 0 = (0, 1)
        fiboPair n = (d, c+d) where
            (c, d) = fiboPair (n-1)

-- Try:
--   fiboFast' 8
--   fiboFast' 1000
--   fiboFast' (-2)


-- ***** Simulating Exceptions *****


-- An "Maybe" type is either "Just" followed by a value of some
-- specified type, or "Nothing". We can use Nothing as an error flag.

mySqrt :: (Maybe Double) -> (Maybe Double)
mySqrt Nothing = Nothing
mySqrt (Just x)
    | x >= 0.0   = Just (sqrt x)
    | otherwise  = Nothing

-- Try:
--   mySqrt (Just 3.0)
--   mySqrt (Just (-3.0))
--   mySqrt (mySqrt (Just 3.0))
--   mySqrt (mySqrt (Just (-3.0)))


infixl 7 @/  -- Set left associativity, precedence for @/
(@/) :: (Maybe Double) -> (Maybe Double) -> (Maybe Double)
Nothing @/ _ = Nothing            -- Propagate "exception"
_ @/ Nothing = Nothing            -- Propagate "exception"
(Just _) @/ (Just 0.0) = Nothing  -- New "exception"
(Just x) @/ (Just y) = Just (x / y)

infixl 7 @*  -- Set left associativity, precedence for @*
(@*) :: (Maybe Double) -> (Maybe Double) -> (Maybe Double)
Nothing @* _ = Nothing            -- Propagate "exception"
_ @* Nothing = Nothing            -- Propagate "exception"
(Just x) @* (Just y) = Just (x * y)

infixl 6 @+  -- Set left associativity, precedence for @+
(@+) :: (Maybe Double) -> (Maybe Double) -> (Maybe Double)
Nothing @+ _ = Nothing            -- Propagate "exception"
_ @+ Nothing = Nothing            -- Propagate "exception"
(Just x) @+ (Just y) = Just (x + y)

infixl 6 @-  -- Set left associativity, precedence for @-
(@-) :: (Maybe Double) -> (Maybe Double) -> (Maybe Double)
Nothing @- _ = Nothing            -- Propagate "exception"
_ @- Nothing = Nothing            -- Propagate "exception"
(Just x) @- (Just y) = Just (x - y)

-- Some numerical values, for convenience
n0 = Just 0.0
n1 = Just 1.0
n2 = Just 2.0
n3 = Just 3.0

-- Try:
--   n3 @/ n2
--   n3 @/ (n2 @- n2)
--   n0 @- n3 @/ (n2 @- n3 @+ n1) @* n2
--   n1 @/ mySqrt (n0 @- n2)
--   mySqrt n3 @/ n0


-- ***** Encapsulated Loops *****


-- map: Apply function to each item of list

-- square
-- Returns square of a number - for use with map.
square x = x*x

-- myMap
-- Applies function to each item of a list.
-- Same as Standard Library function map.
myMap f [] = []
myMap f (x:xs) = f x : myMap f xs

-- Try:
--   myMap square [1,4,6]
--   map square [1,4,6]
--   [ square x | x <- [1,4,6] ]


-- filter: Return list of items in a given list meeting some condition

-- myFilter
-- Returns list of all items for which boolean func returns True.
-- Same as Standard Library function filter.
myFilter f [] = []
myFilter f (x:xs)
    | f x        = x:rest
    | otherwise  = rest where
    rest = myFilter f xs

-- Try:
--   myFilter (<= 2) [4,0,8,-2,1,6]
--   filter (<= 2) [4,0,8,-2,1,6]
--   [x | x <- [4,0,8,-2,1,6], x <= 2]


-- fold: Various functions for computing a value from a list

-- mySum
-- Returns sum of items in list.
-- Same as Standard Library function sum.
mySum [] = 0
mySum (a:as) = a + mySum as

-- Same thing, done with fold

-- mySum' - same as mySum.
mySum' xs = foldl (+) 0 xs

-- Try:
--   mySum [1..100]
--   mySum' [1..100]


-- ***** Preview: do *****


-- reverseIt
-- Prompt the user for input, read a line, and print it reversed.
reverseIt = do
    putStr "Type something: "
    line <- getLine
    putStrLn ""
    putStr "Your line, reversed: "
    putStrLn (reverse line)

-- Try:
--   reverseIt

