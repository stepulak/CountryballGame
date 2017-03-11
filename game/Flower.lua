require "Unit"

Flower = Unit:new()

-- Flower constructor
-- @type = "fire", "ice"
function Flower:init(type, x, y, tileWidth, tileHeight, texture)
	self:super(type .. "flower", x, y, tileWidth*0.9, tileHeight*0.9, 100, 10)
	
	self.texture = texture
	self.friendlyToPlayer = true
	self.immuneToProjectiles = true
end

function Flower:draw(camera)
	love.graphics.setColor(255, 255, 255, self.alpha)

	drawTex(self.texture, 
		self.x - self.width/2 - camera.x, 
		self.y - self.height/2 - camera.y,
		self.width, self.height)
	
	love.graphics.setColor(255, 255, 255, 255)
end