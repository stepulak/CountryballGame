require "ActiveObject"

local PlatformReach = 5 -- In tiles
local PlatformWidth = 3 -- In tiles
local PlatformVel = 200
local PlatformDistError = 1

Platform = ActiveObject:new()

function Platform:init(x, y, tileWidth, tileHeight, isVertical, platformTex)
	if isVertical then
		self:super("vertical_platform", x, y, PlatformWidth + PlatformReach,
			1, tileWidth, tileHeight)
		
		self.offsetMax = PlatformReach * tileWidth
	else
		self:super("horizontal_platform", x, y, PlatformWidth,
			1 + PlatformReach, tileWidth, tileHeight)
			
		self.offsetMax = PlatformReach * tileHeight
	end
	
	self.horOffset = 0
	self.verOffset = 0
	self.dir = 1
	
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
	
	-- Make sure that the unit is standing right on the platform
	unit.y = self.realY - self.realHeight/2 - unit.height/2
	self:stopUnitFalling(unit)
end

function Platform:isAlreadyBounded(unit)
	return self.boundedUnits[unit] ~= nil
end

function Platform:verticalDistUnit(unit)
	return unit.y + unit.height/2 - (self.realY - self.realHeight/2)
end

function Platform:canBeBounded(unit, deltaTime)
	local distAfter = self:verticalDistUnit(unit)
	local distBefore = distAfter - unit.verticalVel * deltaTime
	
	-- Is the unit standing right on the platform?
	if distAfter >= 0 and distBefore <= 0 then
		return lineIntersect(unit.x - unit.width/2, unit.width,
			self.realX - self.realWidth/2, self.realWidth)
	end
	
	return false
end

function Platform:handleUnitCollision(unit, deltaTime)
	if self:checkUnitCollision(unit) then
		unit:resolveRectCollision(self.realX, self.realY,
			self.realWidth, self.realHeight, deltaTime)
	end
end

function Platform:stopUnitFalling(unit)
	unit.isFalling = false
	unit.verticalVel = 0
end

function Platform:unboundInactiveUnits()
	for key, unit in pairs(self.boundedUnits) do
		if math.abs(self:verticalDistUnit(unit)) > PlatformDistError then
			self.boundedUnits[key] = nil
		end
	end
end

function Platform:handleAndMoveBoundedUnits(distX, distY)
	for key, unit in pairs(self.boundedUnits) do
		unit:moveSpecific(distX, distY)
		self:stopUnitFalling(unit)
	end
end

function Platform:updateVerticalMovement(deltaTime)
	self.verOffset = self.verOffset + PlatformVel * self.dir * deltaTime
	
	if self.dir == 1 and self.verOffset >= self.offsetMax then
		self.dir = -1
		self.verOffset = self.offsetMax
	elseif self.dir == -1 and self.verOffset <= 0 then
		self.dir = 1
		self.verOffset = 0
	end
end

function Platform:updateHorizontalMovement(deltaTime)

end

function Platform:update(camera, particleSystem, deltaTime)
	if self.isVertical then
		self:updateVerticalMovement(deltaTime)
	else
		self:updateHorizontalMovement(deltaTime)
	end
	
	self:unboundInactiveUnits()
end

function Platform:draw(camera, drawFrameCounter)
	self.drawFrameCounter = drawFrameCounter
	drawTex(self.platformTex,
		self.realX - self.realWidth/2 + self.horOffset - camera.x,
		self.realY - self.realHeight/2 + self.verOffset - camera.y,
		self.realWidth, self.realHeight)
end