require "Editor"
require "Gameplay"
require "Release"

-- Constants

local tileWidth = 60
local tileHeight = 60

Game = class:new()

function Game:init(screen, textureContainer, headerContainer,
	sinCosTable, fonts)
	
	self.screen = screen
	self.textureContainer = textureContainer
	self.headerContainer = headerContainer
	self.sinCosTable = sinCosTable
	self.fonts = fonts
	
	self:newPlayer()
	self:newWorld()
	
	self:resetGameplay()
	
	if IS_OFFICIAL_RELEASE == false then
		self:resetEditor()
	end
	
	self.activeMode = self.gameplay
end

function Game:resetWorld()
	-- You want to preserve the world in it's current state
	-- Just you need to reset the player
	self.world:setupPlayer()
end

function Game:newWorld()
	self.world = World:new(self.player, 
		tileWidth, tileHeight, self.screen,
		self.textureContainer, self.headerContainer,
		self.sinCosTable, self.fonts)
	
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
	if self.activeMode.handleKeyPress and 
		self.activeMode:handleKeyPress(key) then
		-- continue
	elseif key == "`" and IS_OFFICIAL_RELEASE == false then
		-- "tilde" key
		if self.activeMode == self.gameplay then
			self.activeMode = self.editor
		else
			self.activeMode = self.gameplay
		end
	end
end

function Game:handleKeyRelease(key)
	if self.activeMode.handleKeyRelease then
		self.activeMode:handleKeyRelease(key)
	end
end

function Game:handleTextInput(text)
	if self.activeMode.handleTextInput then
		self.activeMode:handleTextInput(text)
	end
end

function Game:handleMouseClick(x, y)
	if self.activeMode.handleMouseClick then
		self.activeMode:handleMouseClick(x, y)
	end
end

function Game:handleMouseRelease(x, y)
	if self.activeMode.handleMouseRelease then
		self.activeMode:handleMouseRelease(x, y)
	end
end

function Game:handleMouseMove(x, y, dx, dy)
	if self.activeMode.handleMouseMove then
		self.activeMode:handleMouseMove(x, y, dx, dy)
	end
end

function Game:handleTodo()
	if self.activeMode.todo == "reset_world" then
		local activeModeName = self.activeMode.name
		
		if IS_OFFICIAL_RELEASE then
			self:newWorld()
		else
			self:resetWorld()
			self:resetEditor()
		end
		
		self:resetGameplay()
		self.player:resetStats()
		
		self.activeMode = activeModeName == "gameplay" 
			and self.gameplay or self.editor
	elseif self.activeMode.todo == "main_menu" then
		-- TODO
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