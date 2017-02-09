require "Unit"

local CountdownTime = 3
local ExplosionTime = 0.3
local ProportionsInc = 3

Bomberman = Unit:new()

function Bomberman:init(x, y, tileWidth, tileHeight, 
	movementAnim, countdownAnim, explosionAnim)
	
	self:super("bomberman", x, y, tileWidth, tileHeight,
		UnitJumpingVelRecommended, UnitHorizontalVelRecommended,
		nil, movementAnim, nil, nil, nil, explosionAnim)
	
	self.color = {
		r = 255,
		g = 255,
		b = 255,
	}
	
	self.countdownAnim = countdownAnim:getCopy()
	
	-- The explosion has to be drawn only once within the given time.
	self.deathAnim.updateTime = 1.1 * (ExplosionTime /
		self.deathAnim:numTextures())
	
	self.activeAnim = self.movementAnim
	
	self.state = "walking" -- or "countdown", "exploding"
	self.timer = 0
end

function Bomberman:instantDeath(particleSystem, soundContainer)
	if self.state == "exploding" then
		return
	end
	
	self.state = "exploding"
	self.timer = ExplosionTime
	self.isSteppable = false
	self.notFreezable = true
	
	-- Increase the proportions of the explosion no matter the tile collision.
	self.width = self.width * ProportionsInc
	self.height = self.height * ProportionsInc
	
	-- Make sound effect
	soundContainer:playEffect("explosion")
end

function Bomberman:fallDown(particleSystem, soundContainer)
	-- Instant death without explosion
	self.state = "exploding"
	self.timer = 0
end

function Bomberman:isInvulnerable()
	return self.state == "exploding"
end

function Bomberman:canBeRemoved()
	return self.state == "exploding" and self.timer <= 0
end

-- Bomberman function only!
function Bomberman:initCountdown()
	self.state = "countdown"
	self.timer = CountdownTime
end

function Bomberman:hurt(type, particleSystem, soundContainer)
	if self.state == "walking" then
		if type == "step_on" then
			self:initCountdown()
		else
			self:instantDeath(particleSystem, soundContainer)
		end
	elseif self.state == "countdown" then
		if type ~= "step_on" then
			self:instantDeath(particleSystem, soundContainer)
		end
	end
end

function Bomberman:updateAnimations(deltaTime)
	self:resetInactiveAnimations()
	
	if self.state == "walking" then
		self.activeAnim = self.movementAnim
	elseif self.state == "countdown" then
		self.activeAnim = self.countdownAnim
	else
		self.activeAnim = self.deathAnim
	end
	
	self.activeAnim:update(deltaTime)
end

-- Bomberman function only!
function Bomberman:handleBehaviour(deltaTime, particleSystem, soundContainer)
	self.timer = self.timer - deltaTime
	
	if self.state == "walking" then
		self:moveHorizontally(self.isFacingLeft)
		self:reverseDirectionAccordingToCollision()
	elseif self.state == "countdown" then
		if self.timer <= 0 then
			self:instantDeath(particleSystem, soundContainer)
		end
	else
		-- Stop moving so that the in-world tile-collision is ignored.
		self.isJumping = false
		self.isFalling = false
		self.isMovingHor = false
		mutateColor(self.color)
	end
end

function Bomberman:handleSpecialHorizontalCollision(unit,
	particleSystem, soundContainer)
	
	if self.state == "exploding" then
		-- You have to get the face of collision
		local touch
		
		if unit.x < self.x then
			touch = "touch_left"
		else
			touch = "touch_right"
		end
		
		unit:hurt(touch, particleSystem, soundContainer)
	end
end

function Bomberman:update(deltaTime, gravityAcc, particleSystem,
	camera, soundContainer)
	
	self:superUpdate(deltaTime, gravityAcc, particleSystem, 
		camera, soundContainer)
	
	self:handleBehaviour(deltaTime, particleSystem, soundContainer)
end

function Bomberman:draw(camera)
	love.graphics.setColor(self.color.r, self.color.g, self.color.b)
	self:superDraw(camera)
	love.graphics.setColor(255, 255, 255)
end