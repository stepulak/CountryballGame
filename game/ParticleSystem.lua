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

-- Add new particle imitating broken wall (super mario tile's crash)
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

-- Add new cloud
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

-- Add new snow flake
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

-- Add new rain drop
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

-- Add new bubble particle 
-- Used when unit is inside water (gasping for air "effect")
function ParticleSystem:addBubbleParticle(texture, x, y, width, height, time)
	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height,
		0, 0, false,
		5,
		90 + math.random(-45, 45), 0,
		100, 0,
		time,
		true, true, time/5)
end

-- Add smoke particle (particle is moving is specific direction)
-- and it's texture is rotating as well and it's proportions are increasing
function ParticleSystem:addSmokeParticle(texture, x, y, width, height,
	dirAngle, time)
	
	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height,
		0, 180 * math.random(), false,
		5,
		dirAngle, 0,
		50,	0,
		time,
		true, false, time/5)
end

-- Little star with high velocity moving directly from given position
function ParticleSystem:addStarParticle(texture, x, y, width, height,
	dirAngle)
	
	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height, 
		0, 360, false,
		2,
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

-- Add an effect representing unit's (death) fall in specific direction
-- This is called when some unit collides with spikes, lava etc...
function ParticleSystem:addUnitFallEffect(texture, x, y, 
	width, height, dirLeft, unitVel)
	
	local angle, angleVel
	
	if dirLeft then
		angle = 225
		angleVel = 40
	else
		angle = 315
		angleVel = -40
	end
	
	self:reserveNewParticle():fill(
		texture,
		x, y,
		width, height,
		0, 0, dirLeft,
		0,
		angle, angleVel,
		unitVel*1.8, 800,
		1, 
		true, false, 0.5)
end

-- Create an effect that imitates a unit's smash (or crash)
-- (into the wall or smashed by player's step)
-- @texAngle and @dirAngle can be nil (not set)
function ParticleSystem:addUnitSmashEffect(texture, x, y,
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

-- Create an static effect with given texture
-- This effect just last given time, nothing more...
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

-- Smashed unit with rotation in specified direction
function ParticleSystem:addUnitSmashRotationEffect(texture, x, y,
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

-- Add particle representing player's fall (death)
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

-- Add a simple effect that imitates a fading out tile...
function ParticleSystem:addTileFadeOutEffect(texture, x, y, width, height)
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
		0, 0, false, 0,
		0, 0,
		0, 0,
		time,
		true, true, time/10)
end

-- Create falling and rotation object
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

-- Update particles (movement, behaviour, etc.)
function ParticleSystem:update(camera, deltaTime, sinCosTable, userData)
	-- In Lua, you cannot use for cycle if you want to change the condition value
	-- during the loop, because the language itself stores the condition value in
	-- temporary variable, which is constant, immutable.
	
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
		self.pool[i]:draw(camera)
	end
	
	love.graphics.pop()
end