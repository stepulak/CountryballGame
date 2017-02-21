require "Unit"

local TryJumpTimeMax = 5
local TryJumpTimeMin = 2
local AttackProbabilityQ = 1

Hammerman = Unit:new()

function Hammerman:init(x, y, tileWidth, tileHeight, 
	idleAnim, attackAnim)
	
	self:super("hammerman", x, y, tileWidth, tileHeight,
		UnitJumpingVelRecommended * 1.5, 1, idleAnim, nil, 
		nil, nil, attackAnim)
	
	self.jumpTimer = 0
	self.projectileFired = false
	self.attackTimer = 0
end

function Hammerman:instantDeath(particleSystem, soundContainer)
	particleSystem:addUnitSmashFallEffect(self.activeAnim:getActiveTexture(),
		self.x, self.y, self.width, self.height, self.isFacingLeft, 180)
		
	self.dead = true
end

function Hammerman:hurt(type, particleSystem, soundContainer)
	self:instantDeath(particleSystem)
	self:playStdHurtEffect(type, soundContainer)
end

function Hammerman:getCreatedProjectile()
	if self.projectileFired then
		self.projectileFired = false
		
		return "hammer",
			self.x + (self.isFacingLeft and -self.width/2 or self.width/2),
			self.y - self.height/6, 20, self.isFacingLeft, false
	else
		return nil
	end
end

-- Hammerman function only!
function Hammerman:updateJumping(deltaTime, player)
	self.jumpTimer = self.jumpTimer - deltaTime
	
	if self.jumpTimer <= 0 then
		self.jumpTimer = math.random(TryJumpTimeMin,
			TryJumpTimeMax)
		
		if player.y < self.y or math.random() <= 0.5 then
			self:tryToJumpNoTimer()
		else
			self:tryToJumpOffPlatform()
		end
	end
end

-- Hammerman function only!
function Hammerman:updateAccordingToPlayer(deltaTime, player,
	camera, soundContainer)
	
	self:updateJumping(deltaTime, player)
	
	-- Set the hammerman's looking on player
	self.isFacingLeft = player.x <= self.x
	
	if self:isInsideCamera(camera) and 
		player:isInsideCamera(camera) and
		self.isJumping == false and 
		self.isFalling == false then
		
		-- You can try to shoot now
		if self.attackTimer <= 0 and
			math.random() < deltaTime * AttackProbabilityQ then
			self.projectileFired = true
			-- Last as long as the animation does
			self.attackTimer = self.attackAnim:numTextures() *
				self.attackAnim.updateTime
				
			soundContainer:playEffect("canon_shot")
		end
	end
end

function Hammerman:updateAnimations(deltaTime)
	self:resetInactiveAnimations()
	self.activeAnim = self.attackTimer > 0 and self.attackAnim or self.idleAnim
	self.activeAnim:update(deltaTime)
end

function Hammerman:update(deltaTime, gravityAcc, particleSystem,
	camera, soundContainer)
	
	-- Unavailable for next attack
	if self.attackTimer > 0 then
		self.attackTimer = self.attackTimer - deltaTime
	end
	
	self:superUpdate(deltaTime, gravityAcc, particleSystem,
		camera, soundContainer)
end