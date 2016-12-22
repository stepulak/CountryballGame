require "ActiveObject"
require "CanonBall"

local CanonAboutToShootQuotient = 0.2

Canon = ActiveObject:new()

-- Canon constructor
-- Remember, the x parameter is the left x position of the canon 
-- no matter of it's direction!
function Canon:init(x, y, tileWidth, tileHeight, leftDir, 
	shootingCountdown, canonAnim)
	
	self:super("canon", x, y, 2, 1, tileWidth, tileHeight)
	
	self.unitContainer = unitContainer
	self.leftDir = leftDir
	
	self.canonAnim = canonAnim:getCopy()
	self.canonAnim.updateTime = shootingCountdown * 
		CanonAboutToShootQuotient / canonAnim:numTextures()
	
	self.shootingCountdown = shootingCountdown
	self.countdown = shootingCountdown
	self.shouldSpawnNewCanonBall = false
	
	self.tileWidth = tileWidth
	self.tileHeight = tileHeight
end

function Canon:canBeBounded()
	-- You cannot bound another unit to the canon
	return false
end

function Canon:handleUnitCollision(unit, deltaTime)
	if unit.name == "canonball" then
		-- Let it pass
		return
	end
	
	if self:checkUnitCollision(unit) then
		unit:resolveRectCollision(self.realX, self.realY, 
			self.realWidth, self.realHeight, deltaTime)
	end
end

-- Canon function only!
-- If the world should spawn new canon ball
-- then this function returns it's position [x,y]
-- otherwise it returns nil, nil
function Canon:spawnNewCanonBall()
	if self.shouldSpawnNewCanonBall == false then
		return nil, nil
	else
		self.shouldSpawnNewCanonBall = false
		if self.dirLeft then
			return self.realX - self.realWidth/2 + self.tileWidth, self.realY
		else
			return self.realX + self.realWidth/2 - self.tileWidth, self.realY
		end
	end
end

function Canon:update(camera, particleSystem, deltaTime)
	self.countdown = self.countdown - deltaTime
	
	if self.countdown < self.shootingCountdown * CanonAboutToShootQuotient then
		self.canonAnim:update(deltaTime)
		
		if self.countdown < 0 then
			self.countdown = self.shootingCountdown
			self.shouldSpawnNewCanonBall = true
		end
	end
end

function Canon:draw(camera, drawFrameCounter)
	self.drawFrameCounter = drawFrameCounter
	
	self.canonAnim:draw(camera, self.realX - self.realWidth/2, 
		self.realY - self.realHeight/2, self.realWidth, self.realHeight,
		0, self.leftDir)
end