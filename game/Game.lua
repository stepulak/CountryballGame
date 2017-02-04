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
	
	-- Create new player or use given one (@args.player)
	if args == nil or args.player == nil then
		self:newPlayer()
	else
		self.player = args.player
	end
	
	-- Find out how will you load the world
	if args ~= nil and args.worldFilename ~= nil then
		self.worldFilename = args.worldFilename
		self:loadWorldFromFilename()
	elseif args ~= nil and args.worldLoadFunc ~= nil then
		self.worldLoadFunc = args.worldLoadFunc
		self:loadWorldWithFunc()
	else
		-- Or use empty one?
		self:newEmptyWorld()
	end
	
	self:newGameplay()
	self.activeMode = self.gameplay
	
	if IS_OFFICIAL_RELEASE == false and MOBILE_VERSION == false then
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
	if key == "`" and IS_OFFICIAL_RELEASE == false then
		-- "tilde" key
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
	self.activeMode:handleTouchPress(id, tx, ty)
end

function Game:handleTouchMove(id, tx, ty, tdx, tdy)
	self.activeMode:handleTouchMove(id, tx, ty, tdx, tdy)
end

-- Total reset of the active game
-- According to settings reset the world (load it again) and
-- respawn the player aswell
function Game:totalReset()
	local activeModeName = self.activeMode.name
	
	if self.editorInitMode == false then
		self.soundContainer:stopAll()
		self:loadWorld()
	else
		self:newEditor()
		-- respawn player
		self.world:setupPlayer()
	end
	
	self:newGameplay()
	-- only lives and coins are preserved
	self.player:hardReset()
	
	-- Run the last active mode
	self.activeMode = activeModeName == "gameplay" 
		and self.gameplay or self.editor
end

-- Stop all in-game sounds and be ready to quit
function Game:prepareToQuit()
	self.soundContainer:stopAll()
	self.quit = true
end

-- Handle todos from active mode (gameplay)
function Game:handleTodo()
	if self.activeMode.todo == "reset_world" then
		self:totalReset()
	elseif self.activeMode.todo == "main_menu_soft" then
		if self.editorInitMode then
			-- In editor mode, you cannot die entirely - reset player's lives
			self:totalReset()
			self.player.numLives = 3
		else
			self:prepareToQuit()
		end
	elseif self.activeMode.todo == "main_menu_hard" then
		-- Do not hasitate with quitting, do it now
		self:prepareToQuit()
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