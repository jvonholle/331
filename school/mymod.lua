-- mymod.lua
-- Glenn G. Chappell
-- 1 Feb 2016
--
-- For CS 331 Spring 2016
-- Code from 2/1: Lua Example Module
-- Not a complete program


-- To use this module, do
--     mymod = require "mymod"
-- in some Lua program. Then call function "mymod.print_with_stars".


local mymod = {}  -- Our module


-- print_with_border
-- Given message and border character, prints message using the char as
-- the border.
-- NOT EXPORTED
local function print_with_border(msg, border)
    local n = msg:len()  -- length of string msg

    function line()
        for i = 1, n+4 do
            io.write(border)
        end
        io.write("\n")
    end

    line()
    io.write(border .. " " .. msg .. " " .. border .. "\n")
    line()
end


-- print_with_stars
-- Given message and border character, prints message surrounded by
-- stars.
-- EXPORTED
function mymod.print_with_stars(msg)
    print_with_border(msg, "*")
end


return mymod      -- Return the module, so client code can use it

