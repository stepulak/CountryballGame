-- List of properties of animation objects

-- Mostly their property consist only from proportions.

-- If you want to explicitly specify their animation name,
-- use the animationName="name" parameter. Otherwise 
-- the object's name will be used as a key for getting
-- the animation from the container.

require "AnimationObject"

local properties = {
	["grass_1_1"] = {
		width = 1,
		height = 1,
	},
	["snow_blanket"] = {
		width = 1,
		height = 1,
	},
	["tree_light_1_3"] = {
		width = 1,
		height = 3,
	},
	["tree_dark_1_3"] = {
		width = 1,
		height = 3,
	},
	["tree_light_1_2"] = {
		width = 1,
		height = 2,
	},
	["tree_dark_1_2"] = {
		width = 1,
		height = 2,
	},
	["tree_anim_2_3"] = {
		width = 2,
		height = 3
	},
	["tree_naked_2_3"] = {
		width = 2,
		height = 3
	},
	["torch"] = {
		width = 1,
		height = 3,
	}
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