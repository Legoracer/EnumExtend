-- @name        Enum.lua
-- @author      Legoracer
-- @date        10/6/2019

local Enum = {}
Enum.__index = Enum

local EnumItem = require(script.Parent.EnumItem)

function Enum.new(name)
	assert(type(name)=='string', 'Invalid Enum name')
	
	local self = setmetatable({
		_name = name;
		_enums = {};
	}, Enum)
	local proxy = newproxy(true)
	local mt = getmetatable(proxy)
	
	self._proxy = proxy
	
	mt.__index = function(_, k)
		local enumItem = self._enums[k]
		local f = self[k]
		
		if enumItem then
			return enumItem
		elseif f then
			return f
		else
			return error(("%s is not a valid EnumItem"):format(k))
		end
	end
	mt.__newindex = function(_, k, v)
		return error(("%s cannot be assigned to"):format(k))
	end
	mt.__metatable = "The metatable is locked"
	mt.__tostring = function()
		return name
	end
	
	return proxy
end

function Enum:GetEnumItems()
	local nt = {}
	for k,v in pairs(self._enums) do nt[#nt+1]=v end
	return nt
end

function Enum:SetEnumItem(name, value)
	assert(type(name)=='string', 'Invalid EnumItem name')
	
	self._enums[name] = EnumItem.new(name, value, self._proxy)
end

return Enum