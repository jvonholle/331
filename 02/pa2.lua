-- James Von Holle
-- CS 331
-- Assignment 2
-- pa2.lua
-- 2/11/2015

local pa2 = {}

--Function concatLimit String
--Takes an int and a string
--returns as many of the string as it can
--without going over the given int.
function pa2.concatLimit(s, i)
	local ri = math.floor(i)
	local rs = s
	if string.len(rs)<i then
		while string.len(rs)+string.len(s)<=ri do
			rs = rs..s
		end
	elseif string.len(rs) == i then
		rs = rs	
	else
		rs = ""
	end
	return rs
end

--Function filterTable
--Takes a function that returns a bool,
--and a table with values. Returns a new table
--that is filled with values from the first table
--that satisfy the function.
function pa2.filterTable(f, t)
	local table1 = {}
	for it, iv in pairs(t) do 
		if f(it,iv) then
			table1[it]=t[it] 
		end
	end
	return table1
end

--Function collatzSeq
--Takes an int and returns
--the Collatz seqence (k, c(k), c(c(k)...1)
function pa2.collatzSeq(k)
	local count = 0	
	while true do
		if count == 1  then
			break
		end
		if k == 1 then
			count = count + 1
		end
		coroutine.yield(k)
		if math.fmod(k,2)==0 then
			k = k/2	
		else
			k = (k*3) + 1
		end
	end
end	


return pa2
