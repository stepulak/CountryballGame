require "ActiveObject"
require "CanonBall"

local ShootingDuration = 0.8
local IdleDuration = 3

Canon = ActiveObject:new()

-- Canon constructor
-- Remember, the x parameter is the left x position of the canon 
-- no matter of it's direction!
function Canon:init(x, y, tileWidth, tileHeight, leftDir, idleAnim, shootAnim)
	self:super("canon", x, y, 2, 1, tileWidth, tileHeight)
	
	self.unitContainer = unitContainer
	self.leftDir = leftDir
	
	
	self.idleAnim = idleAnim:getCopy()
	self.shootAnim = shootAnim:getCopy()
	self.shootAnim.updateTime = ShootingDuration / shootAnim:numTextures()
	self.timer = 0
	
	self.isShooting = false
	self.activeAnim = self.idleAnim
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
function Canon:spawnNewCanonBall(soundContainer)
	if self.shouldSpawnNewCanonBall == false then
		return nil, nil
	else
		self.shouldSpawnNewCanonBall = false
		
		-- Create 3D sound effect
		soundContainer:playEffect("canon_shot", false, self.realX, self.realY)
		
		if self.leftDir then
			return self.realX - self.realWidth/2, self.realY
		else
			return self.realX + self.realWidth/2, self.realY
		end
	end
end

function Canon:getDir()
	return self.leftDir and "left" or "right"
end

function Canon:update(camera, particleSystem, deltaTime)
	self.activeAnim = self.isShooting and self.shootAnim or self.idleAnim
	self.timer = self.timer + deltaTime
	
	if self.isShooting == false and self.timer > IdleDuration then
		self.isShooting = true
		self.timer = 0
	elseif self.isShooting and self.timer > ShootingDuration then
		self.timer = 0
		self.isShooting = false
		self.shouldSpawnNewCanonBall = true
		self.activeAnim:reset()
	end
	
	self.activeAnim:update(deltaTime)
end

function Canon:draw(camera, drawFrameCounter)
	self.drawFrameCounter = drawFrameCounter
	
	self.activeAnim:draw(camera,
		self.realX - self.realWidth/2, 
		self.realY - self.realHeight/2,
		self.realWidth, self.realHeight,
		0, self.leftDir)
end