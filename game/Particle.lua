require "class"
require "Utils"

Particle = class:new()

-- Initialize empty particle
function Particle:init()
	self.texture = nil
	self.x = 0
	self.y = 0
	self.width = 0
	self.height = 0
	self.proportionsVel = 0
	self.texAngle = 0
	self.texAngleVel = 0
	self.texDrawFunc = drawTex
	self.dirAngle = 0
	self.dirAngleVel = 0
	self.vel = 0
	self.acc = 0
	self.timer = 0
	self.endTime = 0
	self.fadeOut = false
	self.fadeIn = false
	self.fadeTime = 0
	self.isFree = false
	self.userUpdate = nil
	self.userData = nil
end

-- Fill in data into particle. 
--
-- You see, we would rather avoid creating new tables, because is it 
-- a performance loss, especially for particles that are
-- created very often (like rain drops or snow flakes)
--
-- zero angle ... 3 o'clock
-- 90 degrees ... 12 o'clock
--
-- Monstrous function! But I believe it's better to do it in this way
-- than in :setTexture():setPosition():setProportions() way or
-- than passing a table with specified arguments - we would
-- have to always check if each argument is filled or not and that would cost
-- a huge performance, because this method is called many times per frame...
function Particle:fill(texture, 
	x, y,
	width, height,
	texAngle, texAngleVel, texFlipped,
	proportionsVel, 
	dirAngle, dirAngleVel,
	vel, acc,
	endTime,
	fadeOut, fadeIn, fadeTime,
	userUpdate, userData)
	
	self.texture = texture
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.proportionsVel = proportionsVel
	self.texAngle = texAngle
	self.texAngleVel = texAngleVel
	self.texDrawFunc = texFlipped and drawTexFlipped or drawTex
	self.proportionsVel = proportionsVel
	self.dirAngle = dirAngle
	self.dirAngleVel = dirAngleVel
	self.vel = vel
	self.acc = acc
	self.endTime = endTime
	self.fadeOut = fadeOut
	self.fadeIn = fadeIn
	self.fadeTime = fadeTime < 0 and endTime or fadeTime
	self.timer = 0
	self.isFree = false
	
	self.userUpdate = userUpdate
	self.userData = userData
	
	if fadeOut and fadeIn then
		if fadeTime >= endTime/2 then
			fadeTime = endTime/2
		end
	end
	
	return self
end

-- Update particle
-- Don't be confused with userData parameter - it is another parameter
-- different to particle.userData!
function Particle:update(camera, deltaTime, sinCosTable, userData)
	self.timer = self.timer + deltaTime
	
	-- Is particle infinity?
	if self.endTime >= 0 and self.timer >= self.endTime then
		-- It is not. You can reuse this particle in the future.
		self.isFree = true
		return true
	end

	self.texAngle = normalizeAngle(self.texAngle + self.texAngleVel*deltaTime)
	self.dirAngle = normalizeAngle(self.dirAngle + self.dirAngleVel*deltaTime)
	
	self.width = self.width + self.proportionsVel * deltaTime
	self.height = self.height + self.proportionsVel * deltaTime
	
	-- The proportions cannot go negative
	if self.width < 0 then
		self.width = 0
	end
	if self.height < 0 then
		self.height = 0
	end
	
	-- Update position
	self.x = self.x + sinCosTable:cos(self.dirAngle) * self.vel * deltaTime
	self.y = self.y - sinCosTable:sin(self.dirAngle) * self.vel * deltaTime
	
	self.vel = self.vel + self.acc * deltaTime
	if self.userUpdate ~= nil then
		self:userUpdate(camera, deltaTime, userData)
	end
	
	return false
end

-- Draw particle onto screen
function Particle:draw()
	local texW, texH = self.texture:getDimensions()
	local alphaColor = 1.0
	
	if self.timer < self.fadeTime and self.fadeIn then
		alphaColor = self.timer/self.fadeTime
	elseif self.endTime >= 0 
		and self.timer > self.endTime-self.fadeTime
		and self.fadeOut then
		-- Inverse
		alphaColor = 1.0-(self.timer-(self.endTime-self.fadeTime))/self.fadeTime
	end
	
	love.graphics.setColor(255, 255, 255, 255 * alphaColor)
	love.graphics.push()
	love.graphics.translate(self.x, self.y)
	love.graphics.rotate(math.rad(self.texAngle))
	
	-- Draw particle itself
	self.texDrawFunc(self.texture, -self.width/2,
		-self.height/2, self.width, self.height)
	
	love.graphics.pop()
	love.graphics.setColor(255, 255, 255, 255)
end
