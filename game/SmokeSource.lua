require "ActiveObject"

local SmokeSourceNewParticleTime = 0.5

SmokeSource = ActiveObject:new()

function SmokeSource:init(x, y, tileWidth, tileHeight, smokeParticleTex)
	self:super("smoke_source", x, y, 1, 1, tileWidth, tileHeight)
	
	self.smokeParticleTex = smokeParticleTex
	self.timer = 0
end

function SmokeSource:update(camera, particleSystem, deltaTime)
	self.timer = self.timer + deltaTime
	
	if self.timer >= SmokeSourceNewParticleTime then
		self.timer = self.timer - SmokeSourceNewParticleTime
		
		-- Create new smoke particle
		local size = math.random(10, 30)
		local angle = math.random(75, 105)
		
		particleSystem:addSmokeParticle(self.smokeParticleTex,
			self.realX, self.realY, size, size, angle, 2.5)
	end
end