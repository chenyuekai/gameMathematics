local Vector = require("MathItem.Vector")
local M = class("Vec3",Vector)

function M:ctor( array )

end
function M:_init( array )
	array = array or {}
	self.__size = 3
	for i=1,3 do
		self.__element[i] = array[i] or 0
	end
end
function M:x()
	return self.__element[1]
end
function M:y()
	return self.__element[2]
end
function M:z()
	return self.__element[3]
end
function M:cross( v )
	local a = self.__element
	local b = v.__element
	local array = {
		a[2] * b[3] - a[3] * b[2],
		a[3] * b[1] - a[1] * b[3],
		a[1] * b[2] - a[2] * b[1],
	}
	return M.new(array)
end

return M