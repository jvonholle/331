#!/usr/bin/env lua
-- prog1.lua
-- Glenn G. Chappell
-- 1 Feb 2016
-- Updated: 3 Feb 2016
--
-- For CS 331 Spring 2016
-- Code from 2/1: Lua Programming I
-- Requires mymod.lua


io.write("This file contains sample code from February 1, 2016.\n")
io.write("It will execute, but it is not intended to do anything\n")
io.write("particularly useful. See the source.\n")


-- ***** Variables, Values, Expressions *****


io.write("\n*** Variables, Values, Expressions:\n")

-- Single-line comment
--[[
Multiline
comment
--]]

-- Lua code does not need to be inside a function.
-- To make a variable, just set its value.
abc = "xyz"    -- String; literals use single or double quotes.
abc = 'xyz'

abc = [[xyz]]  -- Alternative string-literal syntax
abc = [==[xyz]==]
               -- The number of equals signs must be the same
               -- (A similar trick works for multiline comments)

-- Values have types; variables are just references to values.
-- So we can set a variable to a value of a different type.
abc = 3        -- Number

-- Arithmetic expressions are pretty much as usual.
bcd = (abc + 7) * 14

-- We can assign multiple values at once.
x, y = abc, 4  -- Equivalent to "x = abc" then "y = 4"
x, y = y, x    -- Easy way to swap

-- Eliminate a variable by setting it to "nil".
y = nil        -- Now y is gone

-- The function "print" prints things, followed by newline.
print(bcd)

-- But let's avoid using "print" for anything except quickie debugging
-- printout. io.write is nicer. It does not automatically print a
-- newline. Use the ".." operator to concatenate. Number-to-string
-- conversion is automatic, so you can do this:
io.write(-734.1 .. " " .. x+3 .. "\n")

-- Uncomment the following. When executed, a type error should be
-- flagged. But since Lua has dynamic type checking, the above output
-- will be done before the type error is flagged.

--io.write(1 / "abc")


-- ***** Functions *****


io.write("\n*** Functions:\n")

-- Define a function using the keyword "function". This is followed by
-- the name of the function, the parameter list (no types!) and then the
-- body. End the function with "end". Braces & semicolons are not
-- necessary.
function fibo(n)  -- Return the nth Fibonacci number
    local a, b = 0, 1
    for i = 1, n do
        a, b = b, a+b
    end
    return a
end
-- Note the syntax for the for loop and return statement above.
-- Also note the "local" keyword. Most variables default to global.
-- Make them local variables as above. Parameters (like n) and loop
-- counters (like i) default to local.

-- Lua does not care about newlines.
function fibo(n) local a,b=0,1 for i=1,n do a,b=b,a+b end return a end

-- Functions are called as usual.
io.write("The 8th Fibonacci number is " .. fibo(8) .. ".\n")

-- Lua has first-class functions. So a function is just another kind of
-- value. We could do it this way:
fibo = function(n)
        local a, b = 0, 1
        for i = 1, n do
            a, b = b, a+b
        end
    end

-- fibo is just a variable, whose value happens to be a function.
-- Treat it like any other variable.
fibo = 'blah blah blah'


-- ***** Tables ******


io.write("\n*** Tables:\n")

-- Lua does maps/dictionaries, arrays, objects, and classes using a
-- single language feature: a key-value structure called a "table".

-- Table literals use braces
capitals = { ["Alaska"]="Juneau", ["Kansas"]="Topeka" }
-- Above, there are two key-value pairs. One key is "Alaska"; the
-- associated value is "Juneau".

-- Access table values using braces.
io.write(capitals['Alaska'] .. "\n")  -- Should print "Juneau".

-- Set table values similarly.
capitals["New Jersey"] = "Trenton"

-- Delete a key from a table by setting the associated value to nil.
capitals["Kansas"] = nil

-- We can mix types of keys and values.
mixed = { [1]="howdy", ["abc"]=42, ["x"]=true }  -- Boolean: true, false

-- If a key looks like an identifier, then we can use dot syntax.
io.write(mixed.abc .. "\n")  -- Prints mixed["abc"], that is, 42.

-- We can put functions in tables
function hello()
    io.write("Hello there!\n")
end
mixed.h = hello
mixed.h()  -- Function call; should print "Hello there!"

-- We can declare a function to be a table member directly
function mixed.goodbye()
    io.write("Goodbye!\n")
end
mixed.goodbye()  -- Should print "Goodbye!"

-- We can make arrays out of tables. Subscripts start with ONE!
arr = { "x", 234, "lizard" }
-- Above is same as:
--     arr = { [1]="x", [2]=234, [3]="lizard" }


-- ***** Flow of Control *****


io.write("\n*** Flow of control:\n")

-- if-then
if 1+1 == 2 then
    io.write("1+1 is 2\n")
end

-- if-then-else
if 4*5 ~= 30 then  -- not-equal operator
    io.write("4*5 ~= 30\n")
else
    io.write("4*5 == 30\n")
end

-- also elseif
if 2+3 == 3 then
    io.write("2+3 == 2\n")
elseif 2+3 == 4 then
    io.write("2+3 == 4\n")
elseif 2+3 == 5 then
    io.write("2+3 == 5\n")
else
    io.write("2+3 is some other value\n")
end

-- while-loop
i = 2
while i <= 10 do  -- Will print "2 3 4 5 6 7 8 9 10".
    io.write(i .. " ")
    i = i+1  -- There is no "+=" or "++".
end
io.write("\n")

-- for-loop, counter based
for i = 2, 10 do  -- Will print "2 3 4 5 6 7 8 9 10".
    io.write(i .. " ")
end
io.write("\n")

-- for-loop with optional step
for i = 2, 10, 3 do  -- Will print "2 5 8".
    io.write(i .. " ")
end
io.write("\n")

-- for-in-loop, iterator based
tt = { "x", ["q"]=7, "y", "z" }
io.write("\n")
io.write("Loop #1\n")
for k, v in pairs(tt) do  -- Loops over all keys.
    io.write("key: " .. k .. "; value: " .. v .. "\n")
end
io.write("\n")
io.write("Loop #2\n")
for k, v in ipairs(tt) do  -- Loops over all keys 1, 2, 3
                           -- until one is missing.
    io.write("key: " .. k .. "; value: " .. v .. "\n")
end
-- Compare the output of the two loops above

-- We can (and eventually will) write our own iterators for use with the
-- iterator-based for-in looping structure.


-- ***** Modules *****


io.write("\n*** Modules:\n")

-- A Lua *module* is a package -- the kind of thing we would make a
-- header-file/source-file combination for in C++.

-- Import ("require" in Lua-speak) a module.
mymod = require "mymod"

-- Use a function from it.
mymod.print_with_stars("Code from module 'mymod', in file mymod.lua")

-- See file mymod.lua for the module itself.


io.write("\n")
io.write("This file contains sample code from February 1, 2016.\n")
io.write("It will execute, but it is not intended to do anything\n")
io.write("particularly useful. See the source.\n")

