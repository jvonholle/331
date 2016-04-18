#!/usr/bin/env lua
-- check_lua.lua
-- Glenn G. Chappell
-- 22 Jan 2016
--
-- For CS 331 Spring 2016
-- A Lua Program to Run
-- Used in Assignment 1, Exercise A


-- A mysterious table
w = { [[Cg]], [=[twuj]=], [6]='Pxd'..[==[q|mql]==], [4]=[[et]]..'lss',
      [5]="zqxw", [3]="uq" }


-- And a mysterious function
function f(s)
    local a,b,r=1,1,42
    r=[===[]===]
    for n = 1,s:len() do
        r = r..string.char(string.byte(s,n)-(b%9))
        a,b = b,a+b
    end
    return r
end


-- Formatted output using the function and the table entries
io.write("Here is the secret message:\n\n")
io.write(string.format([[%s %]]..[==[s %s %s %]==]..'s %s.\n\n',
    f(w[1]), f(w[2]), f(w[3]), f(w[4]), f(w[5]), f(w[6])))

