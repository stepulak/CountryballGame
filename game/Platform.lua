require "ActiveObject"

local PlatformReach = 5 -- In tiles
local PlatformWidth = 3 -- In tiles
local PlatformVel = 200

Platform = ActiveObject:new()

function Platform:init(x, y, tileWidth, tileHeight, isVertical, platformTex)
	if isVertical then
		self:super("vertical_platform", x, y, PlatformWidth + PlatformReach,
			1, tileWidth, tileHeight)
	else
		self:super("horizontal_platform", x, y, PlatformWidth,
			1 + PlatformReach, tileWidth, tileHeight)
	end
	
	self.realX = tileWidth * (x + PlatformWidth/2)
	self.realY = tileHeight * (y + 0.5)
	self.realWidth = PlatformWidth*tileWidth
	self.realHeight = tileHeight/5
	
	self.isVertical = isVertical
	self.platformTex = platformTex
	
	self.boundedUnits = {}
end

function Platform:boundUnit(unit)
	self.boundedUnits[unit] = unit
end

function Platform:isAlreadyBounded(unit)
	return self.boundedUnits[unit] ~= nil
end

function Platform:canBeBounded(unit, deltaTime)
	local distAfter = unit.y + unit.height/2 - 
		(self.realY - self.realHeight/2)
	local distBefore = distAfter - unit.verticalVel * deltaTime
	
	-- Is the unit standing right on the platform?
	if distAfter >= 0 and distBefore <= 0 then
		return lineIntersect(unit.x - unit.width/2, unit.width,
			self.realX - self.realWidth/2, self.realWidth)
	end
	
	return false
end

function Trampoline:handleUnitCollision(unit, deltaTime)
	if self:checkUnitCollision(unit) then
		unit:resolveRectCollision(self.realX, self.realY,
			self.realWidth, self.realHeight, deltaTime)
	end
end

function Platform:updateVerticalMovement(deltaTime)

end

function Platform:updateHorizontalMovement(deltaTime)

end

function Platform:update(camera, particleSystem, deltaTime)
	if self.isVertical then
		self:updateVerticalMovement(deltaTime)
	else
		self:updateHorizontalMovement(deltaTime)
	end
end

function Platform:draw(camera, drawFrameCounter)
	self.drawFrameCounter = drawFrameCounter
	drawTex(self.platformTex,
		self.realX - self.realWidth/2 - camera.x,
		self.realY - self.realHeight/2 - camera.y,
		self.realWidth, self.realHeight)
end