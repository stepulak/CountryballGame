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
	self.jumpKeyPressed = false
	self.shootKeyPressed = false
	
	self:createVirtualGamepad()
end

function Gameplay:createVirtualGamepad()
	local cam = self.world.camera
	local font = self.fonts.big
	
	self.gamepad = VirtualGamepad:new(
		cam.virtualWidth, cam.virtualHeight,
		font, font.font:getHeight(), 
		self.world.textureContainer:getTexture("gamepad_button"))
	
	self.gui:addElement(self.gamepad)
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

function Gameplay:isPlayerControllable()
	return self.world.player ~= nil and self.world.player.isControllable
end

-- @dir can be "up", "down", "left", "right"
function Gameplay:isDirectionActive(dir)
	-- When keyboard is not present
	local x, y = self.gamepad:getDirection()
	
	if dir == "up" then
		return love.keyboard.isDown("w") or y == -1
	elseif dir == "down" then
		return love.keyboard.isDown("s") or y == 1
	elseif dir == "left" then
		return love.keyboard.isDown("a") or x == -1
	elseif dir == "right" then
		return love.keyboard.isDown("d") or x == 1
	else
		return false
	end
end

-- @ac can be "jump", "shoot"
function Gameplay:isActionActive(ac)
	if ac == "jump" then
		return self.jumpKeyPressed
	elseif ac == "shoot" then
		return self.shootKeyPressed
	else
		return false
	end
end

function Gameplay:clearPressedKeys()
	self.jumpKeyPressed = false
	self.shootKeyPressed = false
end

function Gameplay:handleKeyPress(key)
	if key == "space" then
		self.jumpKeyPressed = true
	elseif key == "m" then
		self.shootKeyPressed = true
	else
		-- Wasn't processed
		return false
	end
	
	-- Was processed
	return true
end

function Gameplay:handlePlayerControl(deltaTime)
	if self:isPlayerControllable() == false then
		return
	end
	
	if self:isActionActive("jump") then
		if self:isDirectionActive("down") then
			self.world.player:tryToJumpOffPlatform()
		elseif self:isDirectionActive("up") then
			self.world:activateActiveObject(self.world.player)
		else
			-- Regular jump
			self.world.player:tryToJump()
		end
	end
	
	if self:isActionActive("shoot") then
		self.world.player:tryToAttack(self.world.soundContainer)
		self.world.player:tryToEnableSprint()
	end
	
	if self:isDirectionActive("left") then
		self.world.player:moveHorizontally(true)
	elseif self:isDirectionActive("right") then
		self.world.player:moveHorizontally(false)
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
	self:handlePlayerControl(deltaTime)
	self:clearPressedKeys()
	
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