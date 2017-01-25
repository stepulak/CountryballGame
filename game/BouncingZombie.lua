require "Unit"

local BouncingZombieRotationVel = 225

BouncingZombie = Unit:new()

function BouncingZombie:init(x, y, tileWidth, tileHeight, movementAnim)
	self:super("bouncing_zombie", x, y, tileWidth, tileHeight, 
		UnitJumpingVelRecommended * 1.5, UnitHorizontalVelRecommended,
		nil, movementAnim)
	
	self.texAngle = 0
	self.activeAnim = movementAnim
end

function BouncingZombie:instantDeath(particleSystem, soundContainer)
	particleSystem:addUnitSmashRotationEffect(
		self.activeAnim:getActiveTexture(), self.x, self.y,
		self.width, self.height, self:getOverallVelocity(),
		self.texAngle, BouncingZombieRotationVel,
		self.isFacingLeft)
	
	self.dead = true
end

-- Bouncing Zombie only!
function BouncingZombie:smash(particleSystem)
	local height = self.height/5
	
	particleSystem:addUnitSmashEffect(self.activeAnim:getActiveTexture(),
		self.x, self.y - self.height/2 + height, self.width, height,
		self.isFacingLeft)
	
	self.dead = true
end

function BouncingZombie:kill(type, particleSystem, soundContainer)
	self:instantDeath(particleSystem, soundContainer)
	self:playStdHurtEffect(type, soundContainer)
end

function BouncingZombie:hurt(type, particleSystem, soundContainer)
	if type == "step_on" then
		self:smash(particleSystem, soundContainer)
	elseif type == "projectile_left" then
		-- change it's direction to "follow" the projectile direction
		self.isFacingLeft = false
		self:kill(type, particleSystem, soundContainer)
	elseif type == "projectile_right" then
		-- change it's direction to "follow" the projectile direction
		self.isFacingLeft = true
		self:kill(type, particleSystem, soundContainer)
	else
		self:instantDeath(particleSystem, soundContainer)
	end
end

function BouncingZombie:updateAnimations(deltaTime)
	self.activeAnim = self.movementAnim
	self.activeAnim:update(deltaTime)
end

function BouncingZombie:update(deltaTime, gravityAcc, particleSystem,
	camera, soundContainer)
	
	self:reverseDirectionAccordingToCollision()
	self:tryToJumpNoTimer()
	self:moveHorizontally(self.isFacingLeft)
	
	self:superUpdate(deltaTime, gravityAcc, particleSystem, 
		camera, soundContainer)
	
	local a = BouncingZombieRotationVel * deltaTime
	
	if self.isFacingLeft then
		self.texAngle = self.texAngle - a
	else
		self.texAngle = self.texAngle + a
	end
	
	self.texAngle = math.fmod(self.texAngle, 360)
end

function BouncingZombie:draw(camera)
	self:superDraw(camera, self.texAngle)
end