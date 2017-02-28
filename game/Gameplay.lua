require "World"
require "EndScreen"
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
	self.endScreen = nil
	
	self.gui = GuiContainer:new()
	
	self.jumpKeyPressed = false
	self.shootKeyPressed = false
	self.jumpButtonPressed = false
	self.shootButtonPressed = false
	
	self.paused = false
	self.justScenery = false
	
	if IS_MOBILE_RELEASE then
		self:createVirtualGamepad()
	end
	
	-- In this case, add the quit dialog aswell even if it's not a mobile rel.,
	-- because you do not want to quit immediately when user press "escape",
	-- you want to show him a dialog first.
	
	local virtW = self.world.camera.virtualWidth
	local virtH = self.world.camera.virtualHeight
	
	local _, dialog = self:insertQuitElement(self.gui, self.fonts.medium,
		virtW/2, virtW, virtH, self.world.textureContainer,
		function() self.paused = true end, -- @invokeAction
		function() self.todo = "quit" end, -- @quitAction
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
	elseif key == "2" and JUST_SCENERY_ENABLED == true then
		self.justScenery = not self.justScenery
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

function Gameplay:resolvePlayersDeath(deltaTime)
	self.playerDeathWaitTimer = self.playerDeathWaitTimer + deltaTime
	
	if self.playerDeathWaitTimer >= PlayerDeathWaitTime then
		self.playerDeathWaitTimer = 0
		-- Stop all sound effects, the death screen is comming
		self.world.soundContainer:stopAll()
		self.world.camera:zeroPosition()
		self.endScreen = EndScreen:new(self.fonts.big, self.world.player, true)
	end
end

function Gameplay:resolvePlayersFinish(deltaTime)
	self.world.soundContainer:stopAll()
	self.world.camera:zeroPosition()
	
	self.endScreen = EndScreen:new(
		self.fonts.big, self.world.player, false,
		self.world.textureContainer:getAnimation("fireworks"),
		self.world.soundContainer)
end

function Gameplay:handleEndScreen(deltaTime)
	self.endScreen:update(self.world.camera, deltaTime)
	
	local status = self.endScreen:endStatus()
	
	if status ~= "nothing" then
		self.todo = status
	end
end

function Gameplay:update(deltaTime)
	if self.paused and self.endScreen == nil then
		return
	end
	
	-- Is the player dead? Or did he make it to the finish?
	if self.endScreen == nil then
		if self.world.player ~= nil and self.world.player.dead then
			self:resolvePlayersDeath(deltaTime)
		elseif self.world.shouldEnd then
			self:resolvePlayersFinish(deltaTime)
		end
	end
	
	-- Do not update the gameplay when it's endScreen on
	if self.endScreen ~= nil then
		self:handleEndScreen(deltaTime)
	else
		local mx, my = getScaledMousePosition(self.world.camera, false)
		self.gui:update(deltaTime, mx, my)
		
		self:handlePlayerControl(deltaTime)
		self:clearPressedKeys()
		
		self.world:update(deltaTime)
	end
end

function Gameplay:draw()
	if self.endScreen then
		self.endScreen:draw(
			self.world.camera.virtualWidth, 
			self.world.camera.virtualHeight)
	else
		self.world:draw(self.justScenery)
		
		if self.justScenery == false then
			self.world:drawUI()
			self.gui:draw(self.world.camera)
		end
	end
end