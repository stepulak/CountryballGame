require "World"
require "DeathScreen"

local PlayerDeathWaitTime = 3

Gameplay = class:new()

function Gameplay:init(world, fonts)
	self.name = "gameplay"
	self.world = world
	self.fonts = fonts
	self.playerDeathWaitTimer = 0
	self.todo = nil
	self.deathScreen = nil
end

function Gameplay:resume()
	self.world.soundContainer:unmuteAll()
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
		elseif key == "n" then
			self.world.player:tryToEnableSprint()
		else
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
	end
end