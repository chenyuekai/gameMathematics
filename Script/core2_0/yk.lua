yk_test = true
local tableDeep = 10
local function addTab(str,count)
	local space = string.rep("    ",count)
	local s = string.gsub(str,"\n","\n" .. space)
	return space .. s
end 
local function parseTb(tb,tmp,key,notMeta)
	key = key or "root"
	local result = "{"
	local content = ""
	tmp[tb] = key
	local function kvDeal( k,v )
		local kStr = ""
		if type(k) == "table" then
			if tmp[k] then
				kStr = tostring(k)..string.format("<%s>",tmp[k])
			else
				kStr = parseTb(k,tmp,key.."-key")
			end 
		else
			kStr = tostring(k) 
		end
		local val = ""
		if type(v) == "table"  then
			if tmp[v] then
				val = tostring(v)..string.format("<%s>",tmp[v])
			else
				val = parseTb(v,tmp,kStr)
			end 
		else
			if type(v) == "string" then
				val = string.format("\"%s\"",v)
			else
				val = tostring(v)
			end 
		end 
		local line = kStr .. "=" ..val
		return 	line
	end
	for k,v in pairs(tb) do
		content = content .. "\n" .. kvDeal(k,v) 
	end
	if not notMeta then
		local metaTb = getmetatable(tb)
		if metaTb then
			content = content .. "\n" .. kvDeal("<metaTb>",metaTb)
		end
	end 
	content = addTab(content,1)
	result = result .. content .. "\n}"
	return result
end 
function printTb(tb)
	local file = io.open("test.log", "w+")
	io.output(file)
	local str = "{\n" .. parseTb({},tb) .. "}"
	io.write(str);
	print(str)
	io.close(file)
end
function dumpTab( tb )
	local str = parseTb(tb,{},true)
	return str
end
function yk_var( tb)
	local str = false
	if type(tb) == "table" then
		str = parseTb(tb,{})
	else
		str = tostring(tb)
	end 
	print(str)
	return str
end
