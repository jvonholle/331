#!/usr/bin/env lua
-- userdparser2.lua
-- Glenn G. Chappell
-- 15 Feb 2016
--
-- For CS 331 Spring 2016
-- Simple Main Program for rdparser2 Module
-- Requires rdparser2.lua, lexer.lua

rdparser2 = require "rdparser2"


-- check
-- Given a "program", check its syntactic correctness using rdparser2.
-- Print results.
function check(program)
    dashstr = "-"
    io.write(dashstr:rep(72).."\n")
    io.write("Program: "..program.."\n")

    local good = rdparser2.parse(program)

    if good then
        io.write("Syntactically correct; all input parsed\n")
    else
        io.write("SYNTAX ERROR\n")
    end
end


-- Main program
-- Check several "programs".
io.write("Recursive-Descent Parser: A Little More Complex\n")
check("abc3")
check("345")
check("((((___g___))))")
check("((xyz)")
check("(xyz))")
check("((abc: [(aa), bb, ((cc))]))")
check("((abc: [(aa:[x,((y)),z]), bb:[s,(t),u:[a,b,(c)]], ((cc))]))")
check("abc:[def]")
check("abc [def]")
check("abc: def]")
check("abc: [def")
check("((abc: [(aa:[x,((y)),z]), bb:[s,(t),u:[a,b,(c]], ((cc))]))")

