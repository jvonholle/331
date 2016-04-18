
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
                elseif(ast[2][1] == NUMLIT_VAL and type(ast[3][1]) == "table") then
                    return strToNum(ast[2][2]) + interp_op(ast[3])
                elseif(ast[2][1] == ID_VAL and type(ast[3][1]) == "table") then
                    return strToNum(state.s[ast[2][2]]) + interp_op(ast[3])
                elseif(ast[3][1] == ARRAY_REF and type(ast[3][1]) == "table") then
                    return strToNum(state.a[ast[2][2][2]][strToNum(ast[2][3][2])]) + interp_op(ast[3]) 
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return interp_op(ast[2]) + strToNum(ast[3][2])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return interp_op(ast[2]) + strToNum(state.s[ast[3][2]])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return interp_op(ast[2]) + strToNum(state.a[ast[3][2][2]][strToNum(ast[3][3][2])])
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
                elseif(ast[2][1] == NUMLIT_VAL and type(ast[3][1]) == "table") then
                    return strToNum(ast[2][2]) + interp_op(ast[3])
                elseif(ast[2][1] == ID_VAL and type(ast[3][1]) == "table") then
                    return strToNum(state.s[ast[2][2]]) + interp_op(ast[3])
                elseif(ast[3][1] == ARRAY_REF and type(ast[3][1]) == "table") then
                    return strToNum(state.a[ast[2][2][2]][strToNum(ast[2][3][2])]) + interp_op(ast[3])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return interp_op(ast[2]) - strToNum(ast[3][2])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return interp_op(ast[2]) - strToNum(state.s[ast[3][2]])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return interp_op(ast[2]) - strToNum(state.a[ast[3][2][2]][strToNum(ast[3][3][2])])
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
                elseif(ast[2][1] == NUMLIT_VAL and type(ast[3][1]) == "table") then
                    return strToNum(ast[2][2]) + interp_op(ast[3])
                elseif(ast[2][1] == ID_VAL and type(ast[3][1]) == "table") then
                    return strToNum(state.s[ast[2][2]]) + interp_op(ast[3])
                elseif(ast[3][1] == ARRAY_REF and type(ast[3][1]) == "table") then
                    return strToNum(state.a[ast[2][2][2]][strToNum(ast[2][3][2])]) + interp_op(ast[3])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return interp_op(ast[2]) * strToNum(ast[3][2])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return interp_op(ast[2]) * strToNum(state.s[ast[3][2]])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return interp_op(ast[2]) * strToNum(state.a[ast[3][2][2]][strToNum(ast[3][3][2])])
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
                elseif(ast[2][1] == NUMLIT_VAL and type(ast[3][1]) == "table") then
                    return strToNum(ast[2][2]) + interp_op(ast[3])
                elseif(ast[2][1] == ID_VAL and type(ast[3][1]) == "table") then
                    return strToNum(state.s[ast[2][2]]) + interp_op(ast[3])
                elseif(ast[3][1] == ARRAY_REF and type(ast[3][1]) == "table") then
                    return strToNum(state.a[ast[2][2][2]][strToNum(ast[2][3][2])]) + interp_op(ast[3])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return toInt(interp_op(ast[2]) / strToNum(ast[3][2]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return toInt(interp_op(ast[2]) / strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return toInt(interp_op(ast[2]) / strToNum(state.a[ast[3][2][2]][strToNum(ast[3][3][2])]))
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
                elseif(ast[2][1] == NUMLIT_VAL and type(ast[3][1]) == "table") then
                    return strToNum(ast[2][2]) + interp_op(ast[3])
                elseif(ast[2][1] == ID_VAL and type(ast[3][1]) == "table") then
                    return strToNum(state.s[ast[2][2]]) + interp_op(ast[3])
                elseif(ast[3][1] == ARRAY_REF and type(ast[3][1]) == "table") then
                    return strToNum(state.a[ast[2][2][2]][strToNum(ast[2][3][2])]) + interp_op(ast[3])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return interp_op(ast[2]) % strToNum(ast[3][2])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return interp_op(ast[2]) % strToNum(state.s[ast[3][2]])
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return interp_op(ast[2]) % strToNum(state.a[ast[3][2][2]][strToNum(ast[3][3][2])])
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
                elseif(ast[2][1] == NUMLIT_VAL and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(ast[2][2]) == interp_op(ast[3]))
                elseif(ast[2][1] == ID_VAL and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(state.s[ast[2][2]]) == interp_op(ast[3]))
                elseif(ast[2][1] == ARRAY_REF and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(state.a[ast[2][2][2]][strToNum(ast[3][3][2])]) == interp_op(ast[3]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(interp_op(ast[2]) == strToNum(ast[3][2]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return boolToInt(interp_op(ast[2]) == strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return boolToInt(interp_op(ast[2]) == strToNum(state.a[ast[3][2][2]][strToNum(ast[3][3][2])]))
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
                elseif(ast[2][1] == NUMLIT_VAL and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(ast[2][2]) == interp_op[ast[3]])
                elseif(ast[2][1] == ID_VAL and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(state.s[ast[2][2]]) == interp_op(ast[3]))
                elseif(ast[2][1] == ARRAY_REF and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(state.a[ast[2][2][2]][strToNum(ast[3][3][2])]) == interp_op(ast[3]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(interp_op(ast[2]) ~= strToNum(ast[3][2]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return boolToInt(interp_op(ast[2]) ~= strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return boolToInt(interp_op(ast[2]) ~= strToNum(state.a[ast[3][2][2]][strToNum(ast[3][3][1])]))
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
                elseif(ast[2][1] == NUMLIT_VAL and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(ast[2][2]) == interp_op[ast[3]])
                elseif(ast[2][1] == ID_VAL and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(state.s[ast[2][2]]) == interp_op(ast[3]))
                elseif(ast[2][1] == ARRAY_REF and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(state.a[ast[2][2][2]][strToNum(ast[3][3][2])]) == interp_op(ast[3]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(interp_op(ast[2]) < strToNum(ast[3][2]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return boolToInt(interp_op(ast[2]) < strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return boolToInt(interp_op(ast[2]) < strToNum(state.a[ast[3][2][2]][strToNum(ast[3][3][2])]))
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
                elseif(ast[2][1] == NUMLIT_VAL and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(ast[2][2]) == interp_op[ast[3]])
                elseif(ast[2][1] == ID_VAL and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(state.s[ast[2][2]]) == interp_op(ast[3]))
                elseif(ast[2][1] == ARRAY_REF and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(state.a[ast[2][2][2]][strToNum(ast[3][3][2])]) == interp_op(ast[3]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(interp_op(ast[2]) <= strToNum(ast[3][2]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return boolToInt(interp_op(ast[2]) <= strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return boolToInt(interp_op(ast[2]) <= strToNum(state.a[ast[3][2][2]][strToNum(ast[3][3][2])]))
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
                elseif(ast[2][1] == NUMLIT_VAL and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(ast[2][2]) == interp_op[ast[3]])
                elseif(ast[2][1] == ID_VAL and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(state.s[ast[2][2]]) == interp_op(ast[3]))
                elseif(ast[2][1] == ARRAY_REF and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(state.a[ast[2][2][2]][strToNum(ast[3][3][2])]) == interp_op(ast[3]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(interp_op(ast[2]) > strToNum(ast[3][2]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return boolToInt(interp_op(ast[2]) > strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return interp_op(ast[2]) > strToNum(state.a[ast[3][2][2]][strToNum(ast[3][3][2])])
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
                elseif(ast[2][1] == NUMLIT_VAL and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(ast[2][2]) == interp_op[ast[3]])
                elseif(ast[2][1] == ID_VAL and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(state.s[ast[2][2]]) == interp_op(ast[3]))
                elseif(ast[2][1] == ARRAY_REF and type(ast[3][1]) == "table") then
                    return boolToInt(strToNum(state.a[ast[2][2][2]][strToNum(ast[3][3][2])]) == interp_op(ast[3]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == NUMLIT_VAL) then
                    return boolToInt(interp_op(ast[2]) >= strToNum(ast[3][2]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ID_VAL) then
                    return boolToInt(interp_op(ast[2]) >= strToNum(state.s[ast[3][2]]))
                elseif(type(ast[2][1]) == "table" and ast[3][1] == ARRAY_REF) then
                    return boolToInt(interp_op(ast[2]) >= strToNum(state.a[ast[3][2][2]][strToNum(ast[3][3][2])]))
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
            elseif(type(ast[2][1] == "table")) then
                if(ast[1][2] == "+") then
                    return interp_op(ast[2])
                else
                    return interp_op(ast[2]) * -1
                end
            end
        end