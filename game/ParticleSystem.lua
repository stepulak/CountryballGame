require "class"
require "Particle"

ParticleSystem = class:new()

function ParticleSystem:init()
	self.numActiveParticles = 0
	self.pool = {}
end

-- Reserve new particle in particle pool
-- Create a new one if all are unavailable
function ParticleSystem:reserveNewParticle()
	if self.pool[self.numActiveParticles] == nil then
		self.pool[self.numActiveParticles] = Particle:new()
	end
	self.numActiveParticles = self.numActiveParticles + 1
	return self.pool[self.numActiveParticles - 1]
end

function ParticleSystem:addBrokenWallEffect(texture, x, y, 
	width, height, dirLeft)
	
	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height,
		0, 0, false,
		0,
		(dirLeft and 115 or 65), 0,
		height*15, 0,
		0.15,
		false, false, -1,
		nil, "broken_wall")
end

function ParticleSystem:addCloudParticle(texture, x, y, 
	width, height, dirLeft, userUpdate)
	
	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height,
		0, 0, false,
		0,
		(dirLeft and 180 or 0), 0,
		2 + math.random() * 5, 0,
		-1,
		false, true, 5,
		userUpdate, "cloud")
end

function ParticleSystem:addSnowParticle(texture, x, y,
	width, height, userUpdate)
	
	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height,
		0, 10, false,
		0,
		250 + math.random() * 40, 0,
		100, 0,
		-1,
		false, false, 0,
		userUpdate, "snow")
end

function ParticleSystem:addRainParticle(texture, x, y, 
	width, height, userUpdate)
	
	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height,
		15, 0, false,
		0,
		255, 0,
		1000, 0,
		-1,
		false, false, 0,
		userUpdate, "rain")
end

function ParticleSystem:addBubbleParticle(texture, x, y, width, height, time)
	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height,
		0, 0, false,
		0.5,
		90 + math.random(-45, 45), 0,
		100, 0,
		time,
		true, true, time/5)
end

function ParticleSystem:addSmokeParticle(texture, x, y, width, height,
	dirAngle, time)
	
	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height,
		0, 180 * math.random(), false,
		0.3,
		dirAngle, 0,
		50,	0,
		time,
		true, false, time/5)
end

function ParticleSystem:addStarParticle(texture, x, y, width, height,
	dirAngle)
	
	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height, 
		0, 360, false,
		0.8,
		dirAngle, 0,
		500, 0,
		0.3,
		true, true, 0.1)
end

function ParticleSystem:addCoinEffect(texture, x, y,
	width, height, userUpdate, userData)

	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height,
		0, 0, false,
		0,
		90, 0,
		700, 0,
		0.3,
		true, false, 0.3,
		userUpdate, userData)
end

function ParticleSystem:addUnitDirectedFallEffect(texture, x, y, 
	width, height, leftDir, vel)
	
	self:addUnitRotationFallEffect(texture, x, y, width, height,
		vel*1.8, 0, 0, leftDir)
end

function ParticleSystem:addUnitRotationFallEffect(texture, x, y,
	width, height, vel, texAngle, texAngleVel, leftDir)
	
	local angle, angleVel
	
	if leftDir then
		angle = 235
		angleVel = 40
	else
		angle = 315
		angleVel = -40
	end
	
	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height,
		texAngle, texAngleVel, leftDir,
		0,
		angle, angleVel,
		vel, 300,
		1,
		true, false, 0.5)
end

-- @texAngle and @dirAngle can be nil (not set)
function ParticleSystem:addUnitSmashFallEffect(texture, x, y,
	width, height, texDirLeft, texAngle, dirAngle)
	
	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height, 
		texAngle or 0, 0, texDirLeft,
		0,
		dirAngle or 270, 0,
		0, 800,
		1,
		true, false, 0.5)
end

function ParticleSystem:addUnitSmashStaticEffect(texture, x, y,
	width, height, texDirLeft, time)
	
	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height,
		0, 0, texDirLeft,
		0,
		0, 0,
		0, 0,
		time,
		false, false, 0)
end

-- @userUpdate must be set
function ParticleSystem:addPlayersFallEffect(texture, x, y, 
	width, height, userUpdate)

	self:reserveNewParticle():fill(
		texture, x, y,
		width, height,
		0, 0, false,
		0,
		90,	0,
		1000, -2000,
		-1,
		false, false, 0,
		userUpdate, "up")
end

function ParticleSystem:addTextureFadeOutEffect(texture, x, y, width, height)
	self:reserveNewParticle():fill(texture,
		x, y,
		width, height,
		0, 0, false,
		0,
		0, 0,
		0, 0,
		0.5,
		true, false, 0.5)
end

function ParticleSystem:addFrozenUnitEffect(texture, x, y, width, height,
	time)
	
	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height,
		0, 0, false,
		0,
		0, 0,
		0, 0,
		time,
		true, true, time/10)
end

-- @dir = nil, "left", "right"
function ParticleSystem:addFallingRotatingObject(texture, x, y, 
	width, height, dir, time)
	local angle = 270
	local angleVel = 0
	
	if dir == "left" then
		angle = angle - 40
		angleVel = 40
	elseif dir == "right" then
		angle = angle + 40
		angleVel = -40
	end
	
	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height,
		0, 600, false,
		0,
		angle, angleVel,
		500, 600,
		time,
		true, false, 0.5)
end

-- See AnimationScene.lua
-- @fadeType = "in", "out", "both", "none"
function ParticleSystem:addSlideParticle(texture, x, y, width, height,
	angle, vel, propVelQ, fadeType, endTime, userData, userUpdate)
	
	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height,
		0, 0, false,
		propVelQ,
		angle, 0,
		vel, 0,
		endTime,
		fadeType == "out" or fadeType == "both",
		fadeType == "in" or fadeType == "both",
		1,
		userUpdate, userData)
end

-- Update particles (movement, behaviour, etc.)
function ParticleSystem:update(camera, deltaTime, sinCosTable, userData)
	local i = 0
	while i < self.numActiveParticles do
		self.pool[i]:update(camera, deltaTime, sinCosTable, userData)
		
		if self.pool[i].isFree then
			-- Are there atleast 2 particles in the pool?
			-- (One to free and atleast one is still active)
			if self.numActiveParticles > 1 and 
				i+1 < self.numActiveParticles then
				-- Swap 'em
				self.pool[i], self.pool[self.numActiveParticles-1] =
					self.pool[self.numActiveParticles-1], self.pool[i]
				i = i - 1
			end
			self.numActiveParticles = self.numActiveParticles - 1
		end
		i = i + 1
	end
end

-- Draw all particles in particle system
function ParticleSystem:draw(camera)
	love.graphics.push()
	love.graphics.translate(-camera.x, -camera.y)
	
	for i = 0, self.numActiveParticles-1 do
		self.pool[i]:draw()
	end
	
	love.graphics.pop()
end