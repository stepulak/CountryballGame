require "class"
require "Font"
require "Utils"
require "LinkedList"

local DeathScreenTime = 3
local FinishScreenTime = 5
local NumFireworks = 8
local FireworkSize = 50

EndScreen = class:new()

-- If @playerDied is true then the EndScreen is used to show player's lives or
-- for the "gameover" screen. Otherwise "win" screen is shown.
-- @fireworksAnim and @soundContainer are necessary only if @playerDied is false
function EndScreen:init(font, player, playerDied,
	fireworksAnim, soundContainer)
	
	self.player = player
	self.font = font
	self.finishStats = not playerDied
	
	if playerDied == false then
		self.timer = FinishScreenTime
		self.fireworksAnim = fireworksAnim
		self.fireworks = LinkedList:new()
		self.soundContainer = soundContainer
		self.textColor = { r = 255, g = 255, b = 255 }
	else
		self.timer = DeathScreenTime
	end
end

-- @return "nothing", "end", "continue"
function EndScreen:endStatus()
	if self.timer > 0 then
		return "nothing"
	elseif self.player.numLives <= 0 or self.finishStats then
		return "end"
	else
		return "continue"
	end
end

function EndScreen:addFireworksIfPossible(camera, deltaTime)
	local q = 1/FinishScreenTime * NumFireworks
	local currNum = math.floor(self.timer * q)
	local nextNum = math.floor((self.timer - deltaTime) * q)
	
	if currNum ~= nextNum then
		self.fireworks:pushBack({
			x = math.random(0, camera.virtualWidth),
			y = math.random(0, camera.virtualHeight),
			anim = self.fireworksAnim:getCopy()
		})
		-- Sound effect
		self.soundContainer:playEffect("fireworks")
	end
end

function EndScreen:updateExistingFireworks(deltaTime)
	local it = self.fireworks.head
	while it ~= nil do
		local prevIndex = it.data.anim.textureIndex
		
		it.data.anim:update(deltaTime)
		
		if it.data.anim.textureIndex ~= prevIndex and
			it.data.anim.textureIndex == 1 then
			-- Animation will occure only once, then it's deleted
			local it2 = it.next
			self.fireworks:deleteNode(it)
			it = it2
		else
			it = it.next
		end
	end
end

function EndScreen:update(camera, deltaTime)
	if self.timer > 0 then
		if self.finishStats then
			self:addFireworksIfPossible(camera, deltaTime)
			self:updateExistingFireworks(deltaTime)
			mutateColor(self.textColor)
		end
		self.timer = self.timer - deltaTime
	end
end

local FakeCam = { x = 0, y = 0 }

function EndScreen:drawFinalStats(screenWidth, screenHeight)
	-- Fireworks
	local it = self.fireworks.head
	while it ~= nil do
		it.data.anim:draw(FakeCam,
			it.data.x - FireworkSize/2, it.data.y - FireworkSize/2,
			FireworkSize, FireworkSize, 0, false)
		
		it = it.next
	end
	
	self:drawPlayer(screenWidth, screenHeight)
	
	-- Text
	love.graphics.setColor(self.textColor.r, self.textColor.g, self.textColor.b)
	self.font:drawLineCentered("You have made it!", screenWidth/2, screenHeight/2)
	love.graphics.setColor(255, 255, 255)
end

function EndScreen:drawPlayer(screenWidth, screenHeight)
	drawTex(self.player.idleAnim.textures[1], 
		screenWidth/2 - self.player.width/2,
		screenHeight/3 - self.player.height/2,
		self.player.width, self.player.height)
end

function EndScreen:drawContinue(screenWidth, screenHeight)
	self:drawPlayer(screenWidth, screenHeight)
	self.font:drawLineCentered("Lives: " .. self.player.numLives,
		screenWidth/2, screenHeight/2)
end

function EndScreen:drawGameOver(screenWidth, screenHeight)
	local yPos = 2 * (1 - self.timer / DeathScreenTime) * screenHeight/2
	
	if yPos > screenHeight/2 then
		yPos = screenHeight/2
	end
	
	self.font:drawLineCentered("Game Over!", screenWidth/2, yPos)
end

function EndScreen:draw(screenWidth, screenHeight)
	if self.finishStats == false then
		if self.player.numLives <= 0 then
			self:drawGameOver(screenWidth, screenHeight)
		else
			self:drawContinue(screenWidth, screenHeight)
		end
	else
		self:drawFinalStats(screenWidth, screenHeight)
	end
end