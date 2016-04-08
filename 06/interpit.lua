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
    -- portion of the code it is interperating
    
    -- function boolToInt
    -- helper function,
    -- returns 1 if passed object evaluates to true, 0 otherwise
    local function boolToInt(func)
        if(func) then
            return 1
        else
            return 0
        end
    end
    
    
    -- function interp_op
    -- takes current ast
    -- handles uniary and binary operators, returns what it needs to
    -- nasty but it should work
    local function interp_op(ast)
        assert(ast[1][1] == BIN_OP or ast[1][1] == UN_OP)
        
        if(ast[1][1] == BIN_OP) then
            if(ast[1][2] == "+") then
                if(ast[2][1] == NUMLIT_VAL and ast[3][1] == NUMLIT_VAL) then
                    return strToNum(ast[2][2]) + strToNum(ast[3][2])
                elseif(ast[2][1] == NUMLIT_VAL and ast[3][1] == ID_VAL) then
                    return strToNum(ast[2][2]) + strToNum(state.s[ast[3][2]])
                elseif(ast[2][1] == ID_VAL and ast[3][1] == NUMLIT_VAL) then
                    return strToNum(state.s[ast[2][2]]) + strToNum(ast[3][2])
                elseif(ast[2][1] == ID_VAL and ast[3][1] == ID_VAL) then
                    return strToNum(state.s[ast[2][2]]) + strToNum(state.s[ast[3][2]])
                elseif(ast[2][1] == ARRAY_REF and ast[3][1] == NUMLIT_VAL) then
                    return strToNum(state.a[ast[3][2][2]][ast[3][3][2]]) + strToNum(ast[3][2])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return interp_op(ast[2]) + strToNum(ast[3][2])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return interp_op(ast[2]) + strToNum(state.s[ast[3][2]])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return interp_op(ast[2]) + strToNum(state.a[ast[3][2][1]][ast[3][3][1]])
                end
            elseif(ast[1][2] == "-") then
               if(ast[2][1] == NUMLIT_VAL and ast[3][1] == NUMLIT_VAL) then
                    return strToNum(ast[2][2]) - strToNum(ast[3][2])
                elseif(ast[2][1] == NUMLIT_VAL and ast[3][1] == ID_VAL) then
                    return strToNum(ast[2][2]) - state.s[arr[3][2]]
                elseif(ast[2][1] == ID_VAL and ast[3][1] == NUMLIT_VAL) then
                    return strToNum(state.s[ast[2][2]]) - strToNum(ast[3][2])
                elseif(ast[2][1] == ID_VAL and ast[3][1] == ID_VAL) then
                    return strToNum(state.s[ast[2][2]]) - strToNum(state.s[ast[3][2]])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return interp_op(ast[2]) - strToNum(ast[3][2])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return interp_op(ast[2]) - strToNum(state.s[ast[3][2]])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return interp_op(ast[2]) - strToNum(state.a[ast[3][2][1]][ast[3][3][1]])
                end 
            elseif(ast[1][2] == "*") then
               if(ast[2][1] == NUMLIT_VAL and ast[3][1] == NUMLIT_VAL) then
                    return toInt(strToNum(ast[2][2]) * strToNum(ast[3][2]))
                elseif(ast[2][1] == NUMLIT_VAL and ast[3][1] == ID_VAL) then
                    return toInt(strToNum(ast[2][2]) * state.s[arr[3][2]])
                elseif(ast[2][1] == ID_VAL and ast[3][1] == NUMLIT_VAL) then
                    return toInt(strToNum(state.s[ast[2][2]]) * strToNum(ast[3][2]))
                elseif(ast[2][1] == ID_VAL and ast[3][1] == ID_VAL) then
                    return toInt(strToNum(state.s[ast[2][2]]) * strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return interp_op(ast[2]) * strToNum(ast[3][2])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return interp_op(ast[2]) * strToNum(state.s[ast[3][2]])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return interp_op(ast[2]) * strToNum(state.a[ast[3][2][1]][ast[3][3][1]])
                end 
            elseif(ast[1][2] == "/") then
               if(ast[2][1] == NUMLIT_VAL and ast[3][1] == NUMLIT_VAL) then
                    return toInt(strToNum(ast[2][2]) / strToNum(ast[3][2]))
                elseif(ast[2][1] == NUMLIT_VAL and ast[3][1] == ID_VAL) then
                    return toInt(strToNum(ast[2][2]) / state.s[arr[3][2]])
                elseif(ast[2][1] == ID_VAL and ast[3][1] == NUMLIT_VAL) then
                    return toInt(strToNum(state.s[ast[2][2]]) / strToNum(ast[3][2]))
                elseif(ast[2][1] == ID_VAL and ast[3][1] == ID_VAL) then
                    return toInt(strToNum(state.s[ast[2][2]]) / strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return toInt(interp_op(ast[2]) / strToNum(ast[3][2]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return toInt(interp_op(ast[2]) / strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return toInt(interp_op(ast[2]) / strToNum(state.a[ast[3][2][1]][ast[3][3][1]]))
                end 
            elseif(ast[1][2] == "%") then
               if(ast[2][1] == NUMLIT_VAL and ast[3][1] == NUMLIT_VAL) then
                    return strToNum(ast[2][2]) % strToNum(ast[3][2])
                elseif(ast[2][1] == NUMLIT_VAL and ast[3][1] == ID_VAL) then
                    return strToNum(ast[2][2]) % state.s[arr[3][2]]
                elseif(ast[2][1] == ID_VAL and ast[3][1] == NUMLIT_VAL) then
                    return strToNum(state.s[ast[2][2]]) % strToNum(ast[3][2])
                elseif(ast[2][1] == ID_VAL and ast[3][1] == ID_VAL) then
                    return strToNum(state.s[ast[2][2]]) % strToNum(state.s[ast[3][2]])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return interp_op(ast[2]) % strToNum(ast[3][2])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return interp_op(ast[2]) % strToNum(state.s[ast[3][2]])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return interp_op(ast[2]) % strToNum(state.a[ast[3][2][1]][ast[3][3][1]])
                end
            elseif(ast[1][2] == "==") then
               if(ast[2][1] == NUMLIT_VAL and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(strToNum(ast[2][2]) == strToNum(ast[3][2]))
                elseif(ast[2][1] == NUMLIT_VAL and ast[3][1] == ID_VAL) then
                    return boolToInt(strToNum(ast[2][2]) == state.s[arr[3][2]])
                elseif(ast[2][1] == ID_VAL and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(strToNum(state.s[ast[2][2]]) == strToNum(ast[3][2]))
                elseif(ast[2][1] == ID_VAL and ast[3][1] == ID_VAL) then
                    return boolToInt(strToNum(state.s[ast[2][2]]) == strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return interp_op(ast[2]) % strToNum(ast[3][2])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return interp_op(ast[2]) % strToNum(state.s[ast[3][2]])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return interp_op(ast[2]) % strToNum(state.a[ast[3][2][1]][ast[3][3][1]])
                end
                
            elseif(ast[1][2] == "!=") then
               if(ast[2][1] == NUMLIT_VAL and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(strToNum(ast[2][2]) ~= strToNum(ast[3][2]))
                elseif(ast[2][1] == NUMLIT_VAL and ast[3][1] == ID_VAL) then
                    return boolToInt(strToNum(ast[2][2]) ~= state.s[arr[3][2]])
                elseif(ast[2][1] == ID_VAL and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(strToNum(state.s[ast[2][2]]) ~= strToNum(ast[3][2]))
                elseif(ast[2][1] == ID_VAL and ast[3][1] == ID_VAL) then
                    return boolToInt(strToNum(state.s[ast[2][2]]) ~= strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(interp_op(ast[2]) == strToNum(ast[3][2])))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return boolToInt(interp_op(ast[2]) == strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return boolToInt(interp_op(ast[2]) strToNum(state.a[ast[3][2][1]][ast[3][3][1]]))
                end
                
            elseif(ast[1][2] == "<") then
               if(ast[2][1] == NUMLIT_VAL and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(strToNum(ast[2][2]) < strToNum(ast[3][2]))
                elseif(ast[2][1] == NUMLIT_VAL and ast[3][1] == ID_VAL) then
                    return boolToInt(strToNum(ast[2][2]) < state.s[arr[3][2]])
                elseif(ast[2][1] == ID_VAL and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(strToNum(state.s[ast[2][2]]) < strToNum(ast[3][2]))
                elseif(ast[2][1] == ID_VAL and ast[3][1] == ID_VAL) then
                    return boolToInt(strToNum(state.s[ast[2][2]]) < strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(interp_op(ast[2]) < strToNum(ast[3][2]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return boolToInt(interp_op(ast[2]) < strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return boolToInt(interp_op(ast[2]) < strToNum(state.a[ast[3][2][1]][ast[3][3][1]]))
                end
                
            elseif(ast[1][2] == "<=") then
               if(ast[2][1] == NUMLIT_VAL and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(strToNum(ast[2][2]) <= strToNum(ast[3][2]))
                elseif(ast[2][1] == NUMLIT_VAL and ast[3][1] == ID_VAL) then
                    return boolToInt(strToNum(ast[2][2]) <= state.s[arr[3][2]])
                elseif(ast[2][1] == ID_VAL and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(strToNum(state.s[ast[2][2]]) <= strToNum(ast[3][2]))
                elseif(ast[2][1] == ID_VAL and ast[3][1] == ID_VAL) then
                    return boolToInt(strToNum(state.s[ast[2][2]]) <= strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(interp_op(ast[2]) % strToNum(ast[3][2]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return boolToInt(interp_op(ast[2]) % strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return boolToInt(interp_op(ast[2]) % strToNum(state.a[ast[3][2][1]][ast[3][3][1]]))
                end
                
            elseif(ast[1][2] == ">") then
               if(ast[2][1] == NUMLIT_VAL and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(strToNum(ast[2][2]) > strToNum(ast[3][2]))
                elseif(ast[2][1] == NUMLIT_VAL and ast[3][1] == ID_VAL) then
                    return boolToInt(strToNum(ast[2][2]) > state.s[arr[3][2]])
                elseif(ast[2][1] == ID_VAL and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(strToNum(state.s[ast[2][2]]) > strToNum(ast[3][2]))
                elseif(ast[2][1] == ID_VAL and ast[3][1] == ID_VAL) then
                    return boolToInt(strToNum(state.s[ast[2][2]]) > strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return interp_op(ast[2]) % strToNum(ast[3][2])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return interp_op(ast[2]) % strToNum(state.s[ast[3][2]])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return interp_op(ast[2]) % strToNum(state.a[ast[3][2][1]][ast[3][3][1]])
                end
                
            elseif(ast[1][2] == ">=") then
               if(ast[2][1] == NUMLIT_VAL and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(strToNum(ast[2][2]) >= strToNum(ast[3][2]))
                elseif(ast[2][1] == NUMLIT_VAL and ast[3][1] == ID_VAL) then
                    return boolToInt(strToNum(ast[2][2]) >= state.s[arr[3][2]])
                elseif(ast[2][1] == ID_VAL and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(strToNum(state.s[ast[2][2]]) >= strToNum(ast[3][2]))
                elseif(ast[2][1] == ID_VAL and ast[3][1] == ID_VAL) then
                    return boolToInt(strToNum(state.s[ast[2][2]]) >= strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return interp_op(ast[2]) % strToNum(ast[3][2])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return interp_op(ast[2]) % strToNum(state.s[ast[3][2]])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return interp_op(ast[2]) % strToNum(state.a[ast[3][2][1]][ast[3][3][1]])
                end
                
            end
        elseif(ast[1][1] == UN_OP) then
            if(ast[1][2] == "-" and ast[2][1] == NUMLIT_VAL) then
                return strToNum(ast[2][2]) * (-1)
            elseif(ast[1][2] == "+" and ast[2][1] == NUMLIT_VAL) then
                return strToNum(ast[2][2])
            elseif(ast[1][2] == "-" and ast[2][1] == ID_VAL) then
                return strToNum(state.s[ast[2][2]]) * (-1)
            elseif(ast[1][2] == "+" and ast[2][1] == ID_VAL) then
                return strToNum(state.s[ast[2][2]])
            end
        end
    end
    
    local function interp_set(ast)
        assert(ast[1] == SET_STMT)
        if(ast[2][1] == ID_VAL) then
            if(ast[3][1] == NUMLIT_VAL) then
                state.s[ast[2][2]] = strToNum(ast[3][2])
            elseif(ast[3][1] == ID_VAL) then
                state.s[ast[2][2]] = state.s[ast[3][2]]
            elseif(ast[3][1] == ARRAY_REF) then
                state.s[ast[2][2]] = strToNum(state.a[ast[3][1][2]][ast[3][2][2]])
            elseif(ast[3][1][1] == BIN_OP or ast[3][1][1] == UN_OP) then
                state.s[ast[2][2]] = interp_op(ast[3])
            end
        elseif(ast[2][1] == ARRAY_REF) then
            if(ast[3][1] == NUMLIT_VAL) then
                if(state.a[ast[2][2][2]] == nil) then
                    state.a[ast[2][2][2]] = {}
                end
                state.a[ast[2][2][2]][strToNum(ast[2][3][2])] = strToNum(ast[3][2])
            end
        end
    end

    
    local function interp_stmt(ast)
        if(ast[1] == SET_STMT) then
            interp_set(ast)
        elseif(ast[1] == PRINT_STMT) then
            if(ast[2][1] == STRLIT_VAL) then
                outcall(ast[2][2]:sub(2,ast[2][2]:len()-1))
            elseif(ast[2][1] == ID_VAL) then
                if(state.s[ast[2][2]] ~= nil) then
                    outcall(numToStr((state.s[ast[2][2]])))
                else
                    outcall("0")
                end
            elseif(ast[2][1] == NUMLIT_VAL) then
                outcall(numToStr(ast[2][2]))
            elseif(ast[2][1] == ARRAY_REF) then
                if(state.a[ast[2][2][2]] ~= nil) then
                    if(state.a[ast[2][2][2]][strToNum(ast[2][3][2])] ~= nil) then
                        outcall(numToStr(state.a[ast[2][2][2]][strToNum(ast[2][3][2])]))
                    else
                        outcall("0")
                    end
                else
                    outcall("0")
                end
            elseif(ast[2][1][1] == UN_OP or ast[2][1][1] == BIN_OP) then
                outcall(numToStr(interp_op(ast[2])))
            else
            end
        elseif (ast[1] == NL_STMT) then
            outcall("\n")
        elseif(ast[1] == INPUT_STMT) then
            if(ast[2][1] == ID_VAL) then
                state.s[ast[2][2]] = strToNum(incall())
            end
        elseif(ast[1] == WHILE_STMT) then
            
        elseif(ast[1] == IF_STMT) then 
        else
            outcall("AAAAAAAAAAAAAAAAAA\n")
        end
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

-- Export Modulue

return interpit