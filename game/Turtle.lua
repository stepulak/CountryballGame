require "Unit"

local CoverTime = 3

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
function Turtle:instantDeathDirectedFall(particleSystem, soundContainer)
	self.dead = true
	
	particleSystem:addUnitDirectedFallEffect(self.shellTex, self.x, self.y,
		self.width, self.height, self.isFacingLeft, self.horizontalVel)
end

-- Instant death with straight fall down
function Turtle:instantDeath(particleSystem, soundContainer)
	self.dead = true
	
	particleSystem:addUnitSmashFallEffect(self.shellTex, self.x, self.y,
		self.width, self.height, self.isFacingLeft)		
end

function Turtle:hurt(type, particleSystem, soundContainer)
	if type == "step_on" then
		self.coverTimer = CoverTime
		
		if self.isCovered == false then
			self.isCovered = true
		else
			self.isMad = not self.isMad
		end
		
		soundContainer:playEffect("turtle_touch", false, self.x, self.y)
		return -- Collision handled
	end
	
	-- Is covered and not mad? A little push can make you mad...
	if self.isCovered and self.isMad == false then
		if type == "touch_left" then
			self.isMad = true
			self.isFacingLeft = false
			soundContainer:playEffect("turtle_touch", false, self.x, self.y)
		elseif type == "touch_right" then
			self.isMad = true
			self.isFacingLeft = true
			soundContainer:playEffect("turtle_touch", false, self.x, self.y)
		end
		
		return -- Collision handled
	end
	
	self:instantDeathDirectedFall(particleSystem, soundContainer)
	self:playStdHurtEffect(type, soundContainer)
end

function Turtle:handleSpecialHorizontalCollision(unit, particleSystem,
	soundContainer)
	
	if self.isMad then
		unit:hurt(self.isFacingLeft and "touch_left" or "touch_right",
			particleSystem, soundContainer)
			
		return true
	elseif self.isCovered then
		self.isFacingLeft = unit.x > self.x
		self.isMad = true
		soundContainer:playEffect("turtle_touch", false, self.x, self.y)
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
		-- Collided with block, make sound effect
		if self.collidedHorizontally and self.isMad then
			soundContainer:playEffect("turtle_bump", false, self.x, self.y)
		end
		
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
