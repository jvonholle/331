#!/usr/bin/env lua
-- userdparser3.lua
-- Glenn G. Chappell
-- 17 Feb 2016
-- Updated: 24 Feb 2016
--
-- For CS 331 Spring 2016
-- Simple Main Program for rdparser3 Module
-- Requires rdparser3.lua, lexer.lua

rdparser3 = require "rdparser3"


-- writeAST
-- Write an AST, in (roughly) Lua form.
-- A table is assumed to represent an array.
-- See rdparser3.lua for the AST Specification.
function writeAST(x)
    if type(x) == "number" then
        io.write(x)
    elseif type(x) == "string" then
        io.write('"'..x..'"')
    elseif type(x) == "boolean" then
        if x then
            io.write("true")
        else
            io.write("false")
        end
    elseif type(x) == "table" then
        local first = true
        io.write("{")
        for k = 1, #x do  -- ipairs is problematic
            if not first then
                io.write(", ")
            end
            writeAST(x[k])
            first = false
        end
        io.write("}")
    elseif type(x) == "nil" then
        io.write("nil")
    else
        io.write("<ERROR: "..type(x)..">")
    end
end


-- check
-- Given a "program", check its syntactic correctness using rdparser3.
-- Print results.
function check(program)
    dashstr = "-"
    io.write(dashstr:rep(72).."\n")
    io.write("Program: "..program.."\n")

    local good, ast = rdparser3.parse(program)

    if good then
        io.write("AST: ")
        writeAST(ast)
        io.write("\n")
    else
        io.write("SYNTAX ERROR\n")
    end
end


-- Main program
-- Check several "programs".
io.write("Recursive-Descent Parser: Expression\n")
check("abc")
check("123")
check("a b")
check("3a")
check("a + * b")
check("a + b (* c)")
check("a * -3")
check("3 - a")
check("a + +3 - c")
check("a + b - c + d - e")
check("a + (b - (c + (d - e)))")
check("a * +3 + c")
check("a * (+3 + c)")
check("a + +3 * c")
check("(a + +3) * c")

