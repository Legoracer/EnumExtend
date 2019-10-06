-- @name        EnumItem.lua
-- @author      Legoracer
-- @date        10/6/2019

local EnumItem = {}
EnumItem.__index = EnumItem

function EnumItem.new(name, value, enumType)
	local self = setmetatable({
		Name = name;
		Value = value;
		EnumType = enumType;
	}, EnumItem)
	local proxy = newproxy(true)
	local mt = getmetatable(proxy)
	
	mt.__index = function(_, k)
		local v = self[k]
		
		if v then
			return v
		else
			return error(("%s is not a valid member"):format(k))
		end
	end
	mt.__newindex = function(_, k, v)
		return error(('%s cannot be assigned to'):format(k))
	end
	mt.__metatable = "The metatable is locked"
	mt.__tostring = function()
		return ("Enum.%s.%s"):format(tostring(self.EnumType), self.Name)
	end
	
	return proxy
end

return EnumItem