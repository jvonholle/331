-- rdparser4.lua
-- Glenn G. Chappell
-- 19 Feb 2016
--
-- For CS 331 Spring 2016
-- Recursive-Descent Parser: Expressions, symbols in AST, use $
-- Requires lexer.lua


-- Grammar
-- Start symbol: all
--
--     all     ->  expr $
--     expr    ->  term { ('+' | '-') term }
--     term    ->  factor { ('+' | '-') factor }
--     factor  ->  ID
--               | NUMLIT
--               | '(' expr ')'
--
-- Operators '+', '-', '*', '/' are left-associative
--
-- AST Specification
-- - For a NUMLIT, the AST is { NUMLIT_VAL, SS }, where NN is the string
--   form of the lexeme.
-- - For an ID, the AST is { ID_VAL, SS }, where NN is the string form
--   of the lexeme.
-- - Let X, Y be expressions with ASTs XT, YT, respectively.
--   - The AST for ( X ) is XT.
--   - The AST for X + Y is { { BIN_OP "+" }, XT, YT }, and similarly
--     for the '-', '*' and '/' operators.


local rdparser4 = {}  -- Our module

lexer = require "lexer"


-- Variables

-- For lexer iteration
local iter          -- Iterator returned by lexer.lex
local state         -- State for above iterator (maybe not used)
local lexer_out_s   -- Return value #1 from above iterator
local lexer_out_c   -- Return value #2 from above iterator

-- For current lexeme
local lexstr = ""   -- String form of current lexeme
local lexcat = 0    -- Category of current lexeme:
                    --  one of categories below, or 0 for past the end


-- Lexeme Categories

local KEY = 1
local ID = 2
local NUMLIT = 3
local OP = 4
local PUNCT = 5
local MAL = 6

-- Symbolic Constants for AST

BIN_OP = 1
NUMLIT_VAL = 2
ID_VAL = 3


-- Utility Functions


-- advance
-- Go to next lexeme and load it into lexstr, lexcat.
-- Should be called once before any parsing is done.
-- Function init must be called before this function is called.
local function advance()
    -- Advance the iterator
    lexer_out_s, lexer_out_c = iter(state, lexer_out_s)

    -- If we're not past the end, copy current lexeme into vars
    if lexer_out_s ~= nil then
        lexstr, lexcat = lexer_out_s, lexer_out_c
    else
        lexstr, lexcat = "", 0
    end
end


-- init
-- Initial call. Sets input for parsing functions.
local function init(prog)
    iter, state, lexer_out_s = lexer.lex(prog)
    advance()
end


-- atEnd
-- Return true is pos has reached end of input.
-- Function init must be called before this function is called.
local function atEnd()
    return lexcat == 0
end


-- matchString
-- Given string, see if current lexeme string form is equal to it. If
-- so, then advance to next lexeme & return true. If not, then do not
-- advance, return false.
-- Function init must be called before this function is called.
local function matchString(s)
    if lexstr == s then
        advance()
        return true
    else
        return false
    end
end


-- matchCat
-- Given lexeme category (integer), see if current lexeme category is
-- equal to it. If so, then advance to next lexeme & return true. If
-- not, then do not advance, return false.
-- Function init must be called before this function is called.
local function matchCat(c)
    if lexcat == c then
        advance()
        return true
    else
        return false
    end
end


-- Primary Function for Client Code

-- Define local functions for later calling (like prototypes in C++)
local parse_all
local parse_expr
local parse_term
local parse_factor


-- parse
-- Given program, initialize parser and call parsing function for start
-- symbol. Returns boolean: true indicates successful parse AND end of
-- input reached. Otherwise, false.
function rdparser4.parse(prog)
    -- Initialization
    init(prog)

    -- Get results from parsing
    local success, ast = parse_all()  -- Parse start symbol

    -- And return them
    if success then
        return true, ast
    else
        return false, nil
    end
end


-- Parsing Functions

-- Each of the following is a parsing function for a nonterminal in the
-- grammar. Each function parses the nonterminal in its name and returns
-- a pair: boolean, AST. On a successul parse, the boolean is true, the
-- AST is valid, and the current lexeme is just past the end of the
-- string the nonterminal expanded into. Otherwise, the boolean is
-- false, the AST is not valid, and no guarantees are made about the
-- current lexeme. See the AST Specification near the beginning of this
-- file for the format of the returned AST.


-- parse_all
-- Parsing function for nonterminal "all".
-- Function init must be called before this function is called.
function parse_all()
    local good, ast

    good, ast = parse_expr()
    if not good then
        return false, nil
    end

    if not atEnd() then
        return false, nil
    end

    return true, ast
end


-- parse_expr
-- Parsing function for nonterminal "expr".
-- Function init must be called before this function is called.
function parse_expr()
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

        ast = { { BIN_OP, saveop }, ast, newast }
    end
end


-- parse_term
-- Parsing function for nonterminal "term".
-- Function init must be called before this function is called.
function parse_term()
    local good, ast, saveop, newast

    good, ast = parse_factor()
    if not good then
        return false, nil
    end

    while true do
        saveop = lexstr
        if not matchString("*") and not matchString("/") then
            return true, ast
        end

        good, newast = parse_factor()
        if not good then
            return false, nil
        end

        ast = { { BIN_OP, saveop }, ast, newast }
    end
end


-- parse_factor
-- Parsing function for nonterminal "factor".
-- Function init must be called before this function is called.
function parse_factor()
    local savelex, good, ast

    savelex = lexstr
    if matchCat(ID) then
        return true, { ID_VAL, savelex }
    elseif matchCat(NUMLIT) then
        return true, { NUMLIT_VAL, savelex }
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


-- Module Export

return rdparser4

