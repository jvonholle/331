--Jimmy Von Holle
--CS 331
--Assignment 2
--lexit.lua
--

--Usage: 
--
--	program = "print a+b;" -- program to lex
--	for lexstr, cat in lexer.lex(program) do
--		-- lexstr is the string form of a lexeme
--		-- cat is the lexeme category
--		-- It can be used as an index for lexit.catnames
--	end

local lexit = {}

--	Lexeme Category Names
lexit.catnames = {
	"Keyword",
	"Identifier",
	"NumericLiteral",
	"StringLiteral",
	"Operator",
	"Punctuation",
	"Malformed"
}

PREFOP = false --Prefer OP flag


--Is fucntions
--
--Takes character
--returns true if c is of type
local function isLetter(c)
	if c:len()~= 1 then
		return false
	elseif c>="A" and c<="Z" then
		return true
	elseif c>="a" and c<="z" then 
		return true
	else
		return false
	end
end

local function isWhitespace(c)
	if c:len() ~= 1 then
		return false
	elseif c == " " or c == "\t" or c == "\n" or c == "\r"
		or c == "\f" then
		return true
	else 
		return false
	end
end

local function isDigit(c)
	if c:len() ~= 1 then
		return false
	elseif isWhitespace(c) then
		return false
	elseif c>= "0" and c<="9" then
		return true
	else
		return false
	end
end

local function isOperator(c)
	if c:len() ~= 1 then
		return false
	elseif c == "+" or c == "-" or c == "*" or c == "/" or c == "%"
		 or c == "=" or c == "==" or c == "!=" or c == "<" or 
		 c == ">" or c == ">=" or c == "[" or c == "]" then
		 return true
	 else
		 return false
	 end
 end

local function isIllegal(c)
	if c:len() ~= 1 then
		return false
	elseif isWhitespace(c) then
		return false
	elseif c>=" " and c<= "~" then
		return false
	else
		return true
	end
end

--function operatorState
--returns operator type of c
--5 or 6 for special cases + -
--9 otherwise
--nil if not an operator
local function operatorState(c)
	if isOperator(c) then
		if c == "+" then
			return 5
		elseif c == "-" then
			return 6
		else
			return 9
		end
	else
		return nil
	end
end

--Turn Prefer Operator flag to true
function lexit.preferOp()
	PREFOP = true
end

