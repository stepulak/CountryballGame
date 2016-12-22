require "SinCosTable"
require "Camera"
require "LinkedList"
require "ParallaxBackground"
require "ParticleSystem"
require "TextureContainer"
require "Tile"
require "TileHeaderContainer"
require "AnimationObjectContainer"
require "Trampoline"
require "Teleport"
require "Canon"
require "BouncingTilesContainer"
require "Projectile"
require "BoostGenerator"
require "SmokeSource"
require "CoinGenerator"
require "UnitConstructionList"
require "ActiveObjectConstructionList"
require "AnimationObjectsProperties"

local WorldBouncingTileHeightQ = 2/3
local WorldGravity = 2000

World = class:new()

-- @screen must consist of virtual and real proportions
function World:init(player, 
	tileWidth, tileHeight, screen,
	textureContainer, headerContainer, 
	sinCosTable, fonts)
	
	self.screen = screen
	self.tileWidth = tileWidth
	self.tileHeight = tileHeight
	
	self.textureContainer = textureContainer
	self.sinCosTable = sinCosTable
	self.headerContainer = headerContainer
	self.fonts = fonts
	
	self.player = player
	self.playerSpawnX = tileWidth/2
	self.playerSpawnY = tileHeight/2
	self.playerFinishLine = tileWidth/2
	self.playerFinished = false
	
	-- True if you want to close this world and to the next one
	-- (Only in campaign)
	self.shouldEnd = false 
	
	self.drawCounter = 0
end

function World:createEmptyWorld(numTilesWidth, numTilesHeight)
	self.numTilesWidth = numTilesWidth
	self.numTilesHeight = numTilesHeight
	
	self:createCamera()
	
	self.bouncingTilesContainer = 
		BouncingTilesContainer:new(self.tileHeight * WorldBouncingTileHeightQ)
	
	-- Generators
	self.coinGenerators = {}
	self.boostGenerators = LinkedList:new()
	
	-- Active objects
	self.animObjContainer = AnimationObjectContainer:new()
	self.activeObjects = LinkedList:new()
	
	-- Foreground particle system
	self.fParticleSystem = ParticleSystem:new()
	-- Background particle system
	self.bParticleSystem = ParticleSystem:new()
	
	self.projectiles = LinkedList:new()
	self.activeUnits = LinkedList:new()
	self.waitingUnits = LinkedList:new()
	
	self:createGrid()
	self:createParallaxBackground()
	
	self:setPlayersSpawnPosition(1, 1)
	self:setPlayersFinishLine(numTilesWidth - 3)
	self:setupPlayer()
	
	-- TODO REMOVE
	self:loadSample()
end

function World:loadFrom(filename)
	-- TODO
end

function World:saveTo(filename)
	-- TODO
end

function World:createCamera()
	self.camera = Camera:new(0, 0, 
		self.screen.virtualWidth, self.screen.virtualHeight,
		self.screen.width, self.screen.height,
		self.numTilesWidth * self.tileWidth,
		self.numTilesHeight * self.tileHeight)
end

function World:setPlayerAtSpawnPosition()
	self.player.x = self.playerSpawnX
	self.player.y = self.playerSpawnY
end

-- There must be a reference to player in self.player
function World:setupPlayer()
	if self.player == nil then
		print("Missing player!")
		return
	end
	
	self.activeUnits:pushFront(self.player)
	self:setPlayerAtSpawnPosition()
end

-- @x, @y are tile positions (better manipulation)
function World:setPlayersSpawnPosition(x, y)
	if self:isInsideGrid(x, y) then
		self.playerSpawnX = x * self.tileWidth + self.tileWidth/2
		self.playerSpawnY = y * self.tileHeight + self.tileHeight/2
		return true
	end
	return false
end

-- Set finish line at specific horizontal position
-- The finish line's height is through whole map in vertical direction
-- @x is tile position (better manipulation)
function World:setPlayersFinishLine(x)
	if self:isInsideGrid(x, 0) then
		self.playerFinishLine = x * self.tileWidth + self.tileWidth/2
		return true
	end
	return false
end

function World:loadSample()
	-- TODO REMOVE ALL
	for i = 0, self.numTilesWidth-10 do
		self.tiles[i][20] = Tile:new(self.headerContainer:getHeader("wood"))
	end
	
	self.tiles[5][19] = Tile:new(self.headerContainer:getHeader("snow_oblique_left"))
	self.tiles[6][19] = Tile:new(self.headerContainer:getHeader("snow"))
	
	self.tiles[7][19] = Tile:new(self.headerContainer:getHeader("snow_oblique_right"))
	
	self.tiles[8][19] = Tile:new(self.headerContainer:getHeader("snow_oblique_left"))
	self.tiles[9][19] = Tile:new(self.headerContainer:getHeader("snow"))
	self.tiles[10][19] = Tile:new(self.headerContainer:getHeader("snow_oblique_right"))
	
	self.tiles[9][18] = Tile:new(self.headerContainer:getHeader("snow_oblique_left"))
	self.tiles[6][18] = Tile:new(self.headerContainer:getHeader("snow"))
	
	
	self.tiles[16][18] = Tile:new(self.headerContainer:getHeader("snow"))
	self.tiles[16][19] = Tile:new(self.headerContainer:getHeader("snow"))
	self.tiles[17][18] = Tile:new(self.headerContainer:getHeader("snow"))
	self.tiles[17][19] = Tile:new(self.headerContainer:getHeader("snow"))
	self.tiles[15][19] = Tile:new(self.headerContainer:getHeader("snow"))
	self.tiles[18][19] = Tile:new(self.headerContainer:getHeader("snow"))
	
	self.tiles[14][19] = Tile:new(self.headerContainer:getHeader("snow"))
	
	self.tiles[15][18] = Tile:new(self.headerContainer:getHeader("snow"))
	
	self.tiles[16][17] = Tile:new(self.headerContainer:getHeader("snow"))
	
	self.tiles[17][17] = Tile:new(self.headerContainer:getHeader("snow"))
	
	self.tiles[18][18] = Tile:new(self.headerContainer:getHeader("snow"))
	
	self.tiles[19][19] = Tile:new(self.headerContainer:getHeader("snow"))
	
	self.tiles[25][19] = Tile:new(self.headerContainer:getHeader("snow"))
	self.tiles[2][10] = Tile:new(self.headerContainer:getHeader("snow"))
	
	self.tiles[37][19] = Tile:new(self.headerContainer:getHeader("lava_inside"))
	self.tiles[36][19] = Tile:new(self.headerContainer:getHeader("lava_inside"))
	self.tiles[38][19] = Tile:new(self.headerContainer:getHeader("lava_inside"))
	self.tiles[36][18] = Tile:new(self.headerContainer:getHeader("lava_top"))
	self.tiles[37][18] = Tile:new(self.headerContainer:getHeader("lava_top"))
	self.tiles[38][18] = Tile:new(self.headerContainer:getHeader("lava_top"))
	
	self.tiles[39][19] = Tile:new(self.headerContainer:getHeader("snow"))
	
	self.tiles[13][19] = Tile:new(self.headerContainer:getHeader("snow_oblique_left"))
	self.tiles[14][18] = Tile:new(self.headerContainer:getHeader("snow_oblique_left"))
	self.tiles[15][17] = Tile:new(self.headerContainer:getHeader("snow_oblique_left"))
	self.tiles[16][16] = Tile:new(self.headerContainer:getHeader("snow_oblique_left"))
	
	self.tiles[20][19] = Tile:new(self.headerContainer:getHeader("snow_oblique_right"))
	self.tiles[19][18] = Tile:new(self.headerContainer:getHeader("snow_oblique_right"))
	self.tiles[18][17] = Tile:new(self.headerContainer:getHeader("snow_oblique_right"))
	self.tiles[17][16] = Tile:new(self.headerContainer:getHeader("snow_oblique_right"))
	
	self.tiles[10][16] = Tile:new(self.headerContainer:getHeader("brick_bright"))
	self.tiles[11][16] = Tile:new(self.headerContainer:getHeader("brick_dark"))
	self.tiles[0][15] = Tile:new(self.headerContainer:getHeader("brick_dark"))
	
	self.tiles[2][17] = Tile:new(self.headerContainer:getHeader("wooden_platform"))
	self.tiles[3][17] = Tile:new(self.headerContainer:getHeader("wooden_platform"))
	self.tiles[4][17] = Tile:new(self.headerContainer:getHeader("wooden_platform"))
	
	for x = 50, 60 do
		self.tiles[x][18] = Tile:new(self.headerContainer:getHeader("wooden_platform"))
	end
	
	for x = 50, 60 do
		self.tiles[x][16] = Tile:new(self.headerContainer:getHeader("wooden_platform"))
	end
	
	for x = 50, 60 do
		self.tiles[x][14] = Tile:new(self.headerContainer:getHeader("wooden_platform"))
	end
	
	for x = 65, 85 do
		for y = 14, 19 do
			self.tiles[x][y] = Tile:new(nil, nil, self.headerContainer:getHeader("water_inside"))
		end
	end
	for x = 65, 85 do
		self.tiles[x][13] = Tile:new(nil, nil,self.headerContainer:getHeader("water_top"))
	end
	
	self.tiles[42][16] = Tile:new(self.headerContainer:getHeader("brick_dark_coins"))
	self.tiles[130][19] = Tile:new(self.headerContainer:getHeader("brick_dark_coins"))
	
	--self.tiles[10][19] = Tile:new(self.headerContainer:getHeader("spikes"), nil, nil, nil, nil, nil)
	
	self:fillObjectIntoGrid(createAnimationObjectFromName("snow_blanket", 2, 19, self.tileWidth, self.tileHeight, self.textureContainer, self.animObjContainer), "foregroundObj")
	self:fillObjectIntoGrid(createAnimationObjectFromName("torch", 22, 17, self.tileWidth, self.tileHeight, self.textureContainer, self.animObjContainer), "backgroundObj")
	self:fillObjectIntoGrid(createAnimationObjectFromName("snow_blanket", 3, 19, self.tileWidth, self.tileHeight, self.textureContainer, self.animObjContainer), "foregroundObj")
	self:fillObjectIntoGrid(createAnimationObjectFromName("grass_1_1", 4, 19, self.tileWidth, self.tileHeight, self.textureContainer, self.animObjContainer), "backgroundObj")
		
	local tramp = Trampoline:new(4, 16, self.tileWidth, self.tileHeight, self.textureContainer:getTexture("trampoline_platform"))
	self:fillObjectIntoGrid(tramp, "activeObj")
	self.activeObjects:pushBack(tramp)
	
	local tel = Teleport:new(3, 16, self.tileWidth, self.tileHeight, self.textureContainer:getAnimation("teleport"))
	self:fillObjectIntoGrid(tel, "activeObj")
	self.activeObjects:pushBack(tel)
	
	local tel2 = Teleport:new(40, 19, self.tileWidth, self.tileHeight, self.textureContainer:getAnimation("teleport")):setTwin(tel)
	self:fillObjectIntoGrid(tel2, "activeObj")
	self.activeObjects:pushBack(tel2)
	tel:setTwin(tel2)
	
	--[[
	local canon = Canon:new(10, 15, self.tileWidth, self.tileHeight, false, 3, self.textureContainer:getAnimation("canon"))
	self:fillObjectIntoGrid(canon, "activeObj")
	self.activeObjects:pushBack(canon)
	]]
	
	self.tiles[0][17] = Tile:new(self.headerContainer:getHeader("brick_bright_mushroom_grow"))
	self.tiles[1][17] = Tile:new(self.headerContainer:getHeader("brick_bright_iceflower"))
	
	--[[
	local smoke = SmokeSource:new(3, 13, self.tileWidth, self.tileHeight, self.textureContainer:getTexture("smoke"))
	self:fillObjectIntoGrid(smoke, "activeObj")
	self.activeObjects:pushBack(smoke)
	]]
	
	-- 1st background
	self.parallaxBackground:setCameraVelocity(1, 0)
	self.parallaxBackground:setBackgroundTexture(1, self.textureContainer:getTexture("background1_day"))
	
	-- 2nd background
	self.parallaxBackground:setCameraVelocity(2, 0.05)
	self.parallaxBackground:enableClouds(2, false, 3)
	self.parallaxBackground:setBackgroundTexture(2, self.textureContainer:getTexture("background2_snow_mountains"))
	
	-- 3rd background
	self.parallaxBackground:setCameraVelocity(3, 0.2)
	self.parallaxBackground:enableClouds(3, true, 10)
	self.parallaxBackground:setBackgroundTexture(3, self.textureContainer:getTexture("background3_spring_forest"))
	
	-- 4th background
	self.parallaxBackground:setCameraVelocity(4, 0.3)
	self.parallaxBackground:enableSnow(4, true)
	
	self:preRunWeather()
end

function World:createGrid()
	self.tiles = {}
	for i = 0, self.numTilesWidth-1 do
		self.tiles[i] = {}
		for j = 0, self.numTilesHeight-1 do
			self.tiles[i][j] = Tile:new()
		end
	end
end

function World:createParallaxBackground()
	self.parallaxBackground = ParallaxBackground:new(
		self.textureContainer:getTexture("cloud"),
		self.textureContainer:getTexture("snow_flake"),
		self.textureContainer:getTexture("rain_drop"))
end

-- Set new tile into specific position
-- Remember, the old tile will not stay and will be overwritten. 
-- @x, @y = grid position
-- @tileType = "collidable", "background", "water"
-- @headerName = name of the tile inside headerContainer
function World:setTile(x, y, tileType, headerName)
	if self:isInsideGrid(x, y) == false then
		return
	end
	
	local header = self.headerContainer:getHeader(headerName)
	
	if header then
		if tileType == "collidable" then
			self.tiles[x][y] = Tile:new(header)
		elseif tileType == "background" then
			self.tiles[x][y] = Tile:new(nil, header)
		elseif tileType == "water" then
			self.tiles[x][y] = Tile:new(nil, nil, header)
		end
	end
end

function World:removeTile(x, y)
	if self:isInsideGrid(x, y) then
		self.tiles[x][y] = Tile:new()
	end
end

-- Light up tile at given world position
-- @centerX, @centerY, @width, @height are in pixels, not in tiles!
function World:lightUpTilesAtPosition(centerX, centerY, width, height)
	local startX = math.floor((centerX - width/2) / self.tileWidth)
	local startY = math.floor((centerY - height/2) / self.tileHeight)
	
	width = setWithinRange(math.floor(width / self.tileWidth), 1, 999)
	height = setWithinRange(math.floor(height / self.tileHeight), 1, 999)
	
	if self:isInsideGrid(startX, startY) and
		self:isInsideGrid(startX + width - 1, startY + height - 1) then
		-- Inside the grid? Green
		love.graphics.setColor(0, 255, 0, 100)
	else
		-- Red
		love.graphics.setColor(255, 0, 0, 100)
	end
	
	love.graphics.rectangle("fill", 
		startX * self.tileWidth - self.camera.x,
		startY * self.tileHeight - self.camera.y,
		width * self.tileWidth, height * self.tileHeight)
	
	love.graphics.setColor(255, 255, 255, 255)
end

-- @velocity should be from interval of <0, 1>
function World:setCameraVelocityParallaxBackground(backgroundLvl, velocity)
	self.parallaxBackground:setCameraVelocity(backgroundLvl, velocity)
end

-- @textureName name of the texture in textureContainer
function World:setBackgroundTexture(backgroundLvl, textureName)
	self.parallaxBackground:setBackgroundTexture(backgroundLvl,
		self.textureContainer:getTexture(textureName))
end

function World:setBackgroundColor(backgroundLvl, r, g, b, a)
	self.parallaxBackground:setBackgroundColor(backgroundLvl, r, g, b, a)
end

-- Enable specified weather
-- @weatherName = "Clouds", "Snow", "Rain"
-- See ParallaxBackground:enable*(weatherName)* for another details about arg
function World:enableWeather(backgroundLvl, weatherName, ...)
	self.parallaxBackground["enable"..weatherName](self.parallaxBackground,
		backgroundLvl, ...)
end

-- Disable specified weather
-- @weatherName = "Clouds", "Snow", "Rain"
function World:disableWeather(backgroundLvl, weatherName)
	self.parallaxBackground["disable"..weatherName](self.parallaxBackground,
		backgroundLvl)
end

function World:preRunWeather()
	self.parallaxBackground:preRunWeather(self.camera, self.sinCosTable)
end

-- @position = foreground or background
function World:addAnimationObject(obj, position)
	self:fillObjectIntoGrid(obj, position .. "Obj")
end

function World:addActiveObject(obj)
	self:fillObjectIntoGrid(obj, "activeObj")
	self.activeObjects:pushBack(obj)
end

-- @list = either waitingUnits or activeUnits
-- @x, @y are virtual coordinates
function World:findAndRemoveFirstUnit(list, x, y)
	local it = list.head
	
	while it ~= nil do
		if it.data:isPointInside(x, y) then
			list:deleteNode(it)
			return true
		end
		it = it.next
	end
	
	return false
end

-- @x @y are virtual coordinates!
function World:removeUnit(x, y)
	return self:findAndRemoveFirstUnit(self.activeUnits, x, y) or
		self:findAndRemoveFirstUnit(self.waitingUnits, x, y)
end

-- @x, @y are tile coordinates!
-- @position = background, foreground
function World:removeAnimationObject(x, y, position)
	return self:removeObjectFromGrid(x, y, position .. "Obj") ~= nil
end

-- @x, @y are tile coordinates!
function World:removeActiveObject(x, y)
	local obj = self:removeObjectFromGrid(x, y, "activeObj")
	
	if obj then
		-- Find it and remove from activeObjects list
		local it = self.activeObjects.head
		
		while it ~= nil do
			if it.data == obj then
				self.activeObjects:deleteNode(it)
				break
			end
			it = it.next
		end
		
		return true
	end
	
	return false
end

-- Connect two teleports if possible
-- @t1X, @t1Y, @t2X, @t2Y are tile coordinates!
function World:connectTeleports(t1X, t1Y, t2X, t2Y)
	if self:isInsideGrid(t1X, t1Y) and self:isInsideGrid(t2X, t2Y) then
		local t1 = self.tiles[t1X][t1Y].activeObj
		local t2 = self.tiles[t2X][t2Y].activeObj
		
		if t1.name == "teleport" and t2.name == "teleport" then
			t1:setTwin(t2)
			t2:setTwin(t1)
			
			return true
		end
	end
	
	return false
end

-- Add new unit to the waiting list so that it won't break
-- the ascending order according their positions
function World:addUnit(unit)
	local it = self.waitingUnits.head
	
	if it == nil then
		-- List is empty
		self.waitingUnits:pushFront(unit)
	else	
		-- You have to find appropriate spot
		while it ~= nil do
			if unit.x+unit.width/2 < it.data.x-it.data.width/2 then
				-- Add it here
				self.waitingUnits:addBefore(it, unit)
				break
			end
			
			it = it.next
		end
	end
	
	self:setupNewActiveUnits()
end

--[[
-- Sort waiting unit's by their horizontal position
-- (From the nearest to the farest)
function World:sortWaitingUnits()
	-- Simple bubblesort O(N^2) cause there will never be 
	-- thousands of units and it's still fast enough to
	-- sort it quickly while loading
	local it1 = self.waitingUnits.head
	local change = false
	
	while it1 ~= nil do
		local it2 = it1.next
		
		while it2 ~= nil do
			if it1.data.x-it1.data.width/2 > it2.data.x-it2.data.width/2 then
				-- Swap data
				it1.data, it2.data = it2.data, it1.data
				-- Change was made
				change = true
			end
			it2 = it2.next
		end
		
		if change == false then
			break
		end
		
		change = false
		it1 = it1.next
	end
end
]]

-- Fill a new object into the grid.
-- @objectPropertyName = collidableTile, foregroundObj,
-- 							backgroundObj, activeObj
function World:fillObjectIntoGrid(obj, objectPropertyName)
	local width = obj.width - 1
	local height = obj.height - 1
	
	if self:isInsideGrid(obj.x, obj.y) and 
		self:isInsideGrid(obj.x+width, obj.y+height) and
		self:isInsideGrid(obj.x+width, obj.y) and 
		self:isInsideGrid(obj.x, obj.y+height) then
		
		-- You can place it right here
		for x = obj.x, obj.x+width do
			for y = obj.y, obj.y+height do
				self.tiles[x][y][objectPropertyName] = obj
			end
		end
		
		return true
	end
	
	return false
end

-- Remove object at given tile coordinates
-- @objectPropertyName = collidableTile, foregroundObj,
--                         backgroundObj, activeObj
function World:removeObjectFromGrid(x, y, objectPropertyName)
	if self:isInsideGrid(x, y) then
		local obj = self.tiles[x][y][objectPropertyName]

		if obj then
			for x = obj.x, obj.x+obj.width-1 do
				for y = obj.y, obj.y+obj.height-1 do
					self.tiles[x][y][objectPropertyName] = nil
				end
			end
			
			return obj
		end
	end
	
	return nil
end

-- @x, @y = tile coordinates
function World:deleteCollidableTile(x, y)
	self.tiles[x][y].collidableTile = nil
end

-- @x, @y = tile's position
function World:getCoinGenerator(x, y)
	return self.coinGenerators[x * self.numTilesWidth + y]
end

-- @x, @y = tile's position
function World:setCoinGenerator(x, y, generator)
	self.coinGenerators[x * self.numTilesWidth + y] = generator
end

-- Swap collidable tile after "generation"
-- It means that this tile has "ran out of"
-- coins, mushrooms etc... so change it to the static block
-- or if there isn't any set, then make the tile disappears.
-- @x, @y = tile coordinates
function World:swapCollidableTileAfterGeneration(x, y)
	local name = self.tiles[x][y].collidableTile.staticBlockName
	
	if name == nil then
		self:deleteCollidableTile(x, y) -- dissappear
	else
		self.tiles[x][y] = Tile:new(self.headerContainer:getHeader(name))
	end
end

-- Create coin effect (coin moves upwards from tile and then fadeouts)
-- @x, @y = tile's coordinates
function World:createCoinEffect(x, y)
	local realX = x * self.tileWidth + self.tileWidth/2
	local realY = y * self.tileHeight + self.tileHeight/2
	local anim = self.textureContainer:getAnimation("coin")
	
	self.bParticleSystem:addCoinEffect(anim:getActiveTexture(), realX, realY,
		self.tileWidth, self.tileHeight, CointParticleUpdate, anim)
end

-- @x, @y = tile's coordinates
function World:resolveBounceSingleCoinGenerator(x, y)
	self:createCoinEffect(x, y)
	self:swapCollidableTileAfterGeneration(x, y)
	
	if self.player then
		self.player:increaseNumCoins()
	end
end

-- @x, @y = tile's coordinates
function World:resolveBounceCoinsGenerator(x, y)
	local tile = self.tiles[x][y]
	
	-- Was it used before?
	local generator = self:getCoinGenerator(x, y)
	
	if generator then
		if generator:shouldBeDestroyed() then
			self:setCoinGenerator(x, y, nil)
			self:swapCollidableTileAfterGeneration(x, y)
		else
			generator:extractCoin()
		end
	else
		-- Generator has not been created yet... 
		-- create new one and setup coin generation
		self:setCoinGenerator(x, y, CoinGenerator:new():extractCoin())
	end
	
	self:createCoinEffect(x, y)
	
	if self.player then
		self.player:increaseNumCoins()
	end
end

-- @x, @y = tile's coordinates
function World:resolveBounceBoostGenerator(x, y)
	local cx = x * self.tileWidth + self.tileWidth/2
	local cy = y * self.tileHeight + self.tileHeight/2
	local dirLeft = self.player.x - cx < 0
	local boost = nil
	
	if isTileBoostGenerator(self.tiles[x][y]) then
		-- Retrieve the generator name
		local name = self.tiles[x][y].collidableTile.generatorType
		local from, to = string.find(name, "boost_")
		name = string.sub(name, to + 1)
		
		boost = createUnitFromName(name, cx, cy,
			self.tileWidth, self.tileHeight,
			self.textureContainer, dirLeft)
	end
	
	if boost == nil then
		return -- Boost is unknown
	end
	
	local gen = BoostGenerator:new(
		x * self.tileWidth + self.tileWidth/2,
		y * self.tileHeight + self.tileHeight/2, 
		self.tileWidth, self.tileHeight, boost)
	
	self.boostGenerators:pushBack(gen)
	-- Do not forget to add the boost unit to the active units
	self.activeUnits:pushBack(boost)
	self:swapCollidableTileAfterGeneration(x, y)
end

-- @x, y = world's real coordination of tile's top-left position
function World:killUnfriendlyUnitsOnTilePosition(x, y)
	local it = self.activeUnits.head
	
	while it do
		if it.data.friendlyToPlayer == false and 
			lineIntersect(x, self.tileWidth, 
			it.data.x - it.data.width/2, it.data.width) 
			and math.abs(it.data.y + it.data.height/2 - y)
				< self.tileHeight/5 then
			-- Kill it
			it.data:instantDeath(self.fParticleSystem)
		end
		
		it = it.next
	end
end

-- @x, @y = tile's coordinates
function World:bounceTile(x, y)
	local tile = self.tiles[x][y]
	
	-- Lets assume that this tile is valid and bouncable
	if tile.isBouncing == false then
		-- Let's find out if this tile can generate coin(s)
		if isTileSingleCoinGenerator(tile) then
			self:resolveBounceSingleCoinGenerator(x, y)
		elseif isTileCoinsGenerator(tile) then
			self:resolveBounceCoinsGenerator(x, y)
		elseif isTileBoostGenerator(tile) then
			self:resolveBounceBoostGenerator(x, y)
		end
		
		-- The tile may have been deleted
		tile = self.tiles[x][y]
		
		if tile then
			tile.isBouncing = true
			self.bouncingTilesContainer:addTile(tile)
			self:killUnfriendlyUnitsOnTilePosition(
				x * self.tileWidth,
				y * self.tileHeight)
		end
	end
end

-- @x, @y = tile's coordinates
function World:breakTile(x, y)
	local particleQ = 2
	local tile = self.tiles[x][y]
	
	-- first particle
	self.fParticleSystem:addBrokenWallEffect(
		tile.collidableTile.animation:getActiveTexture(), 
		x * self.tileWidth, y * self.tileHeight, 
		self.tileWidth/particleQ, self.tileHeight/particleQ, true)
	
	-- second particle
	self.fParticleSystem:addBrokenWallEffect(
		tile.collidableTile.animation:getActiveTexture(), 
		(x+1) * self.tileWidth, y * self.tileHeight, 
		self.tileWidth/particleQ, self.tileHeight/particleQ, false)
	
	-- delete the tile from grid
	self:deleteCollidableTile(x, y)
end

-- Reveal all tiles marked as secret in one connected tile-area
-- @x, @y = secret tile's coordinates
function World:revealSecretTilesInArea(x, y)
	if self:isInsideGrid(x, y) and isTileSecret(self.tiles[x][y]) then
		-- To make a smooth fade out effect, you have to place
		-- each tile into the particle system
		local tex = self.tiles[x][y]
			.collidableTile.animation:getActiveTexture()
		
		local realX = x * self.tileWidth + self.tileWidth/2
		local realY = y * self.tileHeight + self.tileHeight/2
		
		self.fParticleSystem:addTileFadeOutEffect(tex, realX, realY,
			self.tileWidth, self.tileHeight)
		
		-- Do not forget to delete it!
		self:deleteCollidableTile(x, y)
		
		-- In all four directions
		self:revealSecretTilesInArea(x-1, y)
		self:revealSecretTilesInArea(x+1, y)
		self:revealSecretTilesInArea(x, y-1)
		self:revealSecretTilesInArea(x, y+1)
	end
end

-- Check, if tile's position is inside grid
function World:isInsideGrid(x, y)
	return x >= 0 and x < self.numTilesWidth 
		and y >= 0 and y < self.numTilesHeight
end

-- Check, if tile's position is inside grid
-- and return the corrected one if possible
function World:boundToGrid(x, y)
	return setWithinRange(x, 0, self.numTilesWidth-1),
		setWithinRange(y, 0, self.numTilesHeight-1)
end

-- Count rectangle-tile distance from oblique tile
-- @x, y = position of the object
-- @width, height = proportions of the object
function World:countDistanceFromObliqueTile(x, y, width, height, tileX, tileY)
	local countHeight
	
	if self.tiles[tileX][tileY].collidableTile.oblique == -1 then
		-- Oblique left
		countHeight = self.countHeightOnLeftObliqueTile
	else
		-- Oblique right
		countHeight = self.countHeightOnRightObliqueTile
	end
	
	return countHeight(self, x, y, width, height, tileX, tileY)
end

-- Count rectangle's vertical position (distance from the oblique ground)
-- Possible only if the rectangle is standing on left-sided oblique tile.
function World:countHeightOnLeftObliqueTile(x, y, width, height, tileX, tileY)
	-- Tile is valid and also a left-sided oblique tile
	local newX = x + width/2
	local newY = y + height/2
	local offset = math.fmod(newX, self.tileWidth) / self.tileWidth
	
	-- Not directly on the tile? Maximize the distance
	if math.floor(newX / self.tileWidth) > tileX then
		offset = 1
	end
	
 	return (tileY+1) * self.tileHeight - offset * self.tileHeight - newY
end

-- Count rectangle's vertical position (distance from the oblique ground)
-- Possible only if the rectangle is standing on right-sided oblique tile.
function World:countHeightOnRightObliqueTile(x, y, width, height, tileX, tileY)
	-- Tile is valid and also a right-sided oblique tile
	local newX = x - width/2
	local newY = y + height/2
	local offset = math.fmod(newX, self.tileWidth) / self.tileWidth
	
	-- Not directly on the tile? Maximize the distance
	if math.floor(newX / self.tileWidth) < tileX then
		offset = 0
	end
	
 	return (tileY+1) * self.tileHeight - (1-offset) * self.tileHeight - newY
end

-- Unit-tile collision detection in UP direction
function World:handleUnitCollisionUp(unit, deltaTime, distError)
	local dist = unit:getVerticalDist(deltaTime)
	
	-- boundaries
	local leftX, leftTileX = unit:getLeftBoundary(self.tileWidth)
	local rightX, rightTileX = unit:getRightBoundary(self.tileWidth, distError)
	
	-- position before movement
	local topY = unit.y - unit.height/2
	-- position after movement
	local tileYAfter = math.floor((topY - dist) / self.tileHeight)
	
	-- Check tiles after movement and find collisions
	for x = leftTileX, rightTileX do
		-- Reveal secret tiles first, so you can continue in moving
		self:revealSecretTilesInArea(x, tileYAfter)
		
		if self:isInsideGrid(x, tileYAfter) then
			local tile = self.tiles[x][tileYAfter]
			
			if isTileCollidable(tile) and isTilePlatform(tile) == false then
				if isTileDeadly(tile) then
					unit:hurt("deadly", self.fParticleSystem)
					return
				end
				
				-- Check, if the tile is bouncable or breakable
				-- And if player is allowed to break 'em
				if isTileBreakable(tile) and unit:canBreakTiles() then
					self:breakTile(x, tileYAfter)
				elseif isTileBouncable(tile) and unit:canBounceTiles() then
					self:bounceTile(x, tileYAfter)
				end
				
				-- Update distance from the tile
				-- (may be lower than the wanted distance)
				local dist2 = topY - (tileYAfter+1) * self.tileHeight
				
				if dist2 < dist then
					dist = dist2
				end
				
				unit:stopJumping()
			end
		end
	end
	
	unit:moveSpecific(0, -dist)
end

-- Unit-tile collision detection in DOWN direction
function World:handleUnitCollisionDown(unit, deltaTime, distError)
	local dist = unit:getVerticalDist(deltaTime)
	local distObliqueTile = dist
	
	-- boundaries
	local leftX, leftTileX = unit:getLeftBoundary(self.tileWidth)
	local rightX, rightTileX = unit:getRightBoundary(self.tileWidth, distError)
	
	-- position before movement
	local botY = unit.y + unit.height/2
	-- position after movement
	local tileYAfter = math.floor((botY + dist) / self.tileHeight)
	
	local nonObliqueTileFound = false
	
	-- Check tiles after movement and find collisions
	for x = leftTileX, rightTileX do
		-- Reveal secret tiles first, so you can continue in moving
		self:revealSecretTilesInArea(x, tileYAfter)
		
		if self:isInsideGrid(x, tileYAfter) then
			local tile = self.tiles[x][tileYAfter]
			
			if isTileCollidable(tile) then
				if isTileDeadly(tile) then
					unit:hurt("deadly", self.fParticleSystem)
					return
				end
				
				-- Oblique beneath?
				if isTileOblique(self.tiles[x][tileYAfter]) ~= 0 then
					local dist2 = self:countDistanceFromObliqueTile(
						unit.x, unit.y, unit.width, unit.height, x, tileYAfter)
					
					if dist2 < distObliqueTile then
						distObliqueTile = dist2	
					end
				else
					-- Platform beneath?
					if isTilePlatform(tile) and
						unit.jumpOffPlatformTimer > 0 then
						
						nonObliqueTileFound = true
						unit:startFalling()
					elseif isTilePlatform(tile) and
						math.floor(botY / self.tileHeight) == tileYAfter and
						botY > 1 then
						-- continue
					else
						dist = tileYAfter * self.tileHeight - botY
						nonObliqueTileFound = true
						unit:stopFalling()
						break
					end
				end
			end
		end
	end
	
	if nonObliqueTileFound == false and distObliqueTile < dist then
		unit:stopFalling()
		dist = distObliqueTile
	end
	
	unit:moveSpecific(0, dist)
end

-- Check, if beneath the unit is solid ground
-- If there is not, let the unit start falling
function World:findSolidGround(unit, deltaTime, distError)
	local leftX, leftTileX = unit:getLeftBoundary(self.tileWidth)
	local rightX, rightTileX = unit:getRightBoundary(self.tileWidth, 0.1)
	
	local tileY = math.floor((unit.y + unit.height/2) / self.tileHeight)
	
	local solidGround = false
	local obliqueTileFound = false
	
	for x = leftTileX, rightTileX do
		if self:isInsideGrid(x, tileY) then
			if isTileCollidable(self.tiles[x][tileY]) then
				-- We have might have solid ground beneath us, just
				-- check if is not oblique.
				if isTileOblique(self.tiles[x][tileY]) ~= 0 then
					obliqueTileFound = true
					
					if self:countDistanceFromObliqueTile(unit.x, unit.y, 
						unit.width, unit.height, x, tileY) < distError/2 then
						solidGround = true
						break
					end
				else
					solidGround = true
					break
				end
			elseif hasTileActiveObject(self.tiles[x][tileY]) then
				-- Unit collision is implemented, 
				-- better to leave the handling to it
				if self.tiles[x][tileY].activeObj.handleUnitCollision then
					solidGround = true
					break
				end
			end
		end
	end
	
	if solidGround == false then
		unit:startFalling()
		-- You want to "keep the unit on the ground" 
		-- if the unit is walking on the oblique tile.
		if obliqueTileFound then
			unit.verticalVel = unit.jumpingVelBase * 0.5
			self:handleUnitCollisionDown(unit, deltaTime, distError)
		end
	end
end

-- Unit-tile collision in LEFT direction
function World:handleUnitCollisionLeft(unit, deltaTime, distError)
	local distHor = unit:getHorizontalDist(deltaTime)
	local distVer = 0
	
	-- boundaries
	local topY, topTileY = unit:getTopBoundary(self.tileHeight)
	local botY, botTileY = unit:getBotBoundary(self.tileHeight, 2*distError)
	
	-- position before movement
	local leftX = unit.x - unit.width/2
	-- position after movement
	local leftXAfter = leftX - distHor
	local tileXAfter = math.floor(leftXAfter / self.tileWidth)
	
	-- Out of map?
	if leftXAfter < 0 then
		unit:moveSpecific(-leftX, 0)
		unit.collidedHorizontally = "left"
		return
	end
	
	-- Check the tiles after movement and find collisions
	for y = topTileY, botTileY do
		-- Reveal secret tiles first, so you can continue in moving
		self:revealSecretTilesInArea(tileXAfter, y)
		
		if self:isInsideGrid(tileXAfter, y) then
			local tile = self.tiles[tileXAfter][y]
			
			if isTileCollidable(tile) then
				if isTileDeadly(tile) then
					unit:hurt("deadly", self.fParticleSystem)
					return
				elseif y == botTileY and isTileOblique(tile) == 1 then
					-- There is right-sided oblique tile
					distVer = self:countHeightOnRightObliqueTile(unit.x, unit.y,
						unit.width, unit.height, tileXAfter, y)
					
					if distVer > distHor then
						distVer = distHor
					end
					break
				elseif isTilePlatform(tile) == false then
					unit.collidedHorizontally = "left"
					distHor = leftX - (tileXAfter+1) * self.tileWidth
					break
				end
			end
		end
	end
	
	distHor, distVer = self:leftRightVelLimit(unit, deltaTime, distHor, distVer)
	unit:moveSpecific(-distHor, distVer)
end

-- Unit-tile collision in RIGHT direction
function World:handleUnitCollisionRight(unit, deltaTime, distError)
	local distHor = unit:getHorizontalDist(deltaTime)
	local distVer = 0
	
	-- boundaries
	local topY, topTileY = unit:getTopBoundary(self.tileHeight)
	local botY, botTileY = unit:getBotBoundary(self.tileHeight, 2*distError)
	
	-- position before movement
	local rightX = unit.x + unit.width/2
	-- position after movement
	local rightXAfter = rightX + distHor
	local tileXAfter = math.floor(rightXAfter / self.tileWidth)
	
	-- Out of map?
	if rightXAfter > self.camera.mapWidth then
		unit:moveSpecific(self.camera.mapWidth - rightX, 0)
		unit.collidedHorizontally = "right"
		return
	end
	
	for y = topTileY, botTileY do
		-- Reveal secret tiles first, so you can continue in moving
		self:revealSecretTilesInArea(tileXAfter, y)
		
		if self:isInsideGrid(tileXAfter, y) then
			local tile = self.tiles[tileXAfter][y]
			
			if isTileCollidable(tile) then
				if isTileDeadly(tile) then
					unit:hurt("deadly", self.fParticleSystem)
					return
				elseif y == botTileY and isTileOblique(tile) == -1 then
					-- There is left-sided oblique tile
					distVer = self:countHeightOnLeftObliqueTile(unit.x, unit.y,
						unit.width, unit.height, tileXAfter, y)
					
					if distVer > distHor then
						distVer = distHor
					end
					break
				elseif isTilePlatform(tile) == false then
					-- Tell the unit that collision has happened
					unit.collidedHorizontally = "right"
					distHor = tileXAfter * self.tileWidth - rightX
					break
				end
			end
		end
	end
	
	distHor, distVer = self:leftRightVelLimit(unit, deltaTime, distHor, distVer)
	unit:moveSpecific(distHor, distVer)
end

local HorDistLimitQ = 1.5

function World:leftRightVelLimit(unit, deltaTime, distHor, distVer)
	local distHorLimit = unit:getHorizontalDist(deltaTime)
	
	if math.abs(distHor) > distHorLimit then
		distHor = distHorLimit
	end
	
	-- Vertical (up) distance cannot be higher than horizontal!
	if distVer < -distHorLimit * HorDistLimitQ then
		distVer = -distHorLimit * HorDistLimitQ
	end
	
	return distHor, distVer
end

function World:getUnitGridIndices(unit)
	local distError = 0.1
	
	local startX = math.floor((unit.x - unit.width/2) / self.tileWidth)
	local startY = math.floor((unit.y - unit.height/2) / self.tileHeight)
	local endX = math.floor((unit.x + unit.width/2 - distError) / self.tileWidth)
	local endY = math.floor((unit.y + unit.height/2 - distError) / self.tileHeight)
	
	startX, startY = self:boundToGrid(startX, startY)
	endX, endY = self:boundToGrid(endX, endY)
	
	return startX, startY, endX, endY
end

function World:handleUnitWaterCollision(unit)
	local distError = 0.1
	local waterPresent = false
	
	local startX, startY, endX, endY = self:getUnitGridIndices(unit)
	
	for x = startX, endX do
		for y = startY, endY do
			-- "Top" water is not counting as a proper water obstacle...
			if isWaterOnTile(self.tiles[x][y]) and 
				self.tiles[x][y].waterTile.name ~= "water_top" then
				waterPresent = true
				break
			end
		end
	end
	
	if waterPresent ~= unit.insideWater then
		-- TODO splash sound
		unit.insideWater = waterPresent
	end
end

-- Handle unit - active object (trampoline, teleport) collision
-- Attach the units to the objects if possible
function World:handleUnitActiveObjectCollision(unit, deltaTime)
	local startX, startY, endX, endY = self:getUnitGridIndices(unit)
	local tile
	
	for x = startX, endX do
		for y = startY, endY do
			tile = self.tiles[x][y]
			
			if hasTileActiveObject(tile) and 
				tile.activeObj:isAlreadyBounded(unit) == false then
				
				if tile.activeObj:canBeBounded(unit, deltaTime) then
					-- Bound this unit to the object
					tile.activeObj:boundUnit(unit)
				elseif tile.activeObj.handleUnitCollision ~= nil then
					-- Unit cannot be bounded, then handle collision
					tile.activeObj:handleUnitCollision(unit, deltaTime)
				end
			end
		end
	end
end

-- Handle unit-tile collisions in all directions
function World:handleUnitTileCollisions(unit, deltaTime)
	local distError = 6
	
	-- Horizontal movement
	if unit.isMovingHor then
		if unit.isFacingLeft then
			self:handleUnitCollisionLeft(unit, deltaTime, distError)
		else
			self:handleUnitCollisionRight(unit, deltaTime, distError)
		end
	end
	
	-- Vertical movement
	if unit.isJumping then
		self:handleUnitCollisionUp(unit, deltaTime, distError)
	elseif unit.isFalling or unit.jumpOffPlatformTimer > 0 then
		self:handleUnitCollisionDown(unit, deltaTime, distError)
	else
		self:findSolidGround(unit, deltaTime, distError)
	end
end

-- Handle unit-unit collisions in all directions
function World:handleUnitUnitCollisions(unit, deltaTime)
	-- Iterate through all next units (bad-guys and player)
	-- and check their collisions
	local it = self.activeUnits.head
	
	while it ~= nil do
		local unit2 = it.data
		
		-- Unit cannot collide with itself
		if unit ~= unit2 and unit2.dead == false
			and unit2.movementAndCollisionDisabled == false
			and unit:doesCollideWithUnit(unit2) then
			unit:resolveUnitCollision(unit2, self.fParticleSystem, deltaTime)
		end
		
		it = it.next
	end
end

-- This unit wants to fire a new projectile
function World:addProjectileCreatedByUnit(unit)
	local name, x, y, size, dirLeft, isGood = unit:getCreatedProjectile()
	
	if name == nil then
		return -- Is not valid
	end
	
	self.projectiles:pushBack(Projectile:new(name, x, y, size, dirLeft, isGood,
		self.textureContainer:getAnimation(name)))
end

function World:createBubblesNearUnit(unit, deltaTime)
	if math.random() < deltaTime then
		-- Is it possible to create a bubble?
		self.fParticleSystem:addBubbleParticle(
			self.textureContainer:getTexture("bubble"),
			unit.x, unit.y, 16, 16, 0.6)
	end
end

function World:handleUnitAllSolidCollisions(unit, deltaTime)
	-- Unit-tile collisions
	self:handleUnitTileCollisions(unit, deltaTime)
	
	-- Unit-active object collisions and interactions
	self:handleUnitActiveObjectCollision(unit, deltaTime)

	-- Unit-unit collisions
	self:handleUnitUnitCollisions(unit, deltaTime)
	
	if unit:isInsideDownWorld(self.camera) == false then
		unit:instantDeath(self.fParticleSystem)
	end
end

function World:specialUpdateUnit(unit, deltaTime)
	if unit.name == "rotating_ghost" then
		unit:updateRotatingMovement(deltaTime, self.sinCosTable)
	elseif unit.name == "hammerman" then
		unit:updateAccordingToPlayer(deltaTime, 
			self.player, self.camera)
	elseif unit.name == "rocket" and unit.started then
		-- Because rocket is only triggered when player is in it
		-- So then if the rocket is far enough try to end this current world
		local bot = unit:getBotBoundary(self.tileHeight, 0)
		
		if bot < unit.rocketMinY then
			self:tryToEnd()
		end
	end
end
	
function World:updateActiveUnit(unit, deltaTime)
	unit:updateFreezeTimer(deltaTime)
			
	if unit:isFreezed() == false then
		unit:updateAnimations(deltaTime)
		
		unit:update(deltaTime, WorldGravity, 
			self.fParticleSystem, self.camera)
		
		if unit.dead == false then		
			self:specialUpdateUnit(unit, deltaTime)
			self:addProjectileCreatedByUnit(unit)
			
			if unit.movementAndCollisionDisabled == false then
				self:handleUnitWaterCollision(unit)
				
				if unit.insideWater and unit.isJumping == false then
					self:createBubblesNearUnit(unit, deltaTime)
				end
				
				self:handleUnitAllSolidCollisions(unit, deltaTime)
			end
		end
	end
end

function World:updateActiveUnits(deltaTime)
	local it = self.activeUnits.head
	local itTmp
	
	while it ~= nil do
		self:updateActiveUnit(it.data, deltaTime)
		
		itTmp = it.next
		if it.data:canBeRemoved() then
			self.activeUnits:deleteNode(it)
		end
		it = itTmp
	end
end

-- Iterate through inactive (waiting) units
-- and decide, if the unit can be activated
-- Remember, the list is in ascending order according to their positions
function World:setupNewActiveUnits()
	local it = self.waitingUnits.head
	local itTmp
	
	while it ~= nil and it.data:isInsideCamera(self.camera) do
		-- Activate
		self.activeUnits:pushBack(it.data)
		-- Remove it from the list
		itTmp = it.next
		self.waitingUnits:deleteNode(it)
		it = itTmp
	end
end

function World:handleProjectileBadGuysCollisions(projectile)
	if self.activeUnits.head == nil then
		return
	end
	
	-- Skip the first unit - it's the player
	local it = self.activeUnits.head.next
	
	while it do
		if it.data.dead == false then
			it.data:resolveProjectileCollision(projectile,
				self.fParticleSystem, 
				self.textureContainer:getTexture("freezed_unit"))
		end
		
		it = it.next
	end
end

function World:handleProjectilePlayerCollisions(projectile)
	if self.player == nil or self.player.dead then
		return
	end
	
	self.player:resolveProjectileCollision(projectile, self.fParticleSystem,
		self.textureContainer:getTexture("freezed_unit"))
end

function World:handleProjectileTileCollisions(projectile, deltaTime)
	local x, y = projectile.x, projectile.y
	local dx = projectile:getHorizontalDist(deltaTime)
	local dy = projectile:getVerticalDist(deltaTime)
	
	local tileXBefore = math.floor(x / self.tileWidth)
	local tileYBefore = math.floor(y / self.tileHeight)
	
	x = x + dx
	y = y + dy
	
	local tileXAfter = math.floor(x / self.tileWidth)
	local tileYAfter = math.floor(y / self.tileHeight)
	
	-- Reset velocity reduction 'cause you do not know
	-- if any collision with this projectile would happen
	projectile:setVelocityReduction(1)
	
	if self:isInsideGrid(tileXAfter, tileYAfter) then
		local tile = self.tiles[tileXAfter][tileYAfter]
		
		if hasTileActiveObject(tile) then
			if tile.activeObj:checkPointCollision(x, y) then
				-- They have collided
				projectile:reverseHorizontalDir()
				projectile:reverseVerticalDir()
				dx, dy = -dx, -dy
			end
		elseif isTileDeadly(tile) then
			-- Delete this projectile
			projectile:fadeOut()
		elseif isTileCollidable(tile) and isTilePlatform(tile) == false then
			local skipReversing = false
			
			if isTileOblique(tile) ~= 0 then
				-- There was found and oblique tile, count the collision
				-- differently
				local dist = self:countDistanceFromObliqueTile(x, y,
					0, 0, tileXAfter, tileYAfter)
					
				if dist < math.sqrt(dx*dx + dy*dy) then
					projectile:reverseHorizontalDir()
					projectile:reverseVerticalDir()
					dx, dy = -dx, -dy
				end
				
				skipReversing = true
			end
			
			if skipReversing  == false then
				if tileXAfter ~= tileXBefore then
					projectile:reverseHorizontalDir()
					dx = 0
				end
				
				if tileYAfter ~= tileYBefore then
					projectile:reverseVerticalDir()
					dy = 0
				end
			end
			
		elseif isWaterOnTile(tile) then
			-- The projectile moves slower in water
			projectile:setVelocityReduction(2.5)
		end
	end
	
	projectile:moveSpecific(dx, dy)
end

function World:updateProjectiles(deltaTime)
	local it = self.projectiles.head
	local data, itTmp
	
	while it do
		data = it.data
		
		if data:tileCollisionEnabled() then
			-- Handle projectile - tile collisions
			self:handleProjectileTileCollisions(data, deltaTime)
		else
			-- You can move without being worried
			data:moveSpecific(data:getHorizontalDist(deltaTime),
				data:getVerticalDist(deltaTime))
		end
		
		if data.fading == false then		
			if data.isGood then
				-- Projectile fired by player
				self:handleProjectileBadGuysCollisions(data)
			else
				-- Projectile fired by bad guys
				self:handleProjectilePlayerCollisions(data)
			end
			
			if data:isInsideWorld(self.camera) == false then
				-- Not inside the world? Then prepare to be deleted...
				data:fadeOut()
			end
		end
		
		data:update(deltaTime, WorldGravity)
		
		itTmp = it.next
		if data:canBeRemoved() then
			self.projectiles:deleteNode(it)
		end
		it = itTmp
	end
end

-- Update active objects
-- Remember to call this function every update frame 
-- no matter of object visibility
function World:updateActiveObjects(deltaTime)
	local it = self.activeObjects.head
	
	while it do
		it.data:update(self.camera, self.fParticleSystem, deltaTime)
		
		-- Canon update only!
		-- Check whether you should spawn a new canonball
		if it.data.name == "canon" then
			local x, y = it.data:spawnNewCanonBall()
			
			if x and y then
				self.activeUnits:pushBack(createUnitFromName("canonball",
					x, y, self.tileWidth, self.tileHeight,
					self.textureContainer, it.data.leftDir))
			end
		end
		
		it = it.next
	end
end

-- Activate active object where the unit is standing
function World:activateActiveObject(unit)
	local startX, startY, endX, endY = self:getUnitGridIndices(unit)
	
	for x = startX, endX do
		for y = startY, endY do
			-- Take the first object that has been succesfully activated
			if hasTileActiveObject(self.tiles[x][y]) then
				if self.tiles[x][y].activeObj:activate() then
					return true
				end
			end
		end
	end
	
	return false
end

function World:updateCoinGenerators(deltaTime)
	for key, gen in pairs(self.coinGenerators) do
		gen:update(deltaTime)
	end
end

function World:updateBoostGenerators(deltaTime)
	local it = self.boostGenerators.head
	local it2
	
	while it ~= nil do
		it.data:update(deltaTime)
		
		it2 = it.next
		if it.data:shouldBeDestroyed() then
			self.boostGenerators:deleteNode(it)
		end
		it = it2
	end
end

function World:tryToEnd()
	self.shouldEnd = true
end

function World:updateFinish(deltaTime)
	self.player:moveHorizontally(false)
	self.finishCountdownTimer = self.finishCountdownTimer - deltaTime

	if self.finishCountdownTimer <= 0 then
		self:tryToEnd()
	end
end

function World:checkPlayerFinishLine()
	if self.player.x >= self.playerFinishLine 
		and self.playerFinished == false then
		-- You've passed!
		self.playerFinished = true
		self.finishCountdownTimer = 3
		
		-- Make sure nobody kills him. Even the lava!
		self.player:setTotallyInvulnerable(100)
		self.player.isControllable = false
	end
end

-- Count and return coordinates of clip - area of tiles which should
-- be drawn onto the screen
function World:getDrawingClipCoords()
	local startX = math.floor(self.camera.x / self.tileWidth)
	local startY = math.floor(self.camera.y / self.tileHeight)
	local endX = math.floor((self.camera.x+self.camera.virtualWidth) /
		self.tileWidth)
	local endY = math.floor((self.camera.y+self.camera.virtualHeight) /
		self.tileHeight)
	
	-- Out of map? 
	endX, endY = self:boundToGrid(endX, endY)
	
	return startX, startY, endX, endY
end

function World:update(deltaTime)
	if self.player ~= nil and self.player.dead == false then
		self.camera:centerAt(self.player.x, self.player.y)
		self:checkPlayerFinishLine()
	end
	
	if self.playerFinished then
		self:updateFinish(deltaTime)
		-- Make everything slower
		-- "Finish" effect :-D
		deltaTime = deltaTime / 4
	end
	
	self.headerContainer:updateTileHeaders(deltaTime)
	
	self:updateProjectiles(deltaTime)
	
	-- Units
	self:setupNewActiveUnits()
	self:updateActiveUnits(deltaTime)
	
	-- active objects
	self.animObjContainer:updateAnimObjects(deltaTime)
	self:updateActiveObjects(deltaTime)
	
	-- parallax background
	self.parallaxBackground:update(self.camera, deltaTime, 
		self.sinCosTable, false)
	
	-- bouncing tiles
	self.bouncingTilesContainer:update(deltaTime)
	
	-- in-game particle systems
	self.fParticleSystem:update(self.camera, deltaTime, self.sinCosTable, nil)
	self.bParticleSystem:update(self.camera, deltaTime, self.sinCosTable, nil)
	
	-- generators
	self:updateCoinGenerators(deltaTime)
	self:updateBoostGenerators(deltaTime)
end

local WorldSpawnColor = { r = 255, g = 100, b = 100 }

function World:drawPlayersSpawnPosition()
	love.graphics.translate(-self.camera.x, -self.camera.y)
	
	-- Border
	love.graphics.setLineWidth(3)
	drawRectC("line", self.playerSpawnX - self.tileWidth/2,
		self.playerSpawnY - self.tileHeight/2,
		self.tileWidth, self.tileHeight, WorldSpawnColor)
	love.graphics.setLineWidth(1)
	
	-- Text
	love.graphics.setColor(WorldSpawnColor.r,
		WorldSpawnColor.g, WorldSpawnColor.b)
	self.fonts.big:drawLineCentered("SP", 
		self.playerSpawnX, self.playerSpawnY)
	love.graphics.setColor(255, 255, 255)
	
	love.graphics.translate(self.camera.x, self.camera.y)
end

local WorldFinishLineColor = { r = 100, g = 100, b = 255 }

function World:drawPlayersFinishLine()
	love.graphics.push()
	love.graphics.translate(-self.camera.x, 0)
	
	-- Border
	love.graphics.setLineWidth(3)
	drawRectC("line", self.playerFinishLine - self.tileWidth/2,
		0, self.tileWidth, self.camera.virtualHeight, WorldFinishLineColor)
	love.graphics.setLineWidth(1)
	
	-- Text
	love.graphics.push()
	love.graphics.translate(0, self.tileHeight/2 - math.fmod(self.camera.y, self.tileHeight))
	
	love.graphics.setColor(WorldFinishLineColor.r,
		WorldFinishLineColor.g, WorldFinishLineColor.b)
	
	for y = 0, math.floor(self.camera.virtualHeight / self.tileHeight) do
		self.fonts.big:drawLineCentered("FL", self.playerFinishLine,
			y * self.tileWidth)
	end
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.pop()
	
	love.graphics.pop()
end

-- Draw tile's boundaries in grid
function World:drawGridLines()
	-- Green
	love.graphics.setColor(0, 255, 0)
	
	local camOffsetX = -math.fmod(self.camera.x, self.tileWidth)
	local camOffsetY = -math.fmod(self.camera.y, self.tileHeight)
	
	-- Draw vertical lines
	while camOffsetX <= self.camera.virtualWidth do
		love.graphics.line(camOffsetX, 0, camOffsetX, 
			self.camera.virtualHeight)
		camOffsetX = camOffsetX + self.tileWidth
	end
	
	-- Draw horizontal lines
	while camOffsetY <= self.camera.virtualHeight do
		love.graphics.line(0, camOffsetY, 
			self.camera.virtualWidth, camOffsetY)
		camOffsetY = camOffsetY + self.tileHeight
	end
	
	love.graphics.setColor(255, 255, 255)
end

-- Draw specific tile (collidable, background, water, etc...)
-- in given position with given vertical offset
function World:drawSpecificTile(posX, posY, keyName, verticalOffset)
	local header = self.tiles[posX][posY][keyName]
	
	if header == nil then
		-- error
		return
	end
	
	header.animation:draw(self.camera, posX*self.tileWidth, 
		posY*self.tileHeight + verticalOffset,
		self.tileWidth, self.tileHeight, 0)
end

function World:drawBackgroundTiles(startX, startY, endX, endY)
	for y = startY, endY do
		for x = startX, endX do
			if isBackgroundOnTile(self.tiles[x][y]) then
				self:drawSpecificTile(x, y, "backgroundTile", 0)
			end
		end
	end
end

-- Draw all visible collidable tiles
function World:drawCollidableTiles(startX, startY, endX, endY)
	for y = startY, endY do
		for x = startX, endX do
			if isTileCollidable(self.tiles[x][y]) then
				self:drawSpecificTile(x, y, "collidableTile",
					self.tiles[x][y].verticalOffset)
			end
		end
	end
end

-- Draw specified objects in visible map
function World:drawObjects(startX, startY, endX, endY, objectPropertyName)
	local obj
	
	for y = startY, endY do
		for x = startX, endX do
			obj = self.tiles[x][y][objectPropertyName]
			
			if obj and obj:canBeDrawn(self.drawCounter) then
				obj:draw(self.camera, self.drawCounter)
			end
		end
	end
end

-- Draw every water tile in visible map
function World:drawWaterTiles(startX, startY, endX, endY)
	-- Make it transparent
	love.graphics.setColor(255, 255, 255, 128)
	
	for y = startY, endY do
		for x = startX, endX do
			if isWaterOnTile(self.tiles[x][y]) then
				self:drawSpecificTile(x, y, "waterTile", 0)
			end
		end
	end
	
	love.graphics.setColor(255, 255, 255, 255)
end

function World:drawActiveUnits(rectangleAround)
	local it = self.activeUnits.head
	
	while it ~= nil do
		it.data:draw(self.camera)
		it = it.next
	end
end

function World:drawProjectiles()
	local it = self.projectiles.head
	
	while it ~= nil do
		it.data:draw(self.camera)
		it = it.next
	end
end

function World:drawRectangleAroundUnits()
	local it = self.activeUnits.head
	
	while it ~= nil do
		it.data:drawRectangleAround(self.camera)
		it = it.next
	end
end

-- Draw player's UI
function World:drawUI()
	local font = self.fonts.big
	local lives = "Lives: " .. self.player.numLives
	local coins = "Coins: " .. self.player.coins
	local coinsW = font.font:getWidth(coins)
	local offset = 20
	
	font:drawLine(lives, offset, offset)
	font:drawLine(coins, self.camera.virtualWidth - coinsW - offset, offset)
end

-- Draw game staff
function World:draw()
	self.drawCounter = self.drawCounter + 1
	
	self.parallaxBackground:draw(self.camera)
	
	-- Get the coordinates of the tile area
	local startX, startY, endX, endY = self:getDrawingClipCoords()
	
	self.bParticleSystem:draw(self.camera)
	
	self:drawBackgroundTiles(startX, startY, endX, endY)
	self:drawObjects(startX, startY, endX, endY, "backgroundObj")
	
	self:drawProjectiles()
	
	-- Units
	self:drawActiveUnits()
	
	self:drawCollidableTiles(startX, startY, endX, endY)
	self:drawObjects(startX, startY, endX, endY, "activeObj")
	
	-- Particle system
	self.fParticleSystem:draw(self.camera)
	
	-- Foreground objects
	self:drawObjects(startX, startY, endX, endY, "foregroundObj")
	
	-- Water at the end
	self:drawWaterTiles(startX, startY, endX, endY)
end