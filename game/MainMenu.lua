require "Menu"
require "Game"
require "Credits"
require "Release"
--require "assets/maps/MainMenuMap.lua"

local ButtonWidth = 300
local ButtonHeight = 70
local ButtonOffset = 50

MainMenu = Runnable:new()

function MainMenu:init(screen, textureContainer, soundContainer,
	headerContainer, sinCosTable, fonts)
	
	self.screen = screen
	self.textureContainer = textureContainer
	self.soundContainer = soundContainer
	self.headerContainer = headerContainer
	self.sinCosTable = sinCosTable
	self.fonts = fonts
	
	self.gameLogoTex = textureContainer:getTexture("game_logo")
	self.gameLogoAngle = 0
	self.gameLogoDir = 1
	
	self.credits = nil
	self.run = nil -- runnable
	self.quit = false
	
	self.gui = GuiContainer:new()
	
	self:createBackgroundWorld()
	self:setupMenu()
end

function MainMenu:createBackgroundWorld()
	local tilesize = 60
	
	self.world = World:new(nil, 60, 60, self.screen,
		self.textureContainer, self.soundContainer,
		self.headerContainer, self.sinCosTable, self.fonts)
	
	self.world:createEmptyWorld(20, 20)
	--_MainMenuWorldLoad(self.world)
end

function MainMenu:setupMenu()
	local menuTree = {}
	
	self:insertGameContinueMenuButton(menuTree)
	self:insertNewGameMenuButton(menuTree)
	self:insertEditorMenuButton(menuTree)
	self:insertCreatedLevelsMenuButton(menuTree)
	self:insertCreditsMenuButton(menuTree)
	self:insertQuitMenuButton(menuTree)
	
	local menu = Menu:new(
		self.screen.virtualWidth, self.screen.virtualHeight,
		ButtonWidth, ButtonHeight, ButtonOffset,
		self.textureContainer:getTexture("button_idle"),
		self.textureContainer:getTexture("button_click"),
		self.fonts.big, menuTree)
	
	self.gui:addElement(menu)
end

function MainMenu:newGame(editorInitMode)
	return Game:new(self.screen, 
		self.textureContainer, 
		self.soundContainer,
		self.headerContainer, 
		self.sinCosTable, 
		self.fonts,
		editorInitMode)
end

function MainMenu:insertGameContinueMenuButton(menuTree)
	-- TODO
end

function MainMenu:insertNewGameMenuButton(menuTree)
	-- TODO
end

function MainMenu:insertEditorMenuButton(menuTree)
	if IS_OFFICIAL_RELEASE then
		-- Editor is not part of the official release
		return
	end
	
	menuTree[#menuTree + 1] = {
		label = "Editor",
		
		action = function()
			self.run = self:newGame(true)
		end,
	}
end

function MainMenu:insertCreatedLevelsMenuButton(menuTree)
	-- TODO
end

function MainMenu:insertCreditsMenuButton(menuTree)
	menuTree[#menuTree + 1] = {
		label = "Credits",
		
		action = function()
			if self.credits == nil then
				self.credits = self:getCredits()
			end
			self.run = self.credits
			self.run:start()
		end,
	}
end

function MainMenu:insertQuitMenuButton(menuTree)
	menuTree[#menuTree + 1] = {
		label = "Quit",
		
		action = function()
			self.quit = true
		end,
	}
end

function MainMenu:getCredits()
	return Credits:new(
		self.screen.virtualWidth,
		self.screen.virtualHeight, 
		self.fonts, 
		self.textureContainer):fill()
end

function MainMenu:handleKeyPress(key)
	if self.run ~= nil then
		self.run:handleKeyPress(key)
	else
		self.gui:keyPress(key)
	end
end

function MainMenu:handleKeyRelease(key)
	if self.run ~= nil then
		self.run:handleKeyRelease(key)
	else
		--self.gui:keyRelease(key)
	end
end

function MainMenu:handleTextInput(text)
	if self.run ~= nil then
		self.run:handleTextInput(text)
	else
		self.gui:textInput(text)
	end
end

function MainMenu:handleMouseClick(x, y)
	if self.run ~= nil then
		self.run:handleMouseClick(x, y)
	else
		self.gui:mouseClick(x, y)
	end
end

function MainMenu:handleMouseRelease(x, y)
	if self.run ~= nil then
		self.run:handleMouseRelease(x, y)
	else
		self.gui:mouseRelease(x, y)
	end
end

function MainMenu:handleMouseMove(x, y, dx, dy)
	if self.run ~= nil then
		self.run:handleMouseMove(x, y, dx, dy)
	else
		self.gui:mouseMove(x, y, dx, dy)
	end
end

function MainMenu:handleTouchPress(id, tx, ty)
	if self.run ~= nil then
		self.run:handleTouchPress(id, tx, ty)
	else
		self.gui:touchPress(tx, ty)
	end
end

function MainMenu:handleTouchRelease(id, tx, ty)
	if self.run ~= nil then
		self.run:handleTouchRelease(id, tx, ty)
	else
		self.gui:touchRelease(tx, ty)
	end
end

function MainMenu:handleTouchMove(id, tx, ty, tdx, tdy)
	if self.run ~= nil then
		self.run:handleTouchMove(id, tx, ty, tdx, tdy)
	else
		self.gui:touchMove(tx, ty, tdx, tdy)
	end
end

function MainMenu:shouldQuit()
	return self.quit
end

local GameLogoRotVel = 0.1
local GameLogoAngleMax = math.pi/20

function MainMenu:updateGameLogoRotation(deltaTime)
	self.gameLogoAngle = self.gameLogoAngle +
		self.gameLogoDir * deltaTime * GameLogoRotVel
	
	if math.abs(self.gameLogoAngle) >= GameLogoAngleMax then
		self.gameLogoAngle = GameLogoAngleMax * self.gameLogoDir
		self.gameLogoDir = -self.gameLogoDir
	end
end

function MainMenu:update(deltaTime)
	if self.run ~= nil then
		self.run:update(deltaTime)
		
		if self.run:shouldQuit() then
			self.run = nil
		end
	else
		self.world:update(deltaTime)
		self.gui:update(deltaTime)
		self:updateGameLogoRotation(deltaTime)
	end
end

function MainMenu:drawGameLogo()
	local w, h = self.gameLogoTex:getDimensions()
	
	love.graphics.push()
	love.graphics.translate(self.screen.virtualWidth/2, 50 + h/2)
	love.graphics.rotate(self.gameLogoAngle)
	
	drawTex(self.gameLogoTex, -w/2, -h/2, w, h)
	
	love.graphics.pop()
end

function MainMenu:draw()
	if self.run ~= nil then
		self.run:draw()
	else
		self.world:draw()
		self.gui:draw(self.world.camera)
		self:drawGameLogo()
	end
end
