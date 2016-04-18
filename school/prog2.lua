#!/usr/bin/env lua
-- prog2.lua
-- Glenn G. Chappell
-- 3 Feb 2016
--
-- For CS 331 Spring 2016
-- Code from 2/3: Lua Programming II


io.write("This file contains sample code from February 3, 2016.\n")
io.write("It will execute, but it is not intended to do anything\n")
io.write("particularly useful. See the source.\n")


-- ***** Metatables *****


io.write("\n*** Metatables:\n")

-- A table can have a "metatable", which is used to implement various
-- things like operator overloading and handling of nonexistent keys.
-- Here we use the latter to simulate the class-object relationship
-- found in languages like C++.

-- The table to be used as a metatable
mt = {}

-- count_to
-- Prints numbers 1 to n on a single line.
function mt.count_to(n)
    for i = 1, n do
        io.write(i .. " ")
    end
    io.write("\n")
end

-- The __index entry in a table's metatable is called when a nonexistent
-- key is accessed in the table. Here we set this function to return the
-- corresponding member of the metatable.
function mt.__index(self, key)
    return mt[key]
end
-- Above, parameter "self" is the table with the missing key. Function
-- __index must take this parameter, but we do not use it here.

-- Now, mt is like a "class". We wish to make an "object": a table whose
-- metatable is mt. Let's give mt a member "new" that creates one and
-- returns it.
function mt.new()
    local t = {}
    setmetatable(t, mt)  -- mt is now the metatable of t
    t.x = 3              -- Initialize a "data member"
    return t
end

-- Now we make our table: t
t = mt.new()

-- What happens when we call member t.count_to? There is no t.count_to,
-- so the metatable will be used.
t.count_to(6)


-- ***** Colon Operator *****


io.write("\n*** Colon Operator:\n")

-- Some member functions need to know the table they are called on. Lua
-- has no notion of "the current object" (e.g., "this" in C++). A
-- solution is to pass the table to the member function.
--     tabl.foo(tabl, a, b)
-- However, the above is redundant. So Lua offers shorthand:
--     tabl:foo(a, b)

function t.increment_x(self)
    self.x = self.x+1
end

t:increment_x()

-- t.x was 3. We incremented it. The following should print "4":
io.write("t.x = " .. t.x .. " (should be 4)\n")

-- The colon operator is particularly useful when using a metatable. A
-- function that is a member of the metatable of table t needs to know
-- about t if it is to access a member of t.

function mt.print_x(self)
    io.write(self.x .. "\n")
end

io.write("Another way to print t.x: ")
t:print_x()


-- ***** Closures *****


io.write("\n*** Closures:\n")

-- A closure is a function that carries with it (some portion of) the
-- environment it was defined. Closures offer a simple way to do some of
-- the things we might do with an object in traditional C++ OO style.

-- make_multiplier
-- Return a function (a closure) that multiplies by the given k.
function make_multiplier(k)
    function mult(x)
        return k*x
    end

    return mult
end

-- Now use the closure turned above.
times2 = make_multiplier(2)  -- Function that multiplies by 2
triple = make_multiplier(3)  -- Function that multiplies by 3
io.write("17 times 2 is " .. times2(17) .. "\n")
io.write("25 tripled is " .. triple(25) .. "\n")

-- Think about how we might do the above in a traditional OO style. We
-- could create an object with a member function that multiplies a
-- parameter by some data member. We would set the data member to 2 or 3
-- in a constructor to get the functionality shown above. So the
-- existence of closures means we have less need for objects.


-- ***** Coroutines *****


io.write("\n*** Coroutines:\n")

-- Here is a coroutine: a function that can return (we say "yield") and
-- then be resumed again.

-- small_fibos
-- Yield Fibonacci numbers less than given limit.
function small_fibos(limit)
    local a, b = 0, 1
    while true do
        if a >= limit then
            break
        end
        coroutine.yield(a)  -- return value; resumable afterwards
        a, b = b, a+b
    end
end

-- Use the above coroutine
io.write("Small Fibonacci numbers\n")
cor = coroutine.create(small_fibos)
ok, value = coroutine.resume(cor, 150)
    -- Attempt to get value from coroutine; 2nd argument is passed to
    -- small_fibos
while coroutine.status(cor) ~= "dead" do
    -- We have a value; print it
    io.write(value .. "  ")

    -- Attempt to get another value from coroutine
    ok, value = coroutine.resume(cor)
end
io.write("\n")
if not ok then  -- Error check
    io.write("ERROR in coroutine\n")
end


-- ***** Custom Iterators *****


io.write("\n*** Custom Iterators:\n")

-- You can make your own iterators for use with the for-in control
-- structure.

-- The following code:
--
--     for u, v1, v2 in XYZ do
--         FOR_LOOP_BODY
--     end
--
-- is translated to:
--
--     local iter, state, u = XYZ
--     local v1, v2
--     while true do
--         u, v1, v2 = iter(state, u)
--         if u == nil then
--             break
--         end
--         FOR_LOOP_BODY
--     end
--
-- Above, "v1, v2" can be replaced with an arbitrary number of
-- variables, or with no variables at all.

-- Here is an example (with the same result as the above coroutine
-- example):

-- small_fibos
-- Allows for-in iteration through Fibonacci numbers less than n.
function small_fibos(n)
    local a, b = 1, 0

    function iter(dummy1, dummy2)
        a, b = b, a+b
        if a >= n then
            return nil  -- End iteration
        end
        return a
    end

    return iter, nil, nil
end

-- Use the above iterator
io.write("Small Fibonacci numbers\n")
for k in small_fibos(150) do
    io.write(k .. "  ")
end
io.write("\n")


io.write("\n")
io.write("This file contains sample code from February 3, 2016.\n")
io.write("It will execute, but it is not intended to do anything\n")
io.write("particularly useful. See the source.\n")

