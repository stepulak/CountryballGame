require "Unit"

local RocketSmokeParticleSize = 20
local RocketParticleCreationTime = 0.05
local RocketVerticalAcc = 100
local RocketShakingVel = 100
local RocketShakingMaxDec = -2

Rocket = Unit:new()

function Rocket:init(x, y, tileWidth, tileHeight, anim, smokeTex)
	self:super("rocket", x, y, tileWidth * 3, tileHeight * 5,
		0, 0, anim)
	
	self.isFacingLeft = false
	self.smokeTex = smokeTex
	self.friendlyToPlayer = true
	
	self.started = false
	self.timer = 0
	
	-- Minimum y to dissappear
	self.rocketMinY = -200
	
	self.shakingAngle = 0
	self.shakingAngleMax = 10
	self.shakingDir = -1
end

function Rocket:updateAnimations(deltaTime)
	self.activeAnim = self.idleAnim
	self.activeAnim:update(deltaTime)
end

function Rocket:updateVerticalMovement(deltaTime, gravityAcc)
	if self.started then
		-- Increase vertical velocity continously
		self.verticalVel = self.verticalVel + RocketVerticalAcc * deltaTime
		
		-- Sounds funny but only with this indicator 
		-- world can process movement upwards
		self.isJumping = true
		self.isFalling = false
	end
end

-- Rocket function only!
function Rocket:updateSmoke(deltaTime, particleSystem)
	self.timer = self.timer + deltaTime
	
	-- Create smoke from engines
	if self.timer >= RocketParticleCreationTime then
		local numParticles = self.timer / RocketParticleCreationTime
		
		for i = 1, numParticles do
			particleSystem:addSmokeParticle(self.smokeTex, 
				self.x, self.y + self.height/2, 
				RocketSmokeParticleSize, RocketSmokeParticleSize,
				270 + math.random(-25, 25), 4)
		end
		
		self.timer = 0
	end
end

-- Rocket function only!
function Rocket:updateShaking(deltaTime)
	self.shakingAngleMax = self.shakingAngleMax +
		RocketShakingMaxDec * deltaTime
	
	-- Shaking effect
	if math.floor(self.shakingAngleMax) > 0 then
		self.shakingAngle = self.shakingAngle + 
			RocketShakingVel * self.shakingDir * deltaTime
		
		if math.abs(self.shakingAngle) >= self.shakingAngleMax then
			-- Do not overflow from the limit
			self.shakingAngle = self.shakingDir * self.shakingAngleMax
			-- Reverse shaking dir
			self.shakingDir = -self.shakingDir
		end
	else
		self.shakingAngle = 0
	end
end

-- Rocket function only!
-- Rocket is in IDLE mode until it's started with this function
function Rocket:startRocket()
	self.started = true
end

function Rocket:update(deltaTime, gravityAcc, particleSystem, camera)
	self:superUpdate(deltaTime, gravityAcc, particleSystem, camera)
	
	if self.started then
		self:updateShaking(deltaTime)
		self:updateSmoke(deltaTime, particleSystem)
	end
end

function Rocket:draw(camera)
	self:superDraw(camera, self.shakingAngle)
end