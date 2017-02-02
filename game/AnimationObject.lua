require "TextureAnimation"

AnimationObject = class:new()

-- Setup new visible animation-based object
-- That can be placed into the map as a background/foreground object
function AnimationObject:init(name, x, y, width, height,
	tileWidth, tileHeight, anim)
	
	-- Proportions could have been stored somewhere in object header, but
	-- I've decided to store it separately in each object, so that
	-- it will be easier to draw both animation and active objects...
	
	self.name = name
	self.x = x
	self.y = y
	self.width = width -- In Tiles
	self.height = height -- In Tiles
	self.realX = x*tileWidth + width*tileWidth/2
	self.realY = y*tileHeight + height*tileHeight/2
	self.realWidth = width*tileWidth
	self.realHeight = height*tileHeight
	self.anim = anim
	
	-- To tell the others that this object has beel already drawn
	self.drawCounter = 0
	
	-- So that the save mechanism knows that this object has been already saved
	self.saveCounter = 0
end

function AnimationObject:canBeDrawn(drawCounter)
	return self.drawCounter < drawCounter
end

function AnimationObject:draw(camera, newDrawCounter)
	self.drawCounter = newDrawCounter
	
	if self.anim then
		self.anim:draw(camera, 
			self.realX - self.realWidth/2, 
			self.realY - self.realHeight/2, 
			self.realWidth, self.realHeight, 0, false)
	end
end

function AnimationObject:drawRectangleAround(camera, ...)
	drawRect("line", 
		self.realX - self.realWidth/2 - camera.x,
		self.realY - self.realHeight/2 - camera.y,
		self.realWidth, self.realHeight,
		0, 0, 255, 255)
end