#!/usr/bin/env lua
-- useparseit.lua
-- Glenn G. Chappell
-- 24 Feb 2016
--
-- For CS 331 Spring 2016
-- Simple Main Program for parseit Module
-- Requires parseit.lua, lexit.lua

parseit = require "parseit"


-- String forms of symbolic constants
symbolNames = {
  [1]="STMT_LIST",
  [2]="SET_STMT",
  [3]="PRINT_STMT",
  [4]="NL_STMT",
  [5]="INPUT_STMT",
  [6]="IF_STMT",
  [7]="WHILE_STMT",
  [8]="BIN_OP",
  [9]="UN_OP",
  [10]="NUMLIT_VAL",
  [11]="STRLIT_VAL",
  [12]="ID_VAL",
  [13]="ARRAY_REF"
}


-- writeAST_parseit
-- Write an AST, in (roughly) Lua form, with numbers replaced by the
-- symbolic constants used in parseit.
-- A table is assumed to represent an array.
-- See the Assignment 4 description for the AST Specification.
function writeAST_parseit(x)
    if type(x) == "number" then
        local name = symbolNames[x]
        if name == nil then
            io.write("<ERROR: Unknown constant: "..x..">")
        else
            io.write(name)
        end
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
            writeAST_parseit(x[k])
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
-- Given a "program", check its syntactic correctness using parseit.
-- Print results.
function check(program)
    dashstr = "-"
    io.write(dashstr:rep(72).."\n")
    io.write("Program: "..program.."\n")

    local good, ast = parseit.parse(program)

    if good then
        io.write("AST: ")
        writeAST_parseit(ast)
        io.write("\n")
    else
        io.write("SYNTAX ERROR\n")
    end
end


-- Main program
-- Check several "programs".
io.write("Recursive-Descent Parser: Zebu\n")
check("nl")
check("")
check("nl nl nl")
check("input x")
check("print 'abc'")
check("set a = 3")
check("set a = b")
check("set a = - 1")
check("print a + 1")
check("set a = 3\n print a+1 nl")
check("set a == 3")
check("print a == 3")
check("print 3")
check("set x = a==b+c*+d!=e-/-g<h+i%+j")
check("set x[3] = 3")
check("set x = y[3]")
check("set x[3] = z + l")
check("set x = - 1")
check("set y = x[3]+z[2]")
check("input x")
check("set x = 3 print x")
check("print 1 + 3 + 2")
check("print 1 + 2 + - 3")
check("print -((x == 3) - (9 *  +y))")
check("if x == 4 print a end")
check("if x[2] print out end")
check("if 3 elseif 4 else end")