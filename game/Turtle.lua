require "Unit"

local TurtleCoverTime = 3

Turtle = Unit:new()

function Turtle:init(x, y, tileWidth, tileHeight, movementAnim, shellTex)
	self:super("turtle", x, y, tileWidth, tileHeight,
		UnitJumpingVelRecommended, UnitHorizontalVelRecommended, 
		nil, movementAnim)
	
	self.shellTex = shellTex
	
	self.isCovered = false
	self.coverTimer = 0
	self.isMad = false
	self.isFacingLeft = true
	
	self.activeAnim = movementAnim
end

-- Turtle function only!
function Turtle:instantDeathFallEffect(particleSystem)
	self.dead = true
	
	particleSystem:addUnitFallEffect(self.shellTex, self.x, self.y,
		self.width, self.height, self.isFacingLeft, self.horizontalVel)
end

function Turtle:instantDeath(particleSystem)
	self.dead = true
	
	particleSystem:addUnitSmashEffect(self.shellTex, self.x, self.y,
		self.width, self.height, self.isFacingLeft)
end

function Turtle:hurt(type, particleSystem)
	if type == "step_on" then
		self.coverTimer = TurtleCoverTime
		
		if self.isCovered == false then
			self.isCovered = true
		else
			self.isMad = not self.isMad
		end
		
		-- Collision handled
		return
	end
	
	-- Is covered and not mad? A little push can get you mad...
	if self.isCovered and self.isMad == false then
		if type == "touch_left" then
			self.isMad = true
			self.isFacingLeft = false
		elseif type == "touch_right" then
			self.isMad = true
			self.isFacingLeft = true
		end
		
		-- Collision handled
		return
	end
	
	self:instantDeathFallEffect(particleSystem)
end

function Turtle:handleSpecialHorizontalCollision(unit, particleSystem)
	if self.isMad then
		unit:hurt(self.isFacingLeft and "touch_left" or "touch_right",
			particleSystem)
		return true
	elseif self.isCovered then
		self.isFacingLeft = unit.x > self.x
		self.isMad = true
		return true
	end
end

function Turtle:updateAnimations(deltaTime)
	self.activeAnim = self.movementAnim
	
	if self.isCovered == false then
		self.activeAnim:update(deltaTime)
	else
		self.activeAnim:reset()
	end
end

function Turtle:update(deltaTime, gravityAcc, particleSystem,
	camera, soundContainer)
	
	if self.coverTimer > 0 and self.isCovered and self.isMad == false then
		-- The unit cannot move now
		self.coverTimer = self.coverTimer - deltaTime
		
		if self.coverTimer <= 0 then
			-- You can walk again
			self.isCovered = false
		end
	else
		self:reverseDirectionAccordingToCollision()
		self:moveHorizontally(self.isFacingLeft)
		
		if self.isMad then
			self.horizontalVel = self.horizontalVelBase * 4
		else
			self.horizontalVel = self.horizontalVelBase
		end
	end
	
	self:superUpdate(deltaTime, gravityAcc, particleSystem,
		camera, soundContainer)
end

function Turtle:draw(camera)
	if self.dead == false then
		if self.isCovered then
			love.graphics.setColor(255, 255, 255, self.alpha)
			
			local draw = self.isFacingLeft 
				and drawTexFlipped or drawTex
			
			draw(self.shellTex,
				self.x - self.width/2 - camera.x,
				self.y - self.height/2 - camera.y,
				self.width, self.height)
			
			love.graphics.setColor(255, 255, 255, self.alpha)
		else
			self:superDraw(camera)
		end
	end
end