--lex
-- takes string
-- intended for use in a for-in loop:
-- 	for lexstr, cat in lexer.lex(prog) do
function lexit.lex(prog)
	-- VARIABLES --
	local pos -- next char in prog
		  -- INVARIANT: when getLexeme is called, pos is
		  -- EITHER the index of the first character of the
		  -- next lexeme OR len+1
	local state     --Current state
	local ch        --Current character
	local lexstr    --The lexeme so far
	local category  --Category of lexeme, set when state set to DOEN
	local handlers  --Dispatch table

	-- CATEGORIES -- 
	local KEY = 1
	local ID = 2
	local NUMLIT = 3
	local STRINGLIT = 4
	local OP = 5
	local PUNCT = 6
	local MAL = 7

	-- STATES --
	local DONE = 0
	local START = 1
	local LETTER = 2
	local DIGIT = 3
	local EXP = 4
	local PLUS = 5
	local MINUS = 6
	local QUOTE = 8
	local OTHEROP = 9

	-- Character functions --
	
	--currChar
	--takes nothing
	--return the character at pos in prog
	local function currChar()
		return prog:sub(pos,pos)
	end
	
	--lookAhead
	--takes a number
	--returns the char at pos+n in prog
	local function lookAhead(n)
		return prog:sub(pos+n, pos+n)
	end
	
	--nextChar
	--takes nothing
	--returns lookAhead(1)
	local function nextChar()
		return lookAhead(1)
	end
	
	--drop1
	--takes nothing
	--returns nothing
	--increments pos wihtout adding anything to lexstr
	local function drop1()
		pos = pos+1
	end
	
	--add1
	--takes nothing
	--returns nothing
	--adds current character to lexstr
	--increments pos
	local function add1()
		lexstr = lexstr .. currChar()
		drop1()
	end
	
	--rm1
	--takes nothing
	--returns nothing
	--removes one character from lexstr
	local function rm1()
		lexster = lexstr - 1
	end
	
	--skipWhitespace
	--takes nothing
	--returns nothing
	--skips white space and comments
	local function skipWhitespace()
		while true do
			while isWhitespace(currChar()) do
				drop1()
			end
			if currChar() ~= "#" then
				break
			end
			drop1()

			while true do
				if currChar() == "\n" then
					drop1()
					break
				elseif currChar() == "" then 
					return
				end
				drop1()
			end
		end
	end
	
	-- Handler Functions --
	--
	-- handle_XYZ handles state XYZ

	local function handle_DONE()
		io.write("ERROR: DONE SHOULD NOT BE HANDLED\n")
		assert(0)
	end
	
	local function handle_START()
		if isIllegal(ch) then
			add1()
			state = DONE
			category = MAL
		elseif isOperator(ch) then
			add1()
			state = operatorState(ch)
		elseif isLetter(ch) then
			add1()
			state = LETTER
		elseif isDigit(ch) then
			add1()
			state = DIGIT
		elseif ch == "\""  or ch == "\'" then
			state = QUOTE
		else
			if ch == "!" and nextChar() == "=" then
				add1()
				add1()
				state = OTHEROP
			else
				add1()
				state = DONE
				category = PUNCT
			end
		end
	end

	local function handle_LETTER()
		if isLetter(ch) or isDigit(ch) or ch == "_" then
			add1()
		else
			state = DONE
			category = ID
			if lexstr == "begin" 
				or lexstr == "end"
				or lexstr == "print" 
				or lexstr == "set" 
				or lexstr == "nl" 
				or lexstr == "input" 
				or lexstr == "if"
				or lexstr == "else"
				or lexstr == "elseif"
				or lexstr == "while" then
				category = KEY end
		end
	end

	local function handle_EXP()
		if not isDigit(nextChar()) and not isOperator(nextChar()) then
			if isDigit(ch) then
				add1()
				state = DONE
				category = NUMLIT
			else
				state = DONE
				category = NUMLIT
			end
		elseif isDigit(ch) then
			add1()
		elseif (ch == "e" or ch == "E") then
			if isOperator(nextChar()) then
				if isDigit(lookAhead(2)) then
					add1()
				else
					rm1()
					state = DONE
					category = NUMLIT
				end
			else
				add1()
			end
		elseif isOperator(ch) then
			if operatorState(ch) == 5 or operatorState(ch) == 6 then
				if isWhitespace(nextChar()) then
					state = DONE
					category = NUMLIT
				else
					add1()
				end
			else
				state = DONE
				category = NUMLIT
			end
		else
			state = DONE
			category = NUMLIT
		end

	end
	
	local function handle_DIGIT()
		if ch == "e" or ch == "E" then
			state = EXP
		elseif isDigit(ch) then
			add1()
		else
			state = DONE
			category = NUMLIT
		end
	end

	local function handle_PLUS()
		if PREFOP then
			state = DONE
			category = OP
		elseif isDigit(ch) then
			add1()
			state = DIGIT 
		else
			state = DONE
			category = OP
		end
	end

		
	local function handle_MINUS()
		if PREFOP then
			state = DONE
			category = OP
		elseif isDigit(ch) then
			add1()
			state = DIGIT 
		else
			state = DONE
			category = OP
		end
	end

	local function handle_QUOTE()
		local singleQ = (currChar() == "\'")
		local qCount = 0
		local check = true
		while true do
			if check then
				add1()
			end
			
			if singleQ then
				if currChar() ~= "\'" and currChar() ~= '' then
				elseif currChar() == '' and lookAhead(-1) == "\'"  then
					add1()
					state = DONE
					category = STRINGLIT
					break
				elseif qCount == 2 then
					add1()
					state = DONE
					category = STRINGLIT
					break
				elseif currChar() == "\'" then
					check = false
					qCount = qCount + 1
				else
					add1()
					state = DONE
					category = MAL
					break
				end
			else
				if currChar() ~= "\"" and currChar() ~= "" then
				elseif currChar() == "" and lookAhead(-1) == "\""  then
					add1()
					state = DONE
					category = STRINGLIT
					break
				elseif qCount == 2 then
					add1()
					state = DONE
					category = STRINGLIT
					break
				elseif currChar() == "\"" then
					check = false
					qCount = qCount + 1
				else
					add1()
					state = DONE
					category = MAL
					break
				end
			end
		end
		if lexstr:len() == 1 and (lexstr == "\"" or lexstr == "\'") then
			state = DONE
			category = MAL
		end
	end


	local function handle_OTHEROP()
		if PREFOP then
			state = DONE
			category = OP
		elseif ch == "=" then
			add1()
			state = DONE
			category = OP
		elseif isDigit(nextChar()) then
			add1() state = DIGIT
		else
			state = DONE
			category = OP
		end
	end

	-- State Handler Functions --
	
	handlers = {
		[DONE]=handle_DONE,
		[START]=handle_START,
		[LETTER]=handle_LETTER,
		[DIGIT]=handle_DIGIT,
		[EXP]= handle_EXP,
		[PLUS]=handle_PLUS,
		[MINUS]=handle_MINUS,
		[QUOTE]=handle_QUOTE,
		[OTHEROP]=handle_OTHEROP
	}
	
	-- Iterator Function --
	
	--getLexeme
	--Called each time through the for-in loop
	--Returns a pair: lexeme-string and category, or
	--nil,nil if no more lexemes
	local function getLexeme(dummy1, dummy2)
		if pos>prog:len() then
			PREFOP = false
			return nil,nil
		end
		lexstr=""
		state = START
		while state ~= DONE do
			ch = currChar()
			handlers[state]()
		end
		
		skipWhitespace()
		PREFOP = false
		return lexstr, category
	end
	-- BODY FUNCTION --
	--
	-- Initialize & return the iterator function
	pos = 1
	skipWhitespace()

	return getLexeme, nil,nil
end

-- Module Export

return lexit
