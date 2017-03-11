require "class"

local VerticalVelMax = 600
local HorizontalVelMax = 500
local FadeTime = 0.25
local LifeTime = 3

-- Projectile = small and fast entity
-- which kills units and may bounce etc...
Projectile = class:new()

-- Projectile constructor
-- @type ... fireball, iceball, hammer
-- @byPlayer ... true if it's fired by player, otherwise false
function Projectile:init(type, x, y, size, dirLeft, byPlayer, anim)
	self.type = type 
	self.x = x
	self.y = y
	self.size = size
	self.texAngle = 0
	self.anim = anim:getCopy()
	self.byPlayer = byPlayer
	
	self.verticalVel = 0
	self.horizontalVel = HorizontalVelMax
	self.velocityReduction = 1
	
	if type == "hammer" then
		self.horizontalVel = self.horizontalVel
	end
	
	self.isMovingLeft = dirLeft
	self.isFalling = true -- otherwise it's false for "rising"
	
	self.timer = LifeTime
	
	self.fading = false
	self.fadeTimer = FadeTime
end

function Projectile:tileCollisionEnabled()
	return self.type ~= "hammer"
end

function Projectile:fadeOut()
	self.fading = true
end

function Projectile:canBeRemoved()
	return self.fadeTimer <= 0
end

function Projectile:remove()
	self.fading = true
	self.fadeTimer = 0
end

function Projectile:moveSpecific(distX, distY)
	self.x = self.x + distX
	self.y = self.y + distY
end

function Projectile:reverseHorizontalDir()
	self.isMovingLeft = not self.isMovingLeft
end

function Projectile:reverseVerticalDir()
	self.isFalling = not self.isFalling
end

function Projectile:getHorizontalDist(deltaTime)
	return self.horizontalVel * deltaTime * (self.isMovingLeft and -1 or 1) /
		self.velocityReduction
end

function Projectile:getVerticalDist(deltaTime)
	return self.verticalVel * deltaTime * (self.isFalling and 1 or -1) /
		self.velocityReduction
end

function Projectile:setVelocityReduction(reduction)
	self.velocityReduction = reduction
end

-- Check whether this projectile lies inside world
function Projectile:isInsideWorld(camera)
	local s = self.size/2
	
	return self.x >= -s and self.x < camera.mapWidth - s
		and self.y >= -s and self.y < camera.mapHeight - s
end

function Projectile:updateVerticalVel(deltaTime, gravityAcc)
	if self.isFalling then
		self.verticalVel = self.verticalVel + gravityAcc * deltaTime
		
		if self.verticalVel > VerticalVelMax then
			self.verticalVel = VerticalVelMax
		end
	else
		-- "rising"
		self.verticalVel = self.verticalVel - gravityAcc * deltaTime
		
		if self.verticalVel <= 0 then
			self.verticalVel = 0
			self.isFalling = true
		end
	end
	
end

function Projectile:decreaseHorizontalVel(deltaTime)
	self.horizontalVel = self.horizontalVel - deltaTime * 200
	
	if self.horizontalVel < 0 then
		self.horizontalVel = 0
	end
end

function Projectile:update(deltaTime, gravityAcc)
	self.anim:update(deltaTime)
	self.texAngle = math.fmod(self.texAngle + 360 * deltaTime, 360)
	
	self:updateVerticalVel(deltaTime, gravityAcc)
	
	if self.type == "hammer" then
		self:decreaseHorizontalVel(deltaTime)
	end
	
	-- Timers
	
	-- Fading
	if self.fading then
		self.fadeTimer = self.fadeTimer - deltaTime
		
		if self.fadeTimer < 0 then
			self.fadeTimer = 0
		end
	end
	
	-- Life time
	if self.timer > 0 then
		self.timer = self.timer - deltaTime
		
		if self.timer < 0 then
			self.fading = true
		end
	end
end

function Projectile:draw(camera)
	love.graphics.setColor(255, 255, 255, 
		255 * (self.fadeTimer / FadeTime))
	
	self.anim:draw(camera, self.x - self.size/2, self.y - self.size/2,
		self.size, self.size, self.texAngle, false)
		
	love.graphics.setColor(255, 255, 255, 255)
end
