require "Unit"

local JumperKeepIdleAnimTime = 0.4

Jumper = Unit:new()

function Jumper:init(x, y, tileWidth, tileHeight, idleAnim, jumpingAnim)
	self:super("jumper", x, y, tileWidth, tileHeight,
		UnitJumpingVelRecommended * 2, 1, idleAnim, nil, jumpingAnim)
	
	self.keepIdleAnimTimer = 0
end

function Jumper:instantDeath(particleSystem, height)
	if height == nil then
		height = self.height
	end
	
	particleSystem:addUnitSmashFallEffect(self.activeAnim:getActiveTexture(),
		self.x, self.y - self.height/2 + height, self.width, height, 
		self.isFacingLeft)
	
	self.dead = true
end

function Jumper:hurt(type, particleSystem)
	if type == "step_on" then
		self:instantDeath(particleSystem, self.height/4)
	else
		self:instantDeath(particleSystem)
	end
end

function Jumper:tryToJumpNoTimer()
	if self.isFalling == false and self.isJumping == false then
		self.keepIdleAnimTimer = JumperKeepIdleAnimTime
	end
	self:superTryToJumpNoTimer()
end

function Jumper:updateAnimations(deltaTime)
	self:resetInactiveAnimations()
	
	if (self.isJumping or self.isFalling) 
		and self.keepIdleAnimTimer <= 0 then
		self.activeAnim = self.jumpingAnim
	else
		self.activeAnim = self.idleAnim
	end
	
	self.activeAnim:update(deltaTime)
end

function Jumper:update(deltaTime, gravityAcc, particleSystem,
	camera, soundContainer)
	
	if self.keepIdleAnimTimer > 0 then
		self.keepIdleAnimTimer = self.keepIdleAnimTimer - deltaTime
	end
	
	self:superUpdate(deltaTime, gravityAcc, particleSystem,
		camera, soundContainer)
	
	self:tryToJumpNoTimer()
end