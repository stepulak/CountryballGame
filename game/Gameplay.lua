require "World"
require "DeathScreen"
require "Gui"
require "Runnable"

local PlayerDeathWaitTime = 3

Gameplay = Runnable:new()

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
	self.jumpButtonPressed = false
	self.shootButtonPressed = false
	
	self.paused = false
	
	if IS_MOBILE_RELEASE then
		self:createVirtualGamepad()
	end
	
	-- In this case, add the quit dialog aswell even if it's not a mobile rel.,
	-- because you do not want to quit immediately when user press "escape"
	
	local virtW = self.world.camera.virtualWidth
	local virtH = self.world.camera.virtualHeight
	
	local _, dialog = self:insertQuitElement(self.gui, self.fonts.medium,
		virtW/2, virtW, virtH, self.world.textureContainer,
		function() self.paused = true end, -- @invokeAction
		function() self.todo = "main_menu_hard" end, -- @quitAction
		function() self.paused = false end) -- @continueAction
	
	self.quitDialog = dialog
end

function Gameplay:createVirtualGamepad()	
	local font = self.fonts.big
	
	self.gamepad = VirtualGamepad:new(
		self.world.camera,
		font, font.font:getHeight() * 1.5, 
		self.world.textureContainer:getTexture("gamepad_button"))
	
	local shootRelAc = function() self.shootButtonPressed = false end
	
	self.gamepad:addActionButton("Y",
		function()
			self.shootButtonPressed = true
		end,
		shootRelAc, shootRelAc)
	
	local jumpRelAc = function() self.jumpButtonPressed = false end
	
	self.gamepad:addActionButton("X",
		function()
			self.jumpButtonPressed = true
		end, 
		jumpRelAc, jumpRelAc)
	
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
-- @return value is somewhere in [0, 1], 0 means inactive, 1 full "speed"
function Gameplay:getPlayerDirection(dir)
	local x, y = 0, 0
	
	if self.gamepad ~= nil then
		local gx, gy = self.gamepad:getDirection()
		local agx, agy = math.abs(gx), math.abs(gy)
		
		if agx < agy then
			if agy > 0.6 then
				y = getUnitValue(gy)
			end
		else
			x = gx
		end
	end
	
	if dir == "up" then
		if love.keyboard.isDown("w") or y == -1 then
			return 1
		end
	elseif dir == "down" then
		if love.keyboard.isDown("s") or y == 1 then
			return 1
		end
	elseif dir == "left" then
		if love.keyboard.isDown("a") then
			return 1
		elseif x < 0 then
			return -x
		end
	elseif dir == "right" then
		if love.keyboard.isDown("d") then
			return 1
		elseif x > 0 then
			return x
		end
	end
	
	return 0	
end

-- @ac can be "jump", "shoot"
function Gameplay:isActionActive(ac)
	if ac == "jump" then
		return self.jumpKeyPressed or self.jumpButtonPressed
	elseif ac == "shoot" then
		return self.shootKeyPressed or self.shootButtonPressed
	else
		return false
	end
end

function Gameplay:clearPressedKeys()
	self.jumpKeyPressed = false
	self.shootKeyPressed = false
	self.jumpButtonPressed = false
	self.shootButtonPressed = false
end

function Gameplay:handleKeyPress(key)
	if key == "space" then
		self.jumpKeyPressed = true
	elseif key == "m" then
		self.shootKeyPressed = true
	elseif key == "escape" then
		if self.quitDialog.invoked then
			self.quitDialog:close()
			self.paused = false
		else
			self.quitDialog:invoke()
			self.paused = true
		end
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
		if self:getPlayerDirection("down") == 1 then
			self.world.player:tryToJumpOffPlatform()
		elseif self:getPlayerDirection("up") == 1 then
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
	
	local leftDir = self:getPlayerDirection("left")
	local rightDir = self:getPlayerDirection("right")
	
	if leftDir ~= 0 then
		self.world.player:moveHorizontally(true, leftDir)
	elseif rightDir ~= 0 then
		self.world.player:moveHorizontally(false, rightDir)
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
	
	if status == "continue" then
		self.todo = "reset_world"
	elseif status == "gameover" then
		self.todo = "main_menu_soft"
	end
end

function Gameplay:update(deltaTime)
	if self.paused and self.deathScreen == nil then
		return
	end
	
	-- Is the player dead?
	if self.world.player ~= nil and self.world.player.dead == true then
		self:handlePlayersDeath(deltaTime)
	end
	
	-- Do not update the gameplay when it's deathscreen on
	if self.deathScreen == nil then
		local mx, my = getScaledMousePosition(self.world.camera, false)
		self.gui:update(deltaTime, mx, my)
		
		self:handlePlayerControl(deltaTime)
		self:clearPressedKeys()
		
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