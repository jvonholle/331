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

--current lexeme
local lexstr = ""
local lexcat = 0

-- Lexeme Categories
local KEY =       1
local ID =        2
local NUMLIT =    3
local STRINGLIT = 4
local OP =        5
local PUNCT =     6
local MAL =       7

-- Symbolic Constants for AST
STMT_LIST =  1
SET_STMT =   2
PRINT_STMT = 3
NL_STMT =    4
INPUT_STMT = 5
IF_STMT =    6
WHILE_STMT = 7
BIN_OP =     8 
UN_OP =      9
NUMLIT_VAL = 10
STRLIT_VAL = 11
ID_VAL =     12
ARRAY_REF =  13


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


local function init(prog)
    iter, state, lexer_out_s = lexer.lex(prog)
    advance()
end

local function atEnd()
    return lexcat == 0
end

local function matchString(s)
    if lexstr == s then
        advance()
        return true
    else
        return false
    end
end

local function matchCat(c)
    if lexcat == c then
        advance()
        return true
    else
        return false
    end
end

local parse_program
local parse_stmt_list
local parse_expr
local parse_aexpr
local parse_term
local parse_factor
local parse_lvalue

function parseit.parse(prog)

    init(prog)

    local success, ast = parse_program()

    if success then
        return true, ast
    else
        return false, nil
    end
end

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
    local good, ast1, ast2, savelex

    if matchString("set") then
        good, ast1 = parse_lvalue()
        if not good then
            return false, nil
        end
        if matchString("=") then 
        good, ast2 = parse_expr()
        if not good then
            return false, nil
        end
        return true, {SET_STMT, ast1, ast2}
        end

    elseif matchString("print") then
        savelex = lexstr
        if matchCat(STRLIT) then
            return true, {PRINT_STMT,{STRLIT_VAL, savelex}}
        end

        good, ast1 = parse_expr()
        if not good then 
            return false, nil
        end
        return true, {PRINT_STMT,ast1}

    elseif matchString("nl") then
        return true, {NL_STMT,ast1}

    elseif matchString("input") then
        good, ast1 = parse_lvalue()
        if not good then
            return false, nil
        end
        return true, {INPUT_STMT, ast1}

    elseif matchString("if") then
        good, ast1 = parse_expr()
        if not good then
            return false, nil
        end
        good, ast2 = parse_stmt_list()
        if not good then
            return false, nil
        end
        if matchString("elseif") then
            local ast3, ast4
            good, ast3 = parse_expr()
            if not good then
                return false, nil
            end
            good, ast4 = parse_stmt_list()
            if not good then
                return false, nil
            end
            table.insert(ast1, ast3)
            table.insert(ast2, ast4)
        elseif matchString("else") then
            local ast3
            good, ast3 = parse_stmt_list()
            if not good then
                return false, nil
            end
            table.insert(ast2, ast3)
        elseif matchString("end") then
            return true, {IF_STMT, ast1, ast2}
        else
            return false, nil
        end
    elseif matchString("while") then
        good, ast1 = parse_expr()
        if not good then
            return false, nil
        end
        good, ast2 = parse_stmt_list()
        if not good then
            return false, nil
        end
        if matchString("end") then 
            return true, {WHILE_STMT, ast1, ast2}
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
        if not good then
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
        good, ast = parse_factor()
        if not good then
            return false, nil
        end
        return true, {{UN_OP, savelex}, ast}
        end

end

return parseit
