-- @name        EnumExtend.lua
-- @author      Legoracer
-- @date        10/6/2019

local USE_ORIGINAL_ENUMS_AS_BASE = true
local DEBUG_MODE = false

local OriginalEnum = Enum

local Enums = {}
local EnumExtend = {}
local Enum = require(script.Enum)

local _print = print;
local _warn = warn;
function print(...) if DEBUG_MODE then _print(...) end end
function warn(...) if DEBUG_MODE then _warn(...) end end

do -- Compile original enums
	if USE_ORIGINAL_ENUMS_AS_BASE then
		for _,v in pairs(OriginalEnum:GetEnums()) do
			local name = tostring(v)
			local enum = Enum.new(name)
			warn(enum)
			
			for _,v in pairs(v:GetEnumItems()) do
				local name = v.Name;
				local value = v.Value;
				
				print(name, value)
				enum:SetEnumItem(name, value)
			end
			
			Enums[name] = enum
		end
	end
end

function EnumExtend:GetEnums()
	local e = {}
	for i,v in pairs(Enums) do e[#e+1]=v end
	return e
end

function EnumExtend:AddEnum(name)
	if Enums[name] then
		error(('Enum %s already exists'):format(name))
	else
		local e = Enum.new(name)
		Enums[name] = e
		
		return e
	end
end

function EnumExtend:AddEnumFromModule(module)
	local src = require(module)
	assert(type(src)=='table', "Invalid Enum module")
	assert(Enums[module.Name], ("Enum %s already exists"):format(module.Name))
	
	local enum = Enum.new(module.Name)
	for i,v in pairs(src) do
		enum:SetEnumItem(v, i)
	end
	
	Enums[module.Name] = enum
end

function EnumExtend:RemoveEnum(name)
	if Enums[name] then
		Enums[name] = nil
	else
		error(("Enum %s doesn't exist"):format(name))
	end
end

return setmetatable(EnumExtend, {
	__index = function(_, k)
		local f = rawget(EnumExtend, k)
		local e = Enums[k]
		
		if f then
			return f
		elseif e then
			return e
		else
			return error(k, "is not valid Enum")
		end
	end
})