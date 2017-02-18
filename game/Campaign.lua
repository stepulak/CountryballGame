require "AnimationScene"
require "Game"

local PlayerStdLives = 3

Campaign = Runnable:new()

function Campaign:init(screen, textureContainer, soundContainer,
	headerContainer, sinCosTable, fonts)
	
	self.screen = screen
	self.textureContainer = textureContainer
	self.soundContainer = soundContainer
	self.headerContainer = headerContainer
	self.sinCosTable = sinCosTable
	self.fonts = fonts
	
	self.quit = false
	
	self.name = nil -- Campaign name
	self.content = {}
	self.activeContent = nil
	self.run = nil -- Active runnable content
	
	self.player = nil -- It's nil till some world is created
	
	self.saveFileLoaded = false
	
	-- Player's save file info
	-- It's necessary to have these variables instead of accessing
	-- directly to player's data - because the player itself doesn't
	-- exist till some world is created...
	-- HINT: Make sure it's consistent to real player's data
	self.playerLives = nil
	self.playerCoins = nil
	self.playerHelmet = nil
	self.playerFlower = nil
end

function Campaign:addLevel(worldLoadFunc)
	self.content[#self.content + 1] = {
		type = "level",
		loadFunc = worldLoadFunc,
	}
	return self
end

-- @sceneType = "intro", "outro"
-- 	"intro" => this scene belongs to the next level
--	"outro" => this scene belongs to the previous level
function Campaign:addScene(sceneLoadFunc, sceneType)
	self.content[#self.content + 1] = {
		type = "scene",
		loadFunc = sceneLoadFunc,
		sceneType = sceneType,
	}
	return self
end

function Campaign:areSaveDataDamaged()
	return self.activeContent == nil or
		self.playerLives == nil or
		self.playerCoins == nil or
		self.playerHelmet == nil
		-- or self.playerFlower
end

function Campaign:loadSaveFile(name)
	self.name = name
	self.saveFileLoaded = self:saveFileExists()
	
	if self.saveFileLoaded then
		local res = {}
		-- Retrieve data
		love.filesystem.load(self:getSaveFileName())(res)
		self.activeContent = res.activeContent
		self.playerLives = res.playerLives
		self.playerCoins = res.playerCoins
		self.playerHelmet = res.playerHelmet
		self.playerFlower = res.playerFlower
		
		if self:areSaveDataDamaged() then
			self.saveFileLoaded = false
			print("Damaged savefile.")
		end
	end
end

-- Can you continue playing? Is there any saveFile of it?
function Campaign:canContinue()
	return self.saveFileLoaded
end

-- Continue playing the campaign. Note that saveFile must be loaded.
function Campaign:continue()
	if self:canContinue() then
		if self.content[self.activeContent] ~= nil then
			-- Is there any "intro" scene for the current level?
			-- Then play it before you start the wanted level!
			local prev = self.content[self.activeContent - 1]
			
			if prev ~= nil and prev.sceneType == "intro" then
				self.activeContent = self.activeContent - 1
			end
			
			self:setupActiveContent()
		else
			print("Unexpected error, level missing")
			return
		end
	end
end

-- Reset save file (if it exists) and play the campaign from the start.
function Campaign:freshStart()
	self:removeSaveFile()
	
	self.activeContent = 1
	self.playerLives = PlayerStdLives
	self.playerCoins = 0
	
	if self.content[self.activeContent] ~= nil then
		self:setupActiveContent()
	else
		print("No campaign content to run!")
		self.quit = true
	end
end

function Campaign:getSaveFileName()
	return self.name .. ".lua"
end

function Campaign:saveFileExists()
	return love.filesystem.exists(self:getSaveFileName())
end

function Campaign:removeSaveFile()
	love.filesystem.remove(self:getSaveFileName())
end

