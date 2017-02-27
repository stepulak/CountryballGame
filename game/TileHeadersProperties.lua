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
	-- DAY PACK
	["wooden_platform"] = {
		isPlatform = true,
	},
	["grass_top"] = {
	},
	["grass_top_left"] = {
	},
	["grass_top_right"] = {
		animationName = "grass_top_left",
		isFlipped = true
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
	["grass_oblique_left"] = {
		isOblique = true,
		isObliqueLeftSide = true,
	},
	["grass_oblique_right"] = {
		isOblique = true,
		isObliqueLeftSide = false,
		isFlipped = true,
		animationName = "grass_oblique_left",
	},
	
	-- Wood
	["wood"] = {
	},
	-- Horizontal
	["wood_hor_mid"] = {
	},
	["wood_hor_mid2"] = {
		isFlipped = true,
		animationName = "wood_hor_mid",
	},
	["wood_left"] = {
	},
	["wood_left2"] = {
		isFlipped = true,
		animationName = "wood_right"
	},
	["wood_right"] = {
	},
	["wood_right2"] = {
		isFlipped = true,
		animationName = "wood_left"
	},
	-- Vertical
	["wood_ver_mid"] = {
		angle = 90,
		animationName = "wood_hor_mid",
	},
	["wood_ver_mid2"] = {
		angle = 90,
		isFlipped = true,
		animationName = "wood_hor_mid"
	},
	["wood_top"] = {
		angle = 90,
		animationName = "wood_left",
	},
	["wood_top2"] = {
		angle = 90,
		isFlipped = true,
		animationName = "wood_right",
	},
	["wood_bot"] = {
		angle = 90,
		animationName = "wood_right",
	},
	["wood_bot2"] = {
		angle = 90,
		isFlipped = true,
		animationName = "wood_left",
	},
	["wood_oblique_left"] = {
		isOblique = true,
		isObliqueLeftSide = true,
	},
	["wood_oblique_right"] = {
		isOblique = true,
		isObliqueLeftSide = false,
		isFlipped = true,
		animationName = "wood_oblique_left"
	},
	
	["brick_wall"] = {
	},
	["brick_oblique_left"] = {
		isOblique = true,
		isObliqueLeftSide = true,
	},
	["brick_oblique_right"] = {
		animationName = "brick_oblique_left",
		isOblique = true,
		isObliqueLeftSide = false,
		isFlipped = true,
	},
	
	["brick"] = {
		isBouncable = true,
		isBreakable = true,
	},
	["brick_secret"] = {
		isSecret = true,
		animationName = "brick"
	},
	
	["brick_coins"] = {
		animationName = "brick",
		isBouncable = true,
		generatorType = "coins",
		staticBlockName = "block",
	},
	["brick_single_coin"] = {
		animationName = "brick",
		isBouncable = true,
		generatorType = "single_coin",
		staticBlockName = "block",
	},
	["brick_mushroom_life"] = {
		animationName = "brick",
		isBouncable = true,
		generatorType = "boost_mushroom_life",
		staticBlockName = "block",
	},
	["brick_mushroom_grow"] = {
		animationName = "brick",
		isBouncable = true,
		generatorType = "boost_mushroom_grow",
		staticBlockName = "block",
	},
	["brick_star"] = {
		animationName = "brick",
		isBouncable = true,
		generatorType = "boost_star",
		staticBlockName = "block",
	},
	["brick_fireflower"] = {
		animationName = "brick",
		isBouncable = true,
		generatorType = "boost_fireflower",
		staticBlockName = "block",
	},
	["brick_iceflower"] = {
		animationName = "brick",
		isBouncable = true,
		generatorType = "boost_iceflower",
		staticBlockName = "block",
	},
	
	-- SNOW PACK
	["snow"] = {
	},
	["snow_top"] = {
	},
	["snow_mid"] = {
	},
	["snow_bot"] = {
	},
	["snow_mid_left"] = {
	},
	["snow_mid_right"] = {
		animationName = "snow_mid_left",
		isFlipped = true,
	},
	["snow_block"] = {
	},
	["snow_brick"] = {
		isBouncable = true,
		isBreakable = true,
	},
	["snow_brick_secret"] = {
		isSecret = true,
		animationName = "snow_brick"
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
		animationName = "snow_oblique_left",
		isOblique = true,
		isObliqueLeftSide = false,
		isFlipped = true,
	},
	["snow_wood_oblique_left"] = {
		isOblique = true,
		isObliqueLeftSide = true,
	},
	["snow_wood_oblique_right"] = {
		isOblique = true,
		isObliqueLeftSide = false,
		isFlipped = true,
		animationName = "snow_wood_oblique_left",
	},
	
	-- SNOW SURPRISE
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
	["fence"] = {
	},
	["wall"] = {
	},
	["wall_oblique_left"]= {
		isOblique = true,
		isObliqueLeftSide = true,
	},
	["wall_oblique_right"] = {
		isOblique = true,
		isObliqueLeftSide = false,
		isFlipped = true,
		animationName = "wall_oblique_left"
	}
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
				header.angle or 0,
				header.isFlipped or false,
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