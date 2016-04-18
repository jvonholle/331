#!/usr/bin/env lua
-- fibo.lua
-- Glenn G. Chappell
-- 1 Feb 2016
--
-- For CS 331 Spring 2016
-- Compute Fibonacci Numbers


-- fibo
-- Given n, return the Fibonacci number F(n), where F(0) = 0, F(1) = 1,
-- and F(n) = F(n-1)+F(n-2), for n >= 2.
function fibo(n)
    local a, b = 0, 1  -- Current & next Fibonacci number
    for  i = 1, n do
        a, b = b, a+b  -- Advance a, b as many times as needed
    end
    return a           -- a is our answer
end


-- Main program
-- Print Fibonacci numbers 0 to 10.
for i = 0, 20 do
    io.write("F("..i..") = "..fibo(i).."\n")
end

