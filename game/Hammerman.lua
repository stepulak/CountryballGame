require "Unit"

local HammermanTryJumpTimeMax = 5
local HammermanTryJumpTimeMin = 2
local HammermanAttackProbabilityQ = 1

Hammerman = Unit:new()

function Hammerman:init(x, y, tileWidth, tileHeight, 
	idleAnim, jumpingAnim, attackingAnim)
	
	self:super("hammerman", x, y, tileWidth, tileHeight,
		UnitJumpingVelRecommended * 1.5, 1, idleAnim, nil, 
		jumpingAnim, nil, attackingAnim)
	
	self.jumpingTimer = 0
	self.projectileFired = false
	self.attackingTimer = 0
end

function Hammerman:instantDeath(particleSystem)
	particleSystem:addUnitSmashEffect(self.activeAnim:getActiveTexture(),
		self.x, self.y, self.width, self.height, self.isFacingLeft, 180)
		
	self.dead = true
end

function Hammerman:hurt(type, particleSystem)
	self:instantDeath(particleSystem)
end

function Hammerman:getCreatedProjectile()
	if self.projectileFired then
		self.projectileFired = false
		
		return "hammer",
			self.x + (self.isFacingLeft and -self.width/2 or self.width/2),
			self.y - self.height/3, 20, self.isFacingLeft, false
	else
		return nil
	end
end

-- Hammerman function only!
function Hammerman:updateJumping(deltaTime, player)
	self.jumpingTimer = self.jumpingTimer - deltaTime
	
	if self.jumpingTimer <= 0 then
		self.jumpingTimer = math.random(HammermanTryJumpTimeMin,
			HammermanTryJumpTimeMax)
		
		if player.y < self.y or math.random() <= 0.5 then
			self:tryToJumpNoTimer()
		else
			self:tryToJumpOffPlatform()
		end
	end
end

-- Hammerman function only!
function Hammerman:updateAccordingToPlayer(deltaTime, player, camera)
	self:updateJumping(deltaTime, player)
	
	-- Change the hammer looking direction directly on player
	self.isFacingLeft = player.x <= self.x
	
	if self:isInsideCamera(camera) and 
		player:isInsideCamera(camera) and
		self.isJumping == false and 
		self.isFalling == false then
		
		-- You can try to shoot now
		if math.random() < deltaTime * HammermanAttackProbabilityQ then
			self.projectileFired = true
			self.attackingTimer = 0.2
		end
	end
end

function Hammerman:updateAnimations(deltaTime)
	self:resetInactiveAnimations()
	
	if self.isJumping or self.isFalling then
		self.activeAnim = self.jumpingAnim
	elseif self.attackingTimer > 0 then
		self.activeAnim = self.attackingAnim
	else
		self.activeAnim = self.idleAnim
	end
	
	self.activeAnim:update(deltaTime)
end

function Hammerman:update(deltaTime, gravityAcc, particleSystem,
	camera, soundContainer)
	
	self:superUpdate(deltaTime, gravityAcc, particleSystem,
		camera, soundContainer)
end