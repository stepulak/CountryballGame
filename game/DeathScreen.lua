require "class"
require "Font"
require "Utils"

local DeathScreenTime = 3

DeathScreen = class:new()

function DeathScreen:init(player, font)
	self.player = player
	self.font = font
	self.timer = DeathScreenTime
end

-- @return "nothing", "gameover", "continue" according to player's lives
function DeathScreen:endStatus()
	if self.timer > 0 then
		return "nothing"
	elseif self.player.numLives <= 0 then
		return "gameover"
	else
		return "continue"
	end
end

function DeathScreen:update(deltaTime)
	if self.timer > 0 then
		self.timer = self.timer - deltaTime
	end
end

function DeathScreen:drawContinue(screenWidth, screenHeight)
	drawTex(self.player.idleAnim.textures[1], 
		screenWidth/2 - self.player.width/2,
		screenHeight/3 - self.player.height/2,
		self.player.width, self.player.height)
	
	self.font:drawLineCentered("Lives: " .. self.player.numLives, 
		screenWidth/2, screenHeight/2)
end

function DeathScreen:drawGameOver(screenWidth, screenHeight)
	local yPos = 2 * (1 - self.timer / DeathScreenTime) * screenHeight/2
	
	if yPos > screenHeight/2 then
		yPos = screenHeight/2
	end
	
	self.font:drawLineCentered("Game Over!", screenWidth/2, yPos)
end

-- @font is font table from Font.lua
function DeathScreen:draw(screenWidth, screenHeight)
	if self.player.numLives <= 0 then
		self:drawGameOver(screenWidth, screenHeight)
	else
		self:drawContinue(screenWidth, screenHeight)
	end
end