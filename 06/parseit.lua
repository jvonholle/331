--parseit.lua
--Jimmy Von Holle
--March 1 2016
--Assignment 4
--CS 331
--Recursive-Descent Parser for Zebu
--Requires lexit.lua


local parseit = {} -- the module

lexer = require "lexit"

local iter        -- Iterator returned by lexer.lex
local state       -- State for above iterator
local lexer_out_s -- Return Value #1 from above iterator
local lexer_out_c -- Return Value #2 from above iterator

-- Current lexeme
local lexstr = ""
local lexcat = 0

-- Lexeme Categories
local KEY =    1
local ID =     2
local NUMLIT = 3
local STRLIT = 4
local OP =     5
local PUNCT =  6
local MAL =    7

-- Symbolic Constants for AST
local STMT_LIST =  1
local SET_STMT =   2
local PRINT_STMT = 3
local NL_STMT =    4
local INPUT_STMT = 5
local IF_STMT =    6
local WHILE_STMT = 7
local BIN_OP =     8 
local UN_OP =      9
local NUMLIT_VAL = 10
local STRLIT_VAL = 11
local ID_VAL =     12
local ARRAY_REF =  13

-- advance
-- checks if preferOp needs to be called
-- then advances iterator through lexer output
local function advance()
    if lexer_out_c == ID or lexer_out_c == NUMLIT or 
        lexer_out_s == ")" or lexer_out_s == "]" then
        lexer.preferOp()
    end
    lexer_out_s, lexer_out_c = iter(state, lexer_out_s)

    if lexer_out_s ~= nil then
        lexstr, lexcat = lexer_out_s, lexer_out_c
    else
        lexstr, lexcat = "", 0
    end

end

-- init
-- takes program
-- calls lexer.lex on program, lexing it
local function init(prog)
    iter, state, lexer_out_s = lexer.lex(prog)
    advance()
end

-- atEnd()
-- Returns if it at end of program
local function atEnd()
    return lexcat == 0
end

-- matchString
-- checks given string against current lexeme
-- returns true and advances if they match
-- returns false otherwise
local function matchString(s)
    if lexstr == s then
        advance()
        return true
    else
        return false
    end
end

-- matchCat
-- checks given category against current lexeme
-- returns true and advances if they match
-- returns false otherwise
local function matchCat(c)
    if lexcat == c then
        advance()
        return true
    else
        return false
    end
end

-- function "prototypes"
-- see below for more detailed description
local parse_program
local parse_stmt_list
local parse_expr
local parse_aexpr
local parse_term
local parse_factor
local parse_lvalue

-- Main parsing function
-- calls init(prog) which lexes
-- returns parsed program from parse_program
function parseit.parse(prog)

    init(prog)

    local success, ast = parse_program()

    if success then
        return true, ast
    else
        return false, nil
    end
end

-- parse_program
-- Parses start symbol program
-- returns ast returned by parse_XYZ
function parse_program()
    local good, ast
    good, ast = parse_stmt_list()
    if not good then
        return false, nil
    end
    if not atEnd() then 
        return false, nil
    end
    return true, ast
end

-- parse_XYZ
-- parsing function for nonterminal state XYZ
-- returns true and abstract syntax tree if correct
-- false and nil if there is a syntax error
function parse_stmt_list()
    local good, ast, newast
    ast = {STMT_LIST}
    while true do
        if lexstr ~= "set"
            and lexstr ~= "print"
            and lexstr ~= "nl"
            and lexstr ~= "input"
            and lexstr ~= "if"
            and lexstr ~= "while" then
            return true,ast
        end

        good, newast = parse_statement()
        if not good then
            return false, nil
        end
        table.insert(ast, newast)
    end
end


function parse_statement()
    local good, ast, newast, savelex

    if matchString("set") then
        good, ast = parse_lvalue()
        if not good then
            return false, nil
        end
        if matchString("=") then 
        good, newast = parse_expr()
        if not good then
            return false, nil
        end
        return true, {SET_STMT, ast, newast}
        end

    elseif matchString("print") then
        savelex = lexstr
        if matchCat(STRLIT) then
            return true, {PRINT_STMT,{STRLIT_VAL, savelex}}
        end

        good, ast = parse_expr()
        if not good then 
            return false, nil
        end
        return true, {PRINT_STMT,ast}

    elseif matchString("nl") then
        return true, {NL_STMT,ast}

    elseif matchString("input") then
        good, ast = parse_lvalue()
        if not good then
            return false, nil
        end
        return true, {INPUT_STMT, ast}

    elseif matchString("if") then
        local newast1, newast2, newast3
        good, ast = parse_expr()
        if not good then
            return false, nil
        end
	good, newast = parse_stmt_list()
        if not good then
            return false, nil
        end
	ast = {IF_STMT, ast, newast}
	while true do
	if matchString("elseif") then
            good, newast1 = parse_expr()
            if not good then
                return false, nil
            end
            good, newast2 = parse_stmt_list()
            if not good then
                return false, nil
            end
            table.insert(ast, newast1)
            table.insert(ast, newast2)
        elseif matchString("else") then
            good, newast3 = parse_stmt_list()
            if not good then
                return false, nil
            end
            table.insert(ast, newast3)
        elseif matchString("end") then
            return true,  ast
        else 
            return false, nil
        end
       end 
    elseif matchString("while") then
        good, ast = parse_expr()
        if not good then
            return false, nil
        end
        good, newast = parse_stmt_list()
        if not good then
            return false, nil
        end
        if matchString("end") then 
            return true, {WHILE_STMT, ast, newast}
        else
            return false, nil
        end
    else
        return false, nil
    end
end

function parse_expr()
    local good, ast, saveop, newast

    good, ast = parse_aexpr()
    if not good then
        return false, nil
    end

    while true do
        saveop = lexstr
        if not matchString("==") and not matchString("!=")
            and not matchString("<") and not matchString("<=")
            and not matchString(">") and not matchString(">=") then
            return true, ast
        end

        good, newast = parse_aexpr()
        if not good then
            return false, nil
        end

        ast = {{BIN_OP, saveop}, ast, newast}
    end
end

function parse_aexpr()
    local good, ast, saveop, newast
    
    good, ast = parse_term()
    if not good then
        return false, nil
    end

    while true do
        saveop = lexstr
        if not matchString("+") and not matchString("-") then
            return true, ast
        end

        good, newast = parse_term()
        if not good then
            return false, nil
        end

        ast = {{BIN_OP, saveop}, ast, newast}
    end
end

function parse_term()
    local good, ast, saveop, newast

    good, ast = parse_factor()
    if not good then
        return false, nil
    end

    while true do
        saveop = lexstr
        if not matchString("*") and not matchString("/")
            and not matchString("%") then
            return true, ast
        end

        good, newast = parse_factor()
        if not good then
            return false, nil
        end

        ast = {{BIN_OP, saveop}, ast, newast}
    end
end

function parse_factor()
    local savelex, good, ast

    savelex = lexstr
    if matchCat(ID) then
        if matchString("[") then
            good, ast = parse_expr()
            if not good then
                return false, nil
            end

            if not matchString("]") then 
                return false, nil
            end
            return true, {ARRAY_REF, {ID_VAL, savelex},ast}
        end
        return true, {ID_VAL, savelex}
    elseif matchCat(NUMLIT) then
        return true, {NUMLIT_VAL, savelex}
    elseif matchCat(OP) then
        good, ast = parse_factor()
        if not good or (savelex ~= "+" and savelex~= "-") then
            return false, nil
        end
        return true, {{UN_OP, savelex}, ast}
    elseif matchString("(") then
        good, ast = parse_expr()
        if not good then
            return false, nil
        end

        if not matchString(")") then 
            return false, nil
        end

        return true, ast
    else
        return false, nil
    end
end

function parse_lvalue()
    local savelex, good, ast

    savelex = lexstr
    if matchCat(ID) then
        if matchString("[") then
            good, ast = parse_expr()
            if not good then
                return false, nil
            end

            if not matchString("]") then 
                return false, nil
            end
            return true, {ARRAY_REF, {ID_VAL, savelex},ast}
        end
        return true, {ID_VAL, savelex}
    elseif matchCat(NUMLIT) then
        return false, nil
    elseif matchCat(OP) then
        if matchString("+") or matchString("-") then
            good, ast = parse_factor()
            if not good then
                return false, nil
            end
            return true, {{UN_OP, savelex}, ast}
        else
            return false, nil
        end
    end
end

return parseit
