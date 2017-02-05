require "class"
require "Font"
require "Utils"
require "LinkedList"

local DeathScreenTime = 3
local FinishScreenTime = 6
local NumFireworks = 10

EndScreen = class:new()

-- If @playerDied is true then the EndScreen is used to show player's lives or
-- the "gameover" screen. Otherwise it will contain player's lives, stats,
-- coins etc...
-- @fireworksAnim and @soundContainer are necessary only if @playerDied is false
function EndScreen:init(font, player, playerDied,
	fireworksAnim, soundContainer)
	
	self.player = player
	self.font = font
	self.finishStats = not playerDied
	
	if playerDied == false then
		self.timer = FinishScreenTime
		self.fireworks = LinkedList:new()
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

function EndScreen:addFireworksIfPossible(deltaTime, camera)
	local q = 1/FinishScreenTime * NumFireworks
	local currNum = math.floor(self.timer * q)
	local nextNum = math.floor((self.timer - deltaTime) * q)
	
	if currNum ~= nextNum then
		self.fireworks:addElem()
	end
end

function EndScreen:update(camera, deltaTime)
	if self.timer > 0 then
		if self.finishStats then
			self:addFireworkIfPossible()
		end
		
		self.timer = self.timer - deltaTime
	end
end

function EndScreen:drawFinalStats(screenWidth, screenHeight)
	
end

function EndScreen:drawContinue(screenWidth, screenHeight)
	drawTex(self.player.idleAnim.textures[1], 
		screenWidth/2 - self.player.width/2,
		screenHeight/3 - self.player.height/2,
		self.player.width, self.player.height)
	
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

-- @font is font table from Font.lua
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