local class = require("class")
require("yk")
local Test = class("Test")

function Test:ctor(...)
	print("test1",...)
	self.a = 2
end 
local Test2 = class("Test2",Test)
function Test2:ctor( ... )
	print("test2",...)
	self.b = 3
end
local test = Test2.new(1,2)

