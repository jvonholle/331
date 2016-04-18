-- io1.hs
-- Glenn G. Chappell
-- 2 Mar 2016
--
-- For CS 331 Spring 2016
-- Code from 3/2: Haskell I/O Part I

module Main where

main = do
    putStrLn ""
    putStrLn "This file contains sample code from March 2, 2016."
    putStrLn "It will execute, but it is not intended to do anything"
    putStrLn "particularly useful."
    putStrLn ""
    putStrLn "The point is to have code that you can mess with. Open"
    putStrLn "the source in an editor. Try typing the suggested lines"
    putStrLn "in GHCi. Modify the code and see what happens."
    putStrLn ""


-- ***** String Conversion *****


-- Function "show" converts anything showable (type must be in class
-- Show) to a String.

-- numConcat
-- Returns string containing 2 params separated by blank.
-- So (numConcat 42 7) returns "42 7".
numConcat a b = (show a) ++ " " ++ (show b)

-- Try:
--   numConcat 42 7


-- Function "read" converts a string to anything (type must be in class
-- Read).

-- Try:
--   read "42"
-- Result is error; need to force return type.


stringPlusOne str = 1 + read str

stringToInteger str = asTypeOf (read str) 1

-- Try:
--   stringPlusOne "42"
--   stringToInteger "42"


-- ***** Simple Output *****


-- An I/O action is type of value. We do I/O by returning an I/O action
-- to the outside world.

sayHowdy = putStr "Howdy!"

sayHowdyNewLine = putStrLn "Howdy!"

-- "print x" is same as "putStrLn (show x)"

sayTenNewLine = print (5+5)

-- Use ">>" to join I/O actions together into a single I/O action

sayHowdy2Line = (putStrLn "Howdy" >> putStrLn "thar!")

-- Try:
--   sayHowdy
--   sayHowdyNewLine
--   sayTenNewLine
--   sayHowdy2Line


-- ***** Simple Input *****

-- An I/O action wraps a value. The above I/O actions all wrapped
-- "nothing" values. getLine returns an I/O action that wraps the string
-- that is input.

-- Send the wrapped value to a function with ">>="

getPrint =    getLine >>= putStrLn
getPrint' =   getLine >>= (\ line -> putStrLn line)
getPrintRev = getLine >>= (\ line -> putStrLn (reverse line))

-- The wrapped value cannot be removed from the I/O world, but it can be
-- processed inside it (e.g., the above call to function reverse).

-- Try:
--   getPrint
--   getPrint'
--   getPrintRev


-- ***** do Notation *****

-- A do block is simple syntactic sugar around the ">>" and ">>="
-- operators.

-- reverseIt
-- Input some text from the user, and print something based on it.
reverseIt = do
    putStr "Type some text: "
    line <- getLine
    putStrLn ""
    putStrLn ("Line length: " ++ show (length line))
    putStrLn ""
    putStr "Here is your line, backwards: "
    putStrLn (reverse line)

-- Try:
--   reverseIt

