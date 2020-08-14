local M = class("Vector")


function M:ctor( array )
	self.__size = 0
	self.__element = {}
end
function M:_init( array )
	array = array or {}
	self.__size = #array
	for i=1,self.__size do
		self.__element[i] = array[i] or 0
	end
end
function M.CheckSize(a,b)
	return a.__size == b.__size
end
function M.Mult( v1,v2 )
	return v1.mult(v2)
end
function M.MultScal( v1,scalar )
	v1 = v1:clone()
	v1:multScal(scalar)
	return v1
end
function M.Add( a,b )
	a = a:clone()
	a:add(b)
	return a
end
function M.Sub( v1,v2 )
	v1 = v1:clone()
	v1:sub(v2)
	return v1
end
function M.Create( size )
	local v = M.new()
	v.__size = size
	v.__element = {}
	for i=1,size do
		v.__element[i] = 0
	end
	return v
end
function M:clone()
	return M.new(self.__element)
end
function M:getElem( index )
	return self.__element[i]
end
function M:setElem( i,v )
	if i > self.__size then
		error("out of size Vector " )
	else
		self.__element[i] = v
	end 
end

function M:setContent( array )
	for i=1,self.__size do
		self.__element[i] = array[i] or self.__element[i]
	end
end

function M:print( ... )
	print(table.concat(self.__element,","))
end

function M:add( vec )
	if M.CheckSize(self,vec) then
		for i=1,self.__size do
			self.__element[i] = self.__element[i] + vec.__element[i]
		end
	else
		error("diff size between vecs")
	end 
end
function M:sub( vec )
	if M.CheckSize(self,vec) then
		for i=1,self.__size do
			self.__element[i] = self.__element[i] - vec.__element[i]
		end
	else
		error("diff size between vecs")
	end 
end
function M:mult( vec )
	if M.CheckSize(self,vec) then
		local a = 0
		for i=1,self.__size do
			a = a + self.__element[i] * vec.__element[i]
		end
		return a
	else
		error("diff size between vecs")
	end 
end
function M:multScal( a )
	for i=1,self.__size do
		self.__element[i] = self.__element[i] * a
	end
end
function M:length()
	local a = 0
	for i,v in ipairs(self.__element) do
		a = a + v*v
	end
	return math.sqrt(a)
end
function M:toString( ... )
	return ""
end
-- 在向量上的投影 p*q/(|q|^2) * q 
function M:projOn( q )
	return M.MultScal(q,self:mult(q)/(q:length()^2))
end
--在q上的垂直分量
function M:perpOn( q )
	local a = self:projOn(q)
	return M.Sub(self,a)
end

return M
