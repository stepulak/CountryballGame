require "ActiveObject"

local PlatformReach = 5 -- In tiles
local PlatformWidth = 3 -- In tiles
local PlatformVel = 200
local PlatformDistError = 1

Platform = ActiveObject:new()

function Platform:init(x, y, tileWidth, tileHeight,
	isVertical, startPos, platformTex)
	
	if isVertical then
		self:super("vertical_platform", x, y, PlatformWidth,
			1 + PlatformReach, tileWidth, tileHeight)
			
		self.offsetMax = PlatformReach * tileHeight
	else
		self:super("horizontal_platform", x, y, PlatformWidth + PlatformReach,
			1, tileWidth, tileHeight)
		
		self.offsetMax = PlatformReach * tileWidth
	end
	
	self.realX = tileWidth * (x + PlatformWidth/2)
	self.realY = tileHeight * (y + 0.5)
	self.realWidth = (PlatformWidth - 1) * tileWidth
	self.realHeight = tileHeight/5
	
	if startPos then
		self.offset = 0
		self.dir = 1
		self.name = self.name .. "_start"
	else
		self.offset = self.offsetMax
		self.dir = -1
		self.name = self.name .. "_end"
		self.setupPosImmediately = true
	end
	
	self.isVertical = isVertical
	self.platformTex = platformTex
	
	self.boundedUnits = {}
end

-- Setup position at the end of the limit immediately 
-- after you insert the platform into the world's grid.
-- This little nasty *hack* has to be done because of
-- the editor's grid with active objects, otherwise
-- the object in the grid would move away from it's default position.
function Platform:setup()
	if self.setupPosImmediately then
		self.setupPosImmediately = nil
		
		if self.isVertical then
			self.realY = self.realY + self.offset
		else
			self.realX = self.realX + self.offset
		end
	end
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

function Platform:unitHorizontalIntersect(unit)
	return lineIntersect(unit.x - unit.width/2, unit.width,
		self.realX - self.realWidth/2, self.realWidth)
end

function Platform:canBeBounded(unit, deltaTime)
	local distAfter = self:verticalDistUnit(unit)
	local distBefore = distAfter - unit.verticalVel * deltaTime
	
	-- Is the unit standing right on the platform?
	if distAfter >= 0 and distBefore <= 0 then
		return self:unitHorizontalIntersect(unit)
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
	--unit.verticalVel = 0
end

function Platform:unboundInactiveUnits()
	for key, unit in pairs(self.boundedUnits) do
		if not (math.abs(self:verticalDistUnit(unit)) < PlatformDistError and
			self:unitHorizontalIntersect(unit)) then
			unit:startFalling()
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

-- Update current offset and get real distance
function Platform:getDistUpdateOffset(deltaTime)
	local dist = PlatformVel * self.dir * deltaTime
	self.offset = self.offset + dist
	
	-- If you reach the maximum offset, reverse the direction
	-- and lower the possible distance (you cannot overflow the offset limit)
	if self.dir == 1 and self.offset >= self.offsetMax then
		dist = dist - (self.offset - self.offsetMax)
		self.offset = self.offsetMax
		self.dir = -1
	elseif self.dir == -1 and self.offset <= 0 then
		dist = dist - self.offset
		self.dir = 1
		self.offset = 0
	end
	
	return dist
end

function Platform:updateVerticalMovement(deltaTime)
	local dist = self:getDistUpdateOffset(deltaTime)
	self.realY = self.realY + dist
	self:handleAndMoveBoundedUnits(0, dist)
end

function Platform:updateHorizontalMovement(deltaTime)
	local dist = self:getDistUpdateOffset(deltaTime)
	self.realX = self.realX + dist
	self:handleAndMoveBoundedUnits(dist, 0)
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
		self.realX - self.realWidth/2 - camera.x,
		self.realY - self.realHeight/2 - camera.y,
		self.realWidth, self.realHeight)
end