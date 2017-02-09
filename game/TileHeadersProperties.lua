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
	-- "Day" pack
	["static_block_bright"] = {
	},
	["brick_bright"] = {
		isBouncable = true,
		isBreakable = true,
	},
	["brick_bright_single_coin"] = {
		animationName = "brick_bright",
		isBouncable = true,
		generatorType = "single_coin",
		staticBlockName = "static_block_bright",
	},
	["brick_bright_coins"] = {
		animationName = "brick_bright",
		isBouncable = true,
		generatorType = "coins",
		staticBlockName = "static_block_bright",
	},
	["brick_bright_mushroom_life"] = {
		animationName = "brick_bright",
		isBouncable = true,
		generatorType = "boost_mushroom_life",
		staticBlockName = "static_block_bright"
	},
	["brick_bright_mushroom_grow"] = {
		animationName = "brick_bright",
		isBouncable = true,
		generatorType = "boost_mushroom_grow",
		staticBlockName = "static_block_bright"
	},
	["brick_bright_star"] = {
		animationName = "brick_bright",
		isBouncable = true,
		generatorType = "boost_star",
		staticBlockName = "static_block_bright"
	},
	["brick_bright_fireflower"] = {
		animationName = "brick_bright",
		isBouncable = true,
		generatorType = "boost_fireflower",
		staticBlockName = "static_block_bright"
	},
	["brick_bright_iceflower"] = {
		animationName = "brick_bright",
		isBouncable = true,
		generatorType = "boost_iceflower",
		staticBlockName = "static_block_bright"
	},
	
	-- "Night" pack
	["static_block_dark"] = {
	},
	["brick_dark"] = {
		isBouncable = true,
		isBreakable = true,
	},
	["brick_dark_coins"] = {
		animationName = "brick_dark",
		isBouncable = true,
		generatorType = "coins",
		staticBlockName = "static_block_dark",
	},
	
	-- Snow pack
	["static_block_snow"] = {
	},
	["snow"] = {
	},
	["snow_secret"] = {
		animationName = "snow",
		isSecret = true,
	},
	["snow_oblique_left"] = {
		isOblique = true,
		isObliqueLeftSide = true,
	},
	["snow_oblique_right"] = {
		isOblique = true,
		isObliqueLeftSide = false,
	},
	
	-- Wooden pack
	["wood"] = {
	},
	["wooden_platform"] = {
		isPlatform = true,
	},
	["wood_oblique_left"] = {
		isOblique = true,
		isObliqueLeftSide = true,
	},
	["wood_oblique_right"] = {
		isOblique = true,
		isObliqueLeftSide = false,
	},
	["wooden_background"] = {
	},
	
	-- Water
	["water_top"] = {
		isWater = true,
	},
	["water_inside"] = {
		isWater = true,
	},
	
	-- Deadly
	["lava_top"] = {
		isDeadly = true,
	},
	["lava_inside"] = {
		isDeadly = true,
	},
	["spikes"] = {
		isDeadly = true,
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