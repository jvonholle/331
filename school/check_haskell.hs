-- check_haskell.hs
-- Glenn G. Chappell
-- 3 Feb 2016
-- Updated: 4 Feb 2016
--
-- For CS 331 Spring 2016
-- A Haskell Program to Run
-- Used in Assignment 2, Exercise A

module Main where


-- main
-- Print second secret message.
main = do
    putStrLn "Secret message #2:"
    putStrLn ""
    putStrLn secret_message


-- secret_message
-- A mysterious String.
secret_message = map ordToC ords where
    d1 = [94,30,7,-59,55,30,16,12,4,-57]
    d2 = [65,34,13,-4,25,-73,75,27,-3,-59]
    d3 = [61,40,14,-6,6,22,6,20,-1,-62]
    d4 = [57,46,10,0,7,22,-7,16,8]
    diffs = map (+ (-10)) $ concat[d1, d2, d3, d4]
    thisAndAdd x xs = x : map (+ x) xs
    ords = foldr thisAndAdd [] diffs
    ordToC n = toEnum n `asTypeOf` '@'

