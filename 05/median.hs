-- median.hs
-- Jimmy Von Holle
-- 3-29-2016
-- CS 331 Homework 5C

module Main where

import System.IO -- for hFlush
import Data.List -- for sort

-- median
-- takes a list
-- retuns median
median list = mid where
    mid = (sList !! (div (length sList) 2)) where
        sList = sort list

-- printMed
-- takes input from user 
--      #####################################################################
--      # ONLY TAKES A LIST ENCLOSED BY SQUARE BRAKETS SEPARATED BY COMMAS  #
--      #####################################################################
-- prints median of given list
-- asks user if they want to compute another
-- loops if chosen, returns if not
printMed = do
    putStrLn ""
    putStr "Enter comma separated list of numbers, enclosed in square braces: "
    hFlush stdout
    line <- getLine
    let n = read line

    if n/= [0..] then do
        putStrLn ""
        putStr "Median is: "
        putStrLn (show (median n))
        putStrLn ""
        putStr "Do you want to compute another? (y/n): "
        hFlush stdout
        line1 <- getLine
        if line1 == "y" then printMed
        else return ()
    else printMed

-- main
-- calls printMed
main = do
    printMed
    putStrLn "Bye Bye!"
    return ()
