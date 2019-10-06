-- @name        EnumExtend.lua
-- @author      Legoracer
-- @date        10/6/2019

local USE_ORIGINAL_ENUMS_AS_BASE = true

local OriginalEnum = Enum
local Enums = {}
local EnumExtend = {}
local Enum = require(script.Enum)

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
	for i,v in pairs(Enums) do e[#e=1]=v end
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

function EnumExtend:RemoveEnum(name)
	if Enums[name] then
		Enums[name] = nil
	else
		error(("Enum %s doesn't exist"):format(name))
	end
end

return EnumExtend