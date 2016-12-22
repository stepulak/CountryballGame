require "ActiveObject"

local TrampolinePlatformMaxQ = 0.8

Trampoline = ActiveObject:new()

function Trampoline:init(x, y, tileWidth, tileHeight, platformTex)
	self:super("trampoline", x, y, 1, 1, tileWidth, tileHeight)
	
	self.platformTex = platformTex
	self.platformOffset = 0
	self.boundedUnit = nil
end

function Trampoline:boundUnit(unit)
	self.boundedUnit = unit
	unit.onTrampoline = true
end

function Trampoline:canBeBounded(unit, deltaTime)
	if self.boundedUnit ~= nil then
		-- There is already bounded some other unit
		return false
	end
	
	-- Is the unit standing right on the platform?
	local distAfter = unit.y + unit.height/2 - 
		(self.realY - self.realHeight/2)
	local distBefore = distAfter - unit.verticalVel * deltaTime
	
	return distAfter > 0 and distBefore < 0
end

function Trampoline:isAlreadyBounded(unit)
	return self.boundedUnit == unit
end

function Trampoline:handleUnitCollision(unit, deltaTime)
	if self:checkUnitCollision(unit) then
		-- They have collided
		unit:resolveRectCollision(self.realX, self.realY, 
			self.realWidth, self.realHeight, deltaTime)
	end
end

function Trampoline:update(camera, particleSystem, deltaTime)
	if self.boundedUnit ~= nil then
		
		self.platformOffset = (self.boundedUnit.y 
			+ self.boundedUnit.height/2 - (self.realY - self.realHeight/2))
		
		if self.platformOffset < 0 then
			self.platformOffset = 0
		end
		
		-- Continuesly decrease unit's falling velocity
		if self.boundedUnit.isFalling then
			self.boundedUnit.verticalVel = self.boundedUnit.verticalVel * 43 * deltaTime
		end
		
		if self.platformOffset >= self.realHeight * TrampolinePlatformMaxQ then
			self.platformOffset = self.realHeight * TrampolinePlatformMaxQ
			-- Push the unit into the air
			self.boundedUnit:stopFalling()
			self.boundedUnit:tryToJumpNoTimer()
		end
	
		-- Not jumping on trampoline anymore? Unbound it
		if self:checkUnitCollision(self.boundedUnit) == false then
			self.boundedUnit.onTrampoline = false
			self.boundedUnit = nil
			self.platformOffset = 0
		end
	else
		self.platformOffset = 0
	end
end

function Trampoline:draw(camera, drawFrameCounter)
	self.drawFrameCounter = drawFrameCounter
	
	-- Draw legs of the trampoline
	local height = (self.realHeight - self.platformOffset)/2
	local legSize = self.realHeight * 0.7
	local horizontaOffset = self.realWidth/10
	local distBetween = math.sqrt(legSize*legSize - height*height)
	
	love.graphics.push()
	love.graphics.translate(self.realX - camera.x, self.realY - camera.y)
	love.graphics.setLineWidth(3)
	
	-- top right
	love.graphics.line(horizontaOffset, -self.realHeight/2 + self.platformOffset,
		horizontaOffset + distBetween/2, self.realHeight/2 - height)
	
	-- top left
	love.graphics.line(-horizontaOffset, -self.realHeight/2 + self.platformOffset,
		-horizontaOffset - distBetween/2, self.realHeight/2 - height)
	
	-- bottom right
	love.graphics.line(horizontaOffset, self.realHeight/2, 
		horizontaOffset + distBetween/2, self.realHeight/2 - height)
	
	-- bottom left
	love.graphics.line(-horizontaOffset, self.realHeight/2, 
		-horizontaOffset - distBetween/2, self.realHeight/2 - height)
	
	love.graphics.setLineWidth(1)
	love.graphics.pop()
	
	-- And the platform 
	drawTex(self.platformTex, self.realX - self.realWidth/2 - camera.x,
		self.realY - self.realHeight/2 + self.platformOffset - camera.y - 4,
		self.realWidth, self.realHeight*0.1)
end