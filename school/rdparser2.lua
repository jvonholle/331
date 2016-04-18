-- rdparser2.lua
-- Glenn G. Chappell
-- 15 Feb 2016
--
-- For CS 331 Spring 2016
-- Recursive-Descent Parser: A Little More Complex
-- Requires lexer.lua


-- Grammar
-- Start symbol: thing
--
--     thing  ->  ID [ ':' list ]
--              | '(' thing ')'
--     list   ->  '[' thing { ',' thing } ']'


local rdparser2 = {}  -- Our module

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
local parse_thing
local parse_list


-- parse
-- Given program, initialize parser and call parsing function for start
-- symbol. Returns boolean: true indicates successful parse AND end of
-- input reached. Otherwise, false.
function rdparser2.parse(prog)
    -- Initialization
    init(prog)

    -- Get results from parsing
    local success = parse_thing()  -- Parse start symbol
    local done = atEnd()

    -- And return them
    return success and done
end


-- Parsing Functions

-- Each of the following is a parsing function for a nonterminal in the
-- grammar. Each function parses the nonterminal in its name. A return
-- value of true means a correct parse, and the current lexeme is just
-- past the end of the string the nonterminal expanded into. A return
-- value of false means an incorrect parse; in this case no guarantees
-- are made about the current lexeme.


-- parse_thing
-- Parsing function for nonterminal "thing".
-- Function init must be called before this function is called.
function parse_thing()
    if matchCat(ID) then
        if not matchString(":") then
            return true
        end
        if not parse_list() then
            return false
        end
        return true
    elseif matchString("(") then
        if not parse_thing() then
            return false
        end
        if not matchString(")") then
            return false
        end
        return true
    else
        return false
    end
end


-- parse_list
-- Parsing function for nonterminal "list".
-- Function init must be called before this function is called.
function parse_list()
    if not matchString("[") then
        return false
    end
    if not parse_thing() then
        return false
    end
    while true do
        if not matchString(",") then
            break
        end
        if not parse_thing() then
            return false
        end
    end
    if not matchString("]") then
        return false
    end
    return true
end


-- Module Export

return rdparser2

