-- List of properties of animation objects

-- Mostly their property consist only from proportions.

-- If you want to explicitly specify their animation name,
-- use the animationName="name" parameter. Otherwise 
-- the object's key will be used as a key for getting
-- the animation from the animation's container.

require "AnimationObject"

local properties = {
	["bush_1"] = {
		width = 1,
		height = 1,
	},
	["bush_2"] = {
		width = 2,
		height = 1,
	},
	["tree_1"] = {
		width = 3,
		height = 4,
	},
	["tree_2"] = {
		width = 4,
		height = 4,
	},
	["tree_3"] = {
		width = 3,
		height = 4,
	},
	["tree_4"] = {
		width = 3,
		height = 4,
	},
	["fire"] = {
		width = 1,
		height = 1,
	},
	["snowman"] = {
		width = 2,
		height = 3,
	},
	["rock"] = {
		width = 1,
		height = 1,
	},
	["snow_rock"] = {
		width = 1,
		height = 1,
	},
	["finish_line"] = {
		width = 1,
		height = 1,
	},
	["streetlamp"] = {
		width = 2,
		height = 3,
	},
	["water_grass"] = {
		width = 1,
		height = 1,
	},
}

-- Create new animation object from given name
-- @animObjContainer is optional
function createAnimationObjectFromName(name, x, y,
	tileWidth, tileHeight, textureContainer, animObjContainer)
	
	if properties[name] == nil then
		return nil
	end
	
	local prop = properties[name]
	local animName = properties[name].animationName or name
	
	local obj = AnimationObject:new(name, x, y, prop.width, prop.height,
		tileWidth, tileHeight, textureContainer:getAnimation(animName))
	
	if animObjContainer then
		animObjContainer:add(name, obj)
	end
	
	return obj
end

function getAnimationObjectNamesList()
	return getKeysFromTable(properties)
end