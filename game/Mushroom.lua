require "Unit"
require "Utils"

Mushroom = Unit:new()

-- Mushroom constructor 
-- @type = "live", "grow"
function Mushroom:init(type, x, y, tileWidth, tileHeight, dirLeft, texture)
	self:super("mushroom_" .. type, x, y, tileWidth*0.9, tileHeight*0.9, 
		UnitJumpingVelRecommended, UnitHorizontalVelRecommended)
	
	self.texture = texture
	self.isFacingLeft = dirLeft
	self.friendlyToPlayer = true
end

function Mushroom:update(deltaTime, gravityAcc, particleSystem,
	camera, soundContainer)
	
	self:reverseDirectionAccordingToCollision()
	self:moveHorizontally(self.isFacingLeft)
	self:superUpdate(deltaTime, gravityAcc, particleSystem,
		camera, soundContainer)
end

function Mushroom:draw(camera)
	love.graphics.setColor(255, 255, 255, self.alpha)

	drawTex(self.texture, 
		self.x - self.width/2 - camera.x, 
		self.y - self.height/2 - camera.y,
		self.width, self.height)
	
	love.graphics.setColor(255, 255, 255, 255)
end