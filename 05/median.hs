-- median.hs
-- Jimmy Von Holle
-- 3-29-2016
-- CS 331 Homework 5C

module Main where

import System.IO
import Data.List

median list = mid where
    mid = (sList !! (div (length sList) 2)) where
        sList = sort list

getNums = do
    putStr "Type a number, leave it empty to compute median: "
    hFlush stdout
    num <- getLine
    if num == "" then do
        return getNums
    else d
        rest <- getNums

printMed = do
    putStrLn "Hi, I'm here to calculate a median for you!"
    putStrLn "Here we go!"
    med <- median getNums
    putStrLn ("Your median is: " ++ med)
    putStr "Do you want to compute another? (y/n): "
    hFlush stdout
    line <- getLine
    let check = line
    if check == "y" then printMed
    else return()

main = printMed