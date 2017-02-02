require "Editor"
require "Gameplay"
require "Release"
require "Runnable"

-- Constants

local tileWidth = 60
local tileHeight = 60

Game = Runnable:new()

-- @args is optional, it may consist of:
-- Player:	@args.player: use this player instead of creating new one
-- World:	@args.worldFilename: load this world
-- or  		@args.worldLoadFunc: use this load function
--
-- If both worldFilename and worldLoadFunc are nil, then a new empty world
-- will be created. Same rules apply for @args.player...
function Game:init(screen, textureContainer, soundContainer,
	headerContainer, sinCosTable, fonts, editorInitMode, args)
	
	self.screen = screen
	self.textureContainer = textureContainer
	self.soundContainer = soundContainer
	self.headerContainer = headerContainer
	self.sinCosTable = sinCosTable
	self.fonts = fonts
	
	self.editorInitMode = editorInitMode
	
	if args == nil or args.player == nil then
		self:newPlayer()
	else
		self.player = args.player
	end
	
	self:resetGameplay()
	self.activeMode = self.gameplay
	
	if IS_OFFICIAL_RELEASE == false then
		self:resetEditor()
		
		if editorInitMode then
			self.activeMode = self.editor
		end
	end
end

function Game:resetWorld()
	-- You want to preserve the world in it's current state
	-- Just you need to reset the player
	self.world:setupPlayer()
end

function Game:newWorld()
	self.world = World:new(self.player, 
		tileWidth, tileHeight, self.screen,
		self.textureContainer, self.soundContainer,
		self.headerContainer, self.sinCosTable, self.fonts)
	
	self.world:createSampleWorld()
end

function Game:newPlayer()
	self.player = createUnitFromName("player", 
		-1, -1, tileWidth, tileHeight,
		self.textureContainer)
end

function Game:resetGameplay()
	self.gameplay = Gameplay:new(self.world, self.fonts)
end

function Game:resetEditor()
	self.editor = Editor:new(self.world, self.fonts)
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
	elseif key == "escape" then
		-- TODO
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

function Game:totalReset()
	local activeModeName = self.activeMode.name
		
	if IS_OFFICIAL_RELEASE then
		self:newWorld()
	else
		self:resetWorld()
		self:resetEditor()
	end
	
	self:resetGameplay()
	self.player:hardReset()
	
	self.activeMode = activeModeName == "gameplay" 
		and self.gameplay or self.editor
end

function Game:handleTodo()
	if self.activeMode.todo == "reset_world" then
		self:totalReset()
	elseif self.activeMode.todo == "main_menu" then
		if self.editorInitMode then
			-- In editor mode, you cannot die entirely
			self:totalReset()
			self.player.numLives = 3
		else
			-- TODO
		end
	end
end

function Game:update(deltaTime)
	self:handleTodo()
	
	if self.activeMode.update then
		self.activeMode:update(deltaTime)
	end
end

function Game:draw()
	if self.activeMode.draw then
		self.activeMode:draw()
	end
end