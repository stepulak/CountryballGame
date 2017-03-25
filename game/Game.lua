require "Editor"
require "Gameplay"
require "Release"
require "Runnable"

-- Constants

local TileWidth = 60
local TileHeight = 60

Game = Runnable:new()

-- @args is optional, it may consist of:
-- Player:	@args.player: use this player instead of creating new one
-- World:	@args.worldFilename: load world from given filename
-- or  		@args.worldLoadFunc: use this load function
--  		@args.editorDisabled: true if you don't want to use editor at all
--
-- If both worldFilename and worldLoadFunc are nil, then a new empty world
-- will be created. Same rules apply for @args.player...
function Game:init(screen,
	textureContainer,
	soundContainer,
	headerContainer,
	sinCosTable,
	fonts,
	editorInitMode,
	args)
	
	self.screen = screen
	self.textureContainer = textureContainer
	self.soundContainer = soundContainer
	self.headerContainer = headerContainer
	self.sinCosTable = sinCosTable
	self.fonts = fonts
	
	self.quit = false 
	self.editorInitMode = editorInitMode
	
	local args_ = args or {}
	
	self.editorDisabled = args_.editorDisabled or false
	
	-- Create new player or use given one (@args.player)
	if args_.player == nil then
		self:newPlayer()
	else
		self.player = args_.player
	end
	
	-- Find out how will you load the world
	if args_.worldFilename ~= nil then
		self.worldFilename = args_.worldFilename
	elseif args_.worldLoadFunc ~= nil then
		self.worldLoadFunc = args_.worldLoadFunc
	end
	
	self:loadWorld()
	self:newGameplay()
	self.activeMode = self.gameplay
	
	if IS_MOBILE_RELEASE == false then
		self:newEditor()
		
		if editorInitMode then
			self.activeMode = self.editor
		end
	end
end

function Game:createWorld()
	self.world = World:new(self.player, 
		TileWidth, TileHeight, self.screen,
		self.textureContainer, self.soundContainer,
		self.headerContainer, self.sinCosTable, self.fonts)
end

function Game:newEmptyWorld()
	self:createWorld()
	self.world:createEmptyWorld(40, 40)
end

function Game:newPlayer()
	self.player = createUnitFromName("player", 
		-1, -1, TileWidth, TileHeight,
		self.textureContainer)
end

function Game:newGameplay()
	self.gameplay = Gameplay:new(self.world, self.fonts)
end

function Game:newEditor()
	self.editor = Editor:new(self.world, self.fonts)
end

function Game:loadWorld()
	if self.worldFilename ~= nil then
		self:loadWorldFromFilename()
	elseif self.worldLoadFunc ~= nil then
		self:loadWorldWithFunc()
	else
		self:newEmptyWorld()
	end
end

-- load new world from self.worldFilename path
function Game:loadWorldFromFilename()
	self:createWorld()
	self.world:loadFromSaveDir(self.worldFilename)
end

function Game:loadWorldWithFunc()
	self:createWorld()
	self.worldLoadFunc(self.world)
	-- Do not forget to call post load handle!
	self.world:postLoadHandle()
end

function Game:handleKeyPress(key)
	-- "tilde" key
	if key == "end" and IS_MOBILE_RELEASE == false 
		and self.editorDisabled == false then
		
		if self.activeMode == self.gameplay then
			self.activeMode = self.editor
		else
			self.activeMode = self.gameplay
		end
		
		self.activeMode:resume()
	else
		self.activeMode:handleKeyPress(key)
	end
end

function Game:handleKeyRelease(key)
	self.activeMode:handleKeyRelease(key)
end

function Game:handleTextInput(text)
	self.activeMode:handleTextInput(text)
end

function Game:handleMouseClick(x, y)
	self.activeMode:handleMouseClick(x, y)
end

function Game:handleMouseRelease(x, y)
	self.activeMode:handleMouseRelease(x, y)
end

function Game:handleMouseMove(x, y, dx, dy)
	self.activeMode:handleMouseMove(x, y, dx, dy)
end

function Game:handleTouchPress(id, tx, ty)
	self.activeMode:handleTouchPress(id, tx, ty)
end

function Game:handleTouchRelease(id, tx, ty)
	self.activeMode:handleTouchRelease(id, tx, ty)
end

function Game:handleTouchMove(id, tx, ty, tdx, tdy)
	self.activeMode:handleTouchMove(id, tx, ty, tdx, tdy)
end

-- Total reset of the active game.
-- According to settings reset the world (load it again) and
-- respawn the player aswell.
function Game:totalReset()
	local activeModeName = self.activeMode.name
	
	if self.editorInitMode == false then
		self.soundContainer:stopAll()
		self:loadWorld()
	else
		self:newEditor()
		
		-- Is the player dead? That means he was kicked from active units...
		if self.player.dead then
			self.world:addPlayerIntoActiveUnits()
		end
		
		self.world:setPlayerAtSpawnPosition()
		self.world.shouldEnd = false
		self.world.playerFinished = false
		
		if self.world.escapeRocket ~= nil then
			-- Player escaped via rocket
			-- Reset it aswell
			self.world.escapeRocket:reset()
			self.world.escapeRocket = nil
		end 
	end
	
	self:newGameplay()
	-- only lives and coins are preserved
	self.player:hardReset()
	
	-- Run the last active mode
	self.activeMode = 
		activeModeName == "gameplay" and self.gameplay or self.editor
end

-- Stop all in-game sounds and be ready to quit
function Game:prepareToQuit(reason)
	self.soundContainer:stopAll()
	self.quit = true
	self.quitReason = reason
end

-- Handle todos from active mode (gameplay)
function Game:handleTodo()
	local todo = self.activeMode.todo
	
	if todo == "quit" then
		self:prepareToQuit("user_quit")
	elseif todo == "player_no_lives" then
		if self.editorInitMode then
			self:totalReset()
			self.player.numLives = 3
		else
			self:prepareToQuit("cannot_continue")
		end
	elseif todo == "player_finished" then
		if self.editorInitMode then
			self:totalReset()
		else
			self:prepareToQuit("continue")
		end
	elseif todo == "player_just_died" then
		self:totalReset()
	end
end

function Game:shouldQuit()
	return self.quit
end

function Game:update(deltaTime)
	self:handleTodo()
	
	if self.activeMode.update then
		self.activeMode:update(deltaTime)
	end
end

function Game:draw()
	self.activeMode:draw()
end