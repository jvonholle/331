-- Jimmy Von Holle
-- CS 331
-- Assignment 6
-- interpit.lua
-- interperator for zebu

-- ******************************************************************
-- * To run a Zebu program, use zebu.lua (which calls this module). *
-- ******************************************************************

local interpit = {}

local STMT_LIST  = 1
local SET_STMT   = 2
local PRINT_STMT = 3
local NL_STMT    = 4
local INPUT_STMT = 5
local IF_STMT    = 6
local WHILE_STMT = 7
local BIN_OP     = 8
local UN_OP      = 9
local NUMLIT_VAL = 10
local STRLIT_VAL = 11
local ID_VAL     = 12
local ARRAY_REF  = 13

-- ***** Utility Functions *****


-- toInt
-- Given a number, return the number rounded toward zero.
function toInt(n)
    if n >= 0 then
        return math.floor(n)
    else
        return math.ceil(n)
    end
end


-- strToNum
-- Given a string, attempt to interpret it as an integer. If this
-- succeeds, return the integer. Otherwise, return 0.
function strToNum(s)
    -- Try to do string -> number conversion; make protected call
    -- (pcall), so we can handle errors.
    local success, value = pcall(function() return 0+s end)

    -- Return integer value, or 0 on error.
    if success then
        return toInt(value)
    else
        return 0
    end
end


-- numToStr
-- Given a number, return its string form.
function numToStr(n)
    return ""..n
end




-- PRIMARY FUNCTION FOR CLIENT CODE --

-- interp
-- Interperter, takes AST from parseit.parse
-- Param:
--      ast     - AST from parseit.parse
--      state   - Table with values for Zebu int variables
--                Value of simple varible xyz is in state.s["xyz"]
--                Value of array item xyz[42] is in state.a["xyz"][42]
--      incall  - Function to call for the line input
--                incall() inputs line, returns string with no newline
--      outcall - Function to call for string output
--                outcall(str) outputs str with no added newline
--                To print a newline, do outcall("\n")
--
-- Returns state updates with changed variable values
function interpit.interp(ast, state, incall, outcall)
    -- Each local interpretation function is given the AST for the
    -- partion of the code it is interperating
    
    
    local function interp_stmt(ast)
        if (ast[1] == SET_STMT) then
            interp_set(ast)
        elseif (ast[1] == PRNT_STMT) then
            if (ast[2][1] == STRLIT_VAL) then
                outcall(ast[2][2]:sub(2,ast[2][2]:len()-1))
            else
                outcall("poop\n")
            end
        elseif (ast[1] == NL_STMT) then
            outcall("\n")
        elseif (ast[1] == INPUT_STMT) then
            if(ast[2][1] == ID_VAL) then
                state[ast[2][2]] = incall()
        else
            outcall("AAAAAAAAAAAAAAAAAA\n")
        end
    end

    local function interp_set(abtree)
    end
    
    local function interp_arr(abtree)
    end
    
    local function interp_stmt_list(ast)
        assert(ast[1] == STMT_LIST)
        for k = 2, #ast do
            interp_stmt(ast[k])
        end
    end
    
    interp_stmt_list(ast)
    return state
end


return interpit