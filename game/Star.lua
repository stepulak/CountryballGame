require "Unit"
require "Utils"

local ColorMin = 100
local ColorMax = 255

Star = Unit:new()

function Star:init(x, y, tileWidth, tileHeight, dirLeft, texture)
	self:super("star", x, y, tileWidth*0.9, tileHeight*0.9, 
		UnitJumpingVelRecommended*1.5, UnitHorizontalVelRecommended)
	
	self.texture = texture
	self.isFacingLeft = dirLeft
	self.friendlyToPlayer = true
	self.color = { 
		r = math.random(ColorMin, ColorMax), 
		g = math.random(ColorMin, ColorMax), 
		b = math.random(ColorMin, ColorMax)
	}
end

function Star:canBounceTiles()
	return false
end

function Star:update(deltaTime, gravityAcc, particleSystem,
	camera, soundContainer)
 
	self:reverseDirectionAccordingToCollision()
	self:moveHorizontally(self.isFacingLeft)
	
	-- The star is bouncing continuously
	if self.isJumping == false and self.isFalling == false then
		self:tryToJumpNoTimer()
	end
	
	mutateColor(self.color)
	
	self:superUpdate(deltaTime, gravityAcc, particleSystem,
		camera, soundContainer)
end

function Star:draw(camera)
	love.graphics.setColor(self.color.r, self.color.r, 
		self.color.r, self.alpha)

	drawTex(self.texture, 
		self.x - self.width/2 - camera.x, 
		self.y - self.height/2 - camera.y,
		self.width, self.height)
	
	love.graphics.setColor(255, 255, 255, 255)
end