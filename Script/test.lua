require("core2_0.init")
local Vector = require("MathItem.Vector")
local Vec3 = require("MathItem.Vec3")
function main( ... )
	local a = Vector.new({2,1,1,2})
	local b = Vector.new({1,1,1,3})
	local c = b:projOn(a)
	local d = b:perpOn(a)
	c:print()
	d:print()
	print("--------------")
	local v3 = Vec3.new({1,0,0})
	local v31 = Vec3.new({0.5,1.5,0})
	local v32 = v3:cross(v31)
	v32:print()

end

main()