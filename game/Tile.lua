require "class"

Tile = class:new()

function Tile:init(collidableTile, backgroundTile, waterTile, 
	foregroundObj, backgroundObj, activeObj)
	
	-- Do not be shocked with storing such many elements in
	-- one table for each tile - mostly many elements will be
	-- unused, because their value will be nil - in Lua
	-- storing nil in table is same as storing nothing
	-- so the allocated memory will be low.
	
	-- Collidable tile reference
	self.collidableTile = collidableTile
	
	-- Background tile reference
	self.backgroundTile = backgroundTile
	
	-- Animation object
	-- Unit's won't collide with this objects
	self.foregroundObj = foregroundObj
	self.backgroundObj = backgroundObj
	
	-- Active (may be collidable) objects (not tiles nor animation objects!)
	self.activeObj = activeObj
	
	-- Is tile bouncing now?
	self.isBouncing = false
	
	-- Vertical offset used while drawing
	self.verticalOffset = 0
	
	-- Tile header of water
	self.waterTile = waterTile
end

-- These functions could be better to have in Tile table
-- But in Lua to these functions you would have to store
-- pointers so the Tile table would be large (and so the grid)
function isTileCollidable(tile)
	return tile ~= nil and tile.collidableTile ~= nil
end

function isTileBouncable(tile)
	return isTileCollidable(tile) and tile.collidableTile.isBouncable
end

function isTileBreakable(tile)
	return isTileCollidable(tile) and tile.collidableTile.isBreakable
end

function isTilePlatform(tile)
	return isTileCollidable(tile) and tile.collidableTile.isPlatform
end

-- Is tile generator of ... coins, mushrooms etc...
function isTileGenerator(tile)
	return isTileCollidable(tile) and tile.collidableTile.generatorType ~= nil
end

function isTileSingleCoinGenerator(tile)
	return isTileCollidable(tile) and 
		tile.collidableTile.generatorType == "single_coin"
end

-- Unknown coins generator
-- Depends on the player's speed of jumping and bouncing the tile
function isTileCoinsGenerator(tile)
	return isTileCollidable(tile) and
		tile.collidableTile.generatorType == "coins"
end

function isTileBoostGenerator(tile)
	return isTileGenerator(tile) and
		string.find(tile.collidableTile.generatorType, "boost", 1) ~= nil
end

-- Check whether is given tile a specific boost generator
-- (In this case the name is a substring of generatorType,
-- especially "boost_" + genName)
function isTileBoostGeneratorSpecific(tile, genName)
	return isTileGenerator(tile) and
		string.find(tile.collidableTile.generatorType, genName, 1) ~= nil
end

-- Secret tile is always collidable - so the world can be informed
-- about it's revelation from it's tile-unit collision
function isTileSecret(tile)
	return isTileCollidable(tile) and tile.collidableTile.isSecret
end

function isWaterOnTile(tile)
	return tile ~= nil and tile.waterTile ~= nil
end

function isBackgroundOnTile(tile)
	return tile ~= nil and tile.backgroundTile ~= nil
end

function isTileDeadly(tile)
	return isTileCollidable(tile) and tile.collidableTile.isDeadly
end

-- Check if tile is oblique
-- @return 0 if is not
-- 		-1 if is oblique from the left side
-- 		1 if is oblique from the right side
function isTileOblique(tile)
	if isTileCollidable(tile) then
		return tile.collidableTile.oblique
	else
		return 0
	end
end

function hasTileActiveObject(tile)
	return tile ~= nil and tile.activeObj ~= nil
end