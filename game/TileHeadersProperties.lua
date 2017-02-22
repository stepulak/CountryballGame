-- Tile headers properties

-- If the specified property is not set,
-- then it will be considered as a false value.

-- All of the tiles are collidable by default - 
-- but you cannot change this here, you can prevent
-- the collision by placing it into the background in the Tile table.

-- You can also explicitly specify their animation name with
-- animationName = "name" parameter. If it's not set, then their
-- key name will be used as a name to get the animation.

-- See TileHeader table in TileHeader.lua for more details
-- about how to setup a property.

local properties = {
	-- Day pack
	["wooden_platform"] = {
		isPlatform = true,
	},
	["grass_top"] = {
	},
	["mud_mid"] = {
	},
	["mud_bot"] = {
	},
	["grass_funny_left"] = {
	},
	["grass_funny_right"] = {
	},
	["grass_funny_mid"] = {
	},
	--[[["block"] = {
	},
	["dirt"] = {
	},
	["dirt_top"] = {
	},
	["dirt_bot"] = {
	},
	["brick_bright"] = {
		isBouncable = true,
		isBreakable = true,
	},]]
	
	-- Snow pack
	["snow"] = {
	},
	["snow_top"] = {
	},
	["snow_mid"] = {
	},
	["snow_bot"] = {
	},
	["snow_block"] = {
	},
	["snow_brick"] = {
		isBouncable = true,
		isBreakable = true,
	},
	["snow_platform"] = {
		isPlatform = true,
	},
	["snow_funny_left"] = {
	},
	["snow_funny_mid"] = {
	},
	["snow_funny_right"] = {
	},
	["snow_brick_coins"] = {
		animationName = "snow_brick",
		isBouncable = true,
		generatorType = "coins",
		staticBlockName = "snow_block",
	},
	["snow_brick_single_coin"] = {
		animationName = "snow_brick",
		isBouncable = true,
		generatorType = "single_coin",
		staticBlockName = "snow_block",
	},
	["snow_brick_mushroom_life"] = {
		animationName = "snow_brick",
		isBouncable = true,
		generatorType = "boost_mushroom_life",
		staticBlockName = "snow_block",
	},
	["snow_brick_mushroom_grow"] = {
		animationName = "snow_brick",
		isBouncable = true,
		generatorType = "boost_mushroom_grow",
		staticBlockName = "snow_block",
	},
	["snow_brick_star"] = {
		animationName = "snow_brick",
		isBouncable = true,
		generatorType = "boost_star",
		staticBlockName = "snow_block",
	},
	["snow_brick_fireflower"] = {
		animationName = "snow_brick",
		isBouncable = true,
		generatorType = "boost_fireflower",
		staticBlockName = "snow_block",
	},
	["snow_brick_iceflower"] = {
		animationName = "snow_brick",
		isBouncable = true,
		generatorType = "boost_iceflower",
		staticBlockName = "snow_block",
	},
	["icicle"] = {
	},
	["snow_oblique_left"] = {
		isOblique = true,
		isObliqueLeftSide = true,
	},
	["snow_oblique_right"] = {
		isOblique = true,
		isObliqueLeftSide = false,
	},
	
	-- Snow surprise
	["snow_surprise_coin"] = {
		animationName = "surprise",
		isBouncable = true,
		generatorType = "single_coin",
		staticBlockName = "snow_block",
	},
	["snow_surprise_mushroom_grow"] = {
		animationName = "surprise",
		isBouncable = true,
		generatorType = "boost_mushroom_grow",
		staticBlockName = "snow_block",
	},
	["snow_surprise_mushroom_life"] = {
		animationName = "surprise",
		isBouncable = true,
		generatorType = "boost_mushroom_life",
		staticBlockName = "snow_block",
	},
	["snow_surprise_fireflower"] = {
		animationName = "surprise",
		isBouncable = true,
		generatorType = "boost_fireflower",
		staticBlockName = "snow_block",
	},
	["snow_surprise_iceflower"] = {
		animationName = "surprise",
		isBouncable = true,
		generatorType = "boost_iceflower",
		staticBlockName = "snow_block",
	},
	["snow_surprise_star"] = {
		animationName = "surprise",
		isBouncable = true,
		generatorType = "boost_star",
		staticBlockName = "snow_block",
	},
	
	-- Water
	["water_top"] = {
		isWater = true,
	},
	["water_inside"] = {
		isWater = true,
	},
	
	-- Deadly
	["spikes"] = {
		isDeadly = true,
	},
	["lava_top"] = {
		isDeadly = true,
	},
	["lava_inside"] = {
		isDeadly = true,
	},
	
	-- Additional
	["timber"] = {
	},
	["tube"] = {
	},
	["finish_line"] = {
	},
}

-- Create a new Tile header from name
function createTileHeaderFromName(name, textureContainer)
	local header = properties[name]
	
	if header then
		local animation = textureContainer:getAnimation(
			header.animationName or name)
		
		if animation then
			return TileHeader:new(name, 
				header.isBreakable or false,
				header.isBouncable or false,
				header.isOblique or false,
				header.isObliqueLeftSide or false,
				header.isPlatform or false,
				header.isWater or false,
				header.isDeadly or false,
				header.isSecret or false,
				header.generatorType or nil,
				header.staticBlockName or nil, -- "after" block or disappear
				animation)
		end
	end
	
	return nil 
end

function fillTileHeaderContainer(headerContainer, textureContainer)
	for name, value in pairs(properties) do
		headerContainer:addHeader(name,
			createTileHeaderFromName(name, textureContainer))
	end
end