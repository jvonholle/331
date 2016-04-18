-- io2.hs
-- Glenn G. Chappell
-- 4 Mar 2016
--
-- For CS 331 Spring 2016
-- Code from 3/4: Haskell I/O Part II

module Main where

import System.IO  -- for openFile, ReadMode, hGetContents, hFlush,
                  -- hClose

main = do
    putStrLn ""
    putStrLn "This file contains sample code from March 4, 2016."
    putStrLn "It will execute, but it is not intended to do anything"
    putStrLn "particularly useful."
    putStrLn ""
    putStrLn "The point is to have code that you can mess with. Open"
    putStrLn "the source in an editor. Try typing the suggested lines"
    putStrLn "in GHCi. Modify the code and see what happens."
    putStrLn ""


-- ***** Using "return" *****


-- Inside a I/O do-block, "return" creates a do-nothing I/O action
-- wrapping a value of our choice. It does NOT return.
--
--     return x
-- gives a do-nothing I/O action wrapping the value x.
--
--     return ()
-- gives a do-nothing I/O action wrapping a "nothing" value.

-- myGetLine
-- Same as getLine, but showing how to write it.
-- Uses "return".
myGetLine = do
    c <- getChar  -- getChar does what you think;
                  --  return value is I/O-wrapped Char
    if c == '\n'
        then return ""
        else do
            rest <- myGetLine
            return (c:rest)

-- Note: Expressions in a I/O do-block need to return I/O actions, but
--  they can be complicated expressions, like if-then-else above.

-- reverseIt'
-- Same as reverseIt, but rewritten to use myGetLine.
reverseIt' = do
    putStr "Type some text [we're using myGetLine!]: "
    hFlush stdout      -- Make sure prompt comes before input
    line <- myGetLine
    putStrLn ""
    putStrLn ("Line length: " ++ show (length line))
    putStrLn ""
    putStr "Here is your line, backwards: "
    putStrLn (reverse line)

-- Try:
--   reverseIt'


-- ***** Using "let" in a do-block *****


-- Final bit of do-block syntax: let NAME = EXPRESSION binds a name to a
--  NON-I/O value, for remainder of do-block.

-- squareThem
-- Repeatedly input a number from the user. If 0, then quit; otherwise
--  print its square, and repeat.
-- Uses "let" in do-block.
squareThem = do
    putStr "Type a number (0 to quit): "
    hFlush stdout      -- Make sure prompt comes before input
    line <- getLine    -- Bind name to I/O-wrapped value
    let n = read line  -- Bind name to non-I/O value
                       -- Compiler knows n is a number by how it is used
    if n == 0
        then return () -- Must have I/O action here, so make it null
        else do
            putStrLn ""
            putStr "Squaring, we get: "
            putStrLn (show (n*n))
            putStrLn ""
            squareThem   -- repeat

-- Try:
--   squareThem

-- Also see file squarethem.hs


-- ***** Types & Classes *****


-- Defining a new type

data IandB = IB (Integer, Bool)

-- The above defines a type IandB, each value of which holds an Integer
-- and a Bool. "IB" is a constructor; it begins IandB literals, and it
-- can be used for pattern matching.

incMaybe :: IandB -> IandB
incMaybe (IB (i, b)) = IB (newI, b) where
    newI = if b then (i+1) else i

-- Try:
--   incMaybe (IB(5,True))
--   incMaybe (IB(5,False))
-- Note: The results of the above can be printed only because IandB is
-- placed into type class Show; we do this below.

ibFirst :: IandB -> Integer
ibFirst (IB (i, _)) = i

ibSecond :: IandB -> Bool
ibSecond (IB (_, b)) = b

-- Try:
--   ibFirst (IB(5,True))
--   ibSecond (IB(5,True))


-- Placing a type into a type class

-- A type class is a collection of types each of which implements some
-- interface. Type classes are Haskell's mechanism for overloading
-- functions.

-- We place IAndB into class Show, defining the show function. This
-- allows us to print values of type IandB. We can do (show x) for x of
-- type IandB. And we can type
--     IB (1, True)
-- at the GHCi prompt without getting an error. We can also print lists
-- of IandB values, etc.
instance Show IandB where
    show (IB (i, b)) = "IB(" ++ show i ++ "," ++ show b ++ ")"

-- We place IAndB into class Eq, defining the "==" operator. The "/="
-- operator is defined for us (in the obvious way).
instance Eq IandB where
    IB (i1, b1) == IB (i2, b2)  =  (i1 == i2) && (b1 == b2)

-- Try:
--   IB(1,True) == IB(1,True)
--   IB(1,True) == IB(2,True)
--   IB(1,True) /= IB(2,True)


-- Type class Monad consists of those (parametrized) types that can be
-- used in a do-block. IO is a Monad. So is [ ... ] (lists). In fact,
-- do-blocks actually form a generalization of list comprehensions.
-- They are thus called "monad comprehensions".

-- A list comprehension
com = [ (x,y) | x <- [1,2], y <- [1,3], x <= y ]

-- The same as a monad comprehension
-- Deals with lists, not IO!
com' = do
    x <- [1,2]
    y <- [1,3]
    if x <= y
        then return (x,y)  -- For lists, return x is just [x].
        else []

-- Try:
--   com
--   com'


-- ***** File I/O *****


-- File I/O can be done within the I/O wrapper.
-- Open a file with openFile (defined in the IO module, which must be
-- imported). Two arguments:
--   - String giving path of file (official parameter type is FilePath,
--     but this is just an alias for String).
--   - IOMode constant telling how to open file. Options: ReadMode,
--     WriteMode, AppendMode, ReadWriteMode.
-- The return value is an IO-wrapped file handle.
-- After opening, do I/O using functions that are the same as before,
-- except that an "h" is prepended to their names ("hGetLine",
-- "hPutStr"), and the file handle is an additional first argument.

-- printFile
-- Given String holding path of file, prints file contents
printFile filePath = do
    f <- openFile filePath ReadMode
    lines <- hGetContents f
    putStr lines
    hClose f

-- Try:
--   printFile "io2.hs"

