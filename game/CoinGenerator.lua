require "class"

local CountdownTime = 1
local CoinsMin = 7
local CoinsMax = 14

CoinGenerator = class:new()

function CoinGenerator:init()
	self.coins = math.random(CoinsMin, CoinsMax)
	self.initCoins = self.coins
	
	-- more coins => faster coin reduction
	self.countdownTime = 
		CountdownTime * (CoinsMin / self.coins)
	
	self.timer = self.countdownTime
end

function CoinGenerator:shouldBeDestroyed()
	return self.coins <= 1
end

function CoinGenerator:extractCoin()
	self.coins = self.coins - 1
	self.timer = self.countdownTime
	return self
end

function CoinGenerator:update(deltaTime)
	self.timer = self.timer - deltaTime
	
	if self.timer < 0 then
		if self.coins > 1 then
			self:extractCoin()
		end
	end
end

-- COIN PARTICLE UPDATE, USED IN WORLD.LUA
function CointParticleUpdate(particle, camera, deltaTime, userData)
	local nTexs = #particle.userData.textures
	-- Make the swapping twice faster
	local timer = math.fmod(particle.timer / (particle.endTime/3), 1)
	particle.texture = particle.userData.textures[1+math.floor(nTexs * timer)]
end