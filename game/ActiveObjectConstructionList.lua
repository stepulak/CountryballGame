require "ActiveObject"
require "Trampoline"
require "Canon"
require "Teleport"
require "SmokeSource"
require "Platform"
require "Utils"

local constructionList = {
	["trampoline"] = function(p)
		return Trampoline:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.tc:getTexture("trampoline_platform"))
	end,
	
	["canon"] = function(p)
		return Canon:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.dirLeft, p.arg or 3, p.tc:getAnimation("canon"))
	end,
	
	["teleport"] = function(p)
		return Teleport:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.tc:getAnimation("teleport"))
	end,
	
	["smoke_source"] = function(p)
		return SmokeSource:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.tc:getTexture("smoke"))
	end,
	
	["vertical_platform_start"] = function(p)
		return Platform:new(p.x, p.y, p.tileWidth, p.tileHeight, true, true,
			p.tc:getTexture("floating_platform"))
	end,
	
	["horizontal_platform_start"] = function(p)
		return Platform:new(p.x, p.y, p.tileWidth, p.tileHeight, false, true,
			p.tc:getTexture("floating_platform"))
	end,
	
	["vertical_platform_end"] = function(p)
		return Platform:new(p.x, p.y, p.tileWidth, p.tileHeight, true, false,
			p.tc:getTexture("floating_platform"))
	end,
	
	["horizontal_platform_end"] = function(p)
		return Platform:new(p.x, p.y, p.tileWidth, p.tileHeight, false, false,
			p.tc:getTexture("floating_platform"))
	end,
}

-- @dirLeft, @arg is optional
function createActiveObjectFromName(name,
	x, y, tileWidth, tileHeight,
	textureContainer, dirLeft, ...)
	
	if constructionList[name] == nil then
		return nil
	end
	
	if dirLeft == nil then
		dirLeft = true
	end
	
	local params = {
		["x"] = x,
		["y"] = y,
		["tileWidth"] = tileWidth,
		["tileHeight"] = tileHeight,
		["tc"] = textureContainer,
		["dirLeft"] = dirLeft,
		["arg"] = ...,
	}
	
	return constructionList[name](params)
end

function getActiveObjectNamesList()
	return getKeysFromTable(constructionList)
end