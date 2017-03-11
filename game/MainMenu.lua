require "Menu"
require "Game"
require "Credits"
require "Release"
require "AnimationScene"
require "Campaign"
require "assets/maps/_MainMenu"
require "assets/campaigns/_MainCampaign"

local ButtonWidth = 400
local ButtonHeight = 70
local ButtonOffset = 10
local MaxButtonsPerScreen = 5

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
	
	self:createBackgroundWorld()
	self:setupGuiMenu()
end

-- Fill the self.run with given run(nable) object
function MainMenu:setRun(run)
	self.run = run
	self.world:stopBackgroundMusic()
end

function MainMenu:createBackgroundWorld()
	local tilesize = 60
	
	local player = createUnitFromName("player", 
		0, 0, tilesize, tilesize,
		self.textureContainer, false)
		
	self.world = World:new(player, 60, 60, self.screen,
		self.textureContainer, self.soundContainer,
		self.headerContainer, self.sinCosTable, self.fonts)
	
	_MainMenuWorldLoad(self.world)
	--self.world:createSampleWorld()
	
	self.world:postLoadHandle()
end

function MainMenu:setupGuiMenu()
	self.gui = GuiContainer:new()
	
	local menuTree = {}
	
	self:insertCampaignMenuButton(menuTree)
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

function MainMenu:newGame(editorInitMode, args)
	return Game:new(self.screen, 
		self.textureContainer, 
		self.soundContainer,
		self.headerContainer, 
		self.sinCosTable, 
		self.fonts,
		editorInitMode, args)
end

function MainMenu:insertCampaignMenuButton(menuTree)
	local campaign = Campaign:new(
		self.screen,
		self.textureContainer,
		self.soundContainer,
		self.headerContainer,
		self.sinCosTable,
		self.fonts)
	
	_MainCampaign(campaign)
	
	local campaignOpts = {}
	
	if campaign:canContinue() then
		campaignOpts[1] = {
			label = "Continue",
			
			action = function()
				self:setRun(campaign)
				campaign:continue()
			end
		}
	end
	
	campaignOpts[#campaignOpts + 1] = {
		label = "New campaign",
		
		action = function()
			self:setRun(campaign)
			campaign:freshStart()
		end,
	}
	
	-- Back button
	campaignOpts[#campaignOpts + 1] = {
		label = "~back"
	}
	
	menuTree[#menuTree + 1] = {
		label = "Campaign",
		nextNode = campaignOpts,
	}
end

function MainMenu:insertEditorMenuButton(menuTree)
	if IS_MOBILE_RELEASE then
		-- Editor is not part of the mobile release
		return
	end
	
	menuTree[#menuTree + 1] = {
		label = "Editor",
		
		action = function()
			self:setRun(self:newGame(true, nil))
		end,
	}
end

function MainMenu:insertCreatedLevelsMenuButton(menuTree)
	if IS_MOBILE_RELEASE then
		-- You cannot access the user's created levels either
		return
	end
	
	local items = love.filesystem.getDirectoryItems(SAVE_DIR)
	local maxButs = MaxButtonsPerScreen - 2
	local firstLayer = {}
	local currLayer = firstLayer
	
	for i=1, #items do
		currLayer[#currLayer + 1] = {
			-- Label is the filename without the .lua extension
			label = string.sub(items[i], 1, string.len(items[i]) - 4),
			
			action = function()
				self:setRun(self:newGame(false, { worldFilename = items[i] }))
			end
		}
		
		-- Reached maximum number of buttons per screen and
		-- some items still need to be listed? 
		-- Create new node (layer) of buttons.
		if math.fmod(i, maxButs) == 0 and i < #items then
			local next = {}
			currLayer[#currLayer + 1] = {
				label = "Next",
				nextNode = next
			}
			-- Do not forget the "back" button
			currLayer[#currLayer + 1] = { label = "~back" }
			currLayer = next
		end
	end
	
	-- "back" button of the last layer
	currLayer[#currLayer + 1] = { label = "~back" }
	
	menuTree[#menuTree + 1] = {
		label = "Created levels",
		nextNode = firstLayer,
	}
end

function MainMenu:insertCreditsMenuButton(menuTree)
	menuTree[#menuTree + 1] = {
		label = "Credits",
		
		action = function()
			if self.credits == nil then
				self.credits = self:getCredits()
			end
			self:setRun(self.credits)
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
		self.textureContainer,
		self.soundContainer):fill()
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
		self.gui:touchPress(id, tx, ty)
	end
end

function MainMenu:handleTouchRelease(id, tx, ty)
	if self.run ~= nil then
		self.run:handleTouchRelease(id, tx, ty)
	else
		self.gui:touchRelease(id, tx, ty)
	end
end

function MainMenu:handleTouchMove(id, tx, ty, tdx, tdy)
	if self.run ~= nil then
		self.run:handleTouchMove(id, tx, ty, tdx, tdy)
	else
		self.gui:touchMove(id, tx, ty, tdx, tdy)
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
		if self.run:shouldQuit() then
			self.run = nil
			self.soundContainer:stopAll()
			-- Play the background music of the main menu's world again
			self.world:playBackgroundMusic()
			self:setupGuiMenu()
		else
			self.run:update(deltaTime)
		end
	else
		self.gui:update(deltaTime)
		self.world:update(deltaTime)
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
