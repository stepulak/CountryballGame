require "Unit"

local PushHorTimeMax = 3
local PushVerTimeMax = 0.2

Fish = Unit:new()

function Fish:init(x, y, tileWidth, tileHeight, movementAnim)
	self:super("fish", x, y, tileWidth, tileHeight, 
		UnitJumpingVelRecommended, UnitHorizontalVelRecommended/2,
		nil, movementAnim)
	
	-- Lower it's "friction"
	self.horizontalDec = 300
	-- Even in water
	self.waterPenaltyQ = 1
	self.isSteppable = false

	self.pushHorTimer = 0
	self.pushVerTimer = 0
	
	self.activeAnim = movementAnim
end

function Fish:instantDeath(particleSystem, soundContainer)
	particleSystem:addUnitSmashFallEffect(self.activeAnim:getActiveTexture(),
		self.x, self.y, self.width, self.height, self.isFacingLeft, 180)
		
	self.dead = true
end

function Fish:hurt(type, particleSystem, soundContainer)
	self:instantDeath(particleSystem, soundContainer)
	self:playStdHurtEffect(type, soundContainer)
end

-- Fish function only!
-- Swim a little bit in horizontal direction
function Fish:pushHorizontal()
	self.pushHorTimer = math.random(0, PushHorTimeMax)
	self.isFacingLeft = math.random(0, 1) == 1
end

-- Fish function only!
-- Swim a little bit in vertical direction
function Fish:pushVertical()
	self.pushVerTimer = math.random(0, PushVerTimeMax)
	
	if math.random(0, 1) == 1 then
		-- Jump
		self:tryToJumpNoTimer()
	else
		-- Fall
		self:stopJumping()
		self:startFalling()
	end
end

-- Fish function only!
-- Logic of movement inside water
function Fish:updateFishMovement(deltaTime)
	self.pushHorTimer = self.pushHorTimer - deltaTime
	self.pushVerTimer = self.pushVerTimer - deltaTime
	
	if self.pushHorTimer > 0 or self.pushVerTimer > 0 then
		if self.pushVerTimer <= 0 then
			self.isJumping = false
			self.isFalling = false
			self.verticalVel = 0
		end
		
		if self.pushHorTimer > 0 then
			self:moveHorizontally(self.isFacingLeft)
		end
	else
		self:pushHorizontal()
		self:pushVertical()
	end
end

function Fish:updateAnimations(deltaTime)
	self.activeAnim = self.movementAnim
	
	if self.insideWater == false then
		-- The fish has jumped out of the water and it's gasping for air
		-- Make the animation super fast
		self.activeAnim:update(deltaTime * 6)
	elseif self.horizontalVel >= self.horizontalVelBase/3 then
		self.activeAnim:update(deltaTime)
	else
		self.activeAnim:reset()
	end
end

function Fish:update(deltaTime, gravityAcc, particleSystem,
	camera, soundContainer)
	
	self:superUpdate(deltaTime, gravityAcc/5, particleSystem,
		camera, soundContainer)
	
	if self.insideWater then
		self:updateFishMovement(deltaTime)
	else
		self:startFalling()
	end
end