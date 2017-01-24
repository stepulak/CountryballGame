require "Unit"

local BombermanCountdownTime = 3
local BombermanExplosionTime = 0.3
local BombermanProportionsInc = 3

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
	
	-- Resolve explosion animation update time - because you 
	-- don't want to draw the explosion twice or more, just once
	-- and exactly with the given explosion time
	self.deathAnim.updateTime = 1.1 * (BombermanExplosionTime /
		self.deathAnim:numTextures())
	
	self.activeAnim = self.movementAnim
	
	self.state = "walking" -- or "countdown", "exploding"
	self.timer = 0
end

function Bomberman:instantDeath(type, particleSystem)
	if self.state == "exploding" then
		return
	end
	
	self.state = "exploding"
	self.timer = BombermanExplosionTime
	self.isSteppable = false
	self.notFreezable = true
	
	-- The world won't bully because the tile collision
	-- will be skipped from now
	self.width = self.width * BombermanProportionsInc
	self.height = self.height * BombermanProportionsInc
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
	self.timer = BombermanCountdownTime
end

function Bomberman:hurt(type, particleSystem)
	if self.state == "walking" then
		if type == "step_on" then
			self:initCountdown()
		else
			self:instantDeath(particleSystem)
		end
	elseif self.state == "countdown" then
		if type ~= "step_on" then
			self:instantDeath(particleSystem)
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
function Bomberman:handleBehaviour(deltaTime)
	self.timer = self.timer - deltaTime
	
	if self.state == "walking" then
		self:moveHorizontally(self.isFacingLeft)
		self:reverseDirectionAccordingToCollision()
	elseif self.state == "countdown" then
		if self.timer <= 0 then
			self:instantDeath()
		end
	else
		-- Make sure that world won't move and
		-- won't resolve collision on this unit anymore...
		self.isJumping = false
		self.isFalling = false
		self.isMovingHor = false
		
		local c = self.color
		c.r, c.g, c.b = getRandomColor(c.r, c.g, c.b)
	end
end

function Bomberman:handleSpecialHorizontalCollision(unit, particleSystem)
	if self.state == "exploding" then
		-- You have to get the face of collision
		local touch
		
		if unit.x < self.x then
			touch = "touch_left"
		else
			touch = "touch_right"
		end
		
		unit:hurt(touch, particleSystem)
	end
end

function Bomberman:update(deltaTime, gravityAcc, particleSystem,
	camera, soundContainer)
	
	self:superUpdate(deltaTime, gravityAcc, particleSystem, 
		camera, soundContainer)
	
	self:handleBehaviour(deltaTime)
end

function Bomberman:draw(camera)
	love.graphics.setColor(self.color.r, self.color.g, self.color.b)
	self:superDraw(camera)
	love.graphics.setColor(255, 255, 255)
end