-- squarethem.hs
-- Glenn G. Chappell
-- 4 Mar 2016
--
-- For CS 331 Spring 2016
-- CS-201-Style Haskell Program

module Main where

import System.IO  -- for hFlush


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


-- main
-- Demonstrate squareThem.
main = squareThem