function Campaign:saveCampaignState()
	if self.player == nil then
		-- No data to save cause no world has been created yet
		return
	end
	
	-- Remove old content if any
	self:removeSaveFile()
	
	local f = love.filesystem.newFile(self:getSaveFileName())
	
	if f:open("w") then
		checkWriteLn(f, "local res = ...")
		checkWriteLn(f, "res.activeContent = " .. self.activeContent)
		checkWriteLn(f, "res.playerLives = " .. self.player.numLives)
		checkWriteLn(f, "res.playerCoins = " .. self.player.coins)
		checkWriteLn(f, "res.playerHelmet = " .. 
			tostring(self.player.helmetEnabled))
			
		if self.player.flowerType ~= nil then
			checkWriteLn(f, "res.playerFlower = \"" .. 
				self.player.flowerType .. "\"")
		end
		
		f:close()
	else
		print("Unable to create savefile")
	end
end

function Campaign:fillPlayerWithSaveData()
	self.player.numLives = self.playerLives
	self.player.coins = self.playerCoins
	self.player.helmetEnabled = self.playerHelmet
	self.player.flowerType = self.playerFlower
end

function Campaign:setupActiveContent()
	local c = self.content[self.activeContent]
	
	if c.type == "level" then
		local opts = { worldLoadFunc = c.loadFunc }
		
		-- Use player from previous world
		if self.player ~= nil then
			opts.player = self.player
		end
		
		self.run = Game:new(
			self.screen,
			self.textureContainer,
			self.soundContainer,
			self.headerContainer,
			self.sinCosTable,
			self.fonts,
			false, opts)
		
		-- Fresh start or "fresh" continue?
		-- Make sure you've filled player with savedata
		if self.player == nil then
			self.player = self.run.player
			self:fillPlayerWithSaveData()
		end
	elseif c.type == "scene" then
		self.run = AnimationScene:new(
			self.screen.virtualWidth,
			self.screen.virtualHeight,
			self.fonts.medium,
			self.soundContainer,
			self.sinCosTable)
			
		c.loadFunc(self.run, self.textureContainer)
		self.run:start()
	end
	
	self:saveCampaignState()
end

function Campaign:nextContent()
	self.activeContent = self.activeContent + 1
	
	if self.content[self.activeContent] == nil then
		-- You have finished the campaign
		self:removeSaveFile()
		self.quit = true
	else
		self:setupActiveContent()
	end
end

function Campaign:handleKeyPress(key)
	self.run:handleKeyPress(key)
end

function Campaign:handleKeyRelease(key)
	self.run:handleKeyRelease(key)
end

function Campaign:handleTextInput(text)
	self.run:handleTextInput(text)
end

function Campaign:handleMouseClick(x, y)
	self.run:handleMouseClick(x, y)
end

function Campaign:handleMouseRelease(x, y)
	self.run:handleMouseRelease(x, y)
end

function Campaign:handleMouseMove(x, y, dx, dy)
	self.run:handleMouseMove(x, y, dx, dy)
end

function Campaign:handleTouchPress(id, tx, ty)
	self.run:handleTouchPress(id, tx, ty)
end

function Campaign:handleTouchRelease(id, tx, ty)
	self.run:handleTouchRelease(id, tx, ty)
end

function Campaign:handleTouchMove(id, tx, ty, tdx, tdy)
	self.run:handleTouchMove(id, tx, ty, tdx, tdy)
end

function Campaign:shouldQuit()
	return self.quit
end

function Campaign:update(deltaTime)
	self.run:update(deltaTime)
	
	if self.run:shouldQuit() then
		local reason = self.run.quitReason
		
		if reason == "user_quit" then
			-- Quit to main menu
			-- self:saveCampaignState()
			self.quit = true
		elseif reason == "cannot_continue" then
			-- Cannot continue playing campaign, gameover
			self:removeSaveFile()
			self.quit = true
		elseif reason == "continue" or reason == nil then
			-- Continue campaign
			self:nextContent()
		end
	end
end

function Campaign:draw()
	-- Just in case the quit func is called in the next frame
	if self.run ~= nil then
		self.run:draw()
	end
end