require "World"
require "DeathScreen"
require "Gui"

local PlayerDeathWaitTime = 3

Gameplay = class:new()

function Gameplay:init(world, fonts)
	self.name = "gameplay"
	self.world = world
	self.fonts = fonts
	self.playerDeathWaitTimer = 0
	self.todo = nil
	self.deathScreen = nil
	self.gui = GuiContainer:new()
	
	self:createVirtualGamepad()
end

function Gameplay:createVirtualGamepad()
	local cam = self.world.camera
	local font = self.fonts.big
	
	self.gui:addElement(VirtualGamepad:new(
		cam.virtualWidth, cam.virtualHeight,
		font, font.font:getHeight(), 
		self.world.textureContainer:getTexture("gamepad_button")))
end

function Gameplay:resume()
	self.world.soundContainer:unmuteAll()
end

function Gameplay:handleMouseClick(x, y)
	self.gui:mouseClick(x, y)
end

function Gameplay:handleMouseRelease(x, y)
	self.gui:mouseRelease(x, y)
end

function Gameplay:handleMouseMove(x, y, dx, dy)
	self.gui:mouseMove(x, y, dx, dy)
end

function Gameplay:handleTouchPress(id, x, y)
	self.gui:touchPress(id, x, y)
end

function Gameplay:handleTouchRelease(id, x, y)
	self.gui:touchRelease(id, x, y)
end

function Gameplay:handleTouchMove(id, x, y, dx, dy)
	self.gui:touchMove(id, x, y, dx, dy)
end

function Gameplay:handleKeyPress(key)
	if self.world.player ~= nil and self.world.player.isControllable then
		if key == "space" then
			if love.keyboard.isDown("s") then
				self.world.player:tryToJumpOffPlatform()
			elseif love.keyboard.isDown("w") then
				self.world:activateActiveObject(self.world.player)
			else
				self.world.player:tryToJump()
			end
		elseif key == "m" then
			self.world.player:tryToAttack(self.world.soundContainer)
			self.world.player:tryToEnableSprint()
		--[[
		elseif key == "n" then
			self.world.player:tryToEnableSprint()
		]]else
			-- Key wasn't processed
			return false
		end
	else
		return false
	end
	
	-- Key was processed
	return true
end

function Gameplay:handleKeysStillPressed(deltaTime)
	if self.world.player ~= nil and self.world.player.isControllable then
		if love.keyboard.isDown("a") then
			self.world.player:moveHorizontally(true)
		end
		if love.keyboard.isDown("d") then
			self.world.player:moveHorizontally(false)
		end
	end
end

-- Handle it's death procedure and decide what to do next
function Gameplay:handlePlayersDeath(deltaTime)
	if self.deathScreen == nil then
		self.playerDeathWaitTimer = self.playerDeathWaitTimer + deltaTime
		
		-- Start the death screen after specified time
		-- (Just to make sure the player's death effect is handled properly)
		if self.playerDeathWaitTimer >= PlayerDeathWaitTime then
			self.playerDeathWaitTimer = 0
			self.world.soundContainer:stopAll()
			self.deathScreen = DeathScreen:new(self.world.player, self.fonts.big)
		else
			return
		end
	end
	self.deathScreen:update(deltaTime)
	
	local status = self.deathScreen:endStatus()
	
	if status == "reset_world" then
		self.todo = "reset_world"
	elseif status == "gameover" then
		self.todo = "main_menu"
	end
end

function Gameplay:update(deltaTime)
	self:handleKeysStillPressed(deltaTime)
	
	-- Is the player dead?
	if self.world.player ~= nil and self.world.player.dead == true then
		self:handlePlayersDeath(deltaTime)
	end
	
	-- Do not update the world when it's deathscreen on
	if self.deathScreen == nil then
		self.world:update(deltaTime)
	end
end

function Gameplay:draw()
	if self.deathScreen then
		self.deathScreen:draw(self.world.camera.virtualWidth, 
			self.world.camera.virtualHeight)
	else
		self.world:draw()
		self.world:drawUI()
		self.gui:draw(self.world.camera)
	end
end