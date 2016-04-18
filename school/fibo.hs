-- fibo.hs
-- Glenn G. Chappell
-- 22 Feb 2016
--
-- For CS 331 Spring 2016
-- Compute Fibonacci Numbers

module Main where


-- The Fibonacci number F(n), for n >= 0, is defined by F(0) = 0,
-- F(1) = 1, and for n >= 2, F(n) = F(n-2) + F(n-1).


-- fibo
-- Given n >= 0, return Fibonacci number F(n).
-- Slow algorithm.
fibo 0 = 0
fibo 1 = 1
fibo n = fibo (n-2) + fibo (n-1)


-- fibopair
-- Given n >= 0, return a pair of Fibonacci numbers: (F(n), F(n+1)).
-- Used by fibofast.
fibopair 0 = (0, 1)
fibopair n = (b, a+b) where
    (a, b) = fibopair (n-1)


-- fibofast
-- Given n >= 0, return Fibonacci number F(n).
-- Fast algorithm. Uses fibopair.
fibofast n = a where
    (a, b) = fibopair n


-- allfibos
-- List of ALL Fibonacci numbers: [F(0), F(1), F(2), ...].
allfibos = map fibofast [0..]


-- main
-- Print list of first 20 Fibonacci numbers.
main = putStrLn (show (take 20 allfibos))

