require "Unit"

local StayTimeMax = 5
local VelocityBase = 300
local VelocityDecc = 150

FlyingZombie = Unit:new()

function FlyingZombie:init(x, y, tileWidth, tileHeight, idleAnim)
	self:super("flying_zombie", x, y,
		tileWidth * 1.5, tileHeight,
		0, 1, idleAnim)
	
	self.directionUp = true
	self.stayTimer = 0
	self.verticalVel = VelocityBase
end

-- When this function is called with no specified height, then
-- the height is nil by default...
function FlyingZombie:instantDeath(particleSystem, soundContainer, height)
	if height == nil then
		height = self.height
	end
	
	particleSystem:addUnitSmashFallEffect(self.activeAnim:getActiveTexture(),
		self.x, self.y - self.height/2 + height, self.width, height, 
		self.isFacingLeft)
	
	self.dead = true
end

function FlyingZombie:hurt(type, particleSystem, soundContainer)
	if type == "step_on" then
		self:instantDeath(particleSystem, soundContainer, self.height/6)
	else
		self:instantDeath(particleSystem, soundContainer)
	end
	self:playStdHurtEffect(type, soundContainer)
end

function FlyingZombie:updateAnimations(deltaTime)
	self.activeAnim = self.idleAnim
	self.activeAnim:update(deltaTime)
end

function FlyingZombie:updateVerticalMovement(deltaTime)
	if self.verticalVel > 0 then
		self.verticalVel = self.verticalVel - VelocityDecc * deltaTime
	end
	
	if self.verticalVel <= 0 and self.stayTimer <= 0 then
		self.verticalVel = 0
		self.stayTimer = math.random(1, StayTimeMax)
	end
end

function FlyingZombie:updateMovement(deltaTime)
	if self.stayTimer > 0 then
		self.stayTimer = self.stayTimer - deltaTime
		
		if self.stayTimer <= 0 then
			-- Reset vertical velocity
			self.verticalVel = VelocityBase
			-- Change direction for future movement
			self.directionUp = not self.directionUp
		end
	end
end

function FlyingZombie:update(deltaTime, gravityAcc, particleSystem,
	camera, soundContainer)
	
	self:superUpdate(deltaTime, gravityAcc, particleSystem,
		camera, soundContainer)
		
	self:updateMovement(deltaTime)
	self.isJumping = self.directionUp
	self.isFalling = not self.directionUp
end