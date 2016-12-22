require "Unit"

Spiky = Unit:new()

function Spiky:init(x, y, tileWidth, tileHeight, movementAnim)
	self:super("spiky", x, y, tileWidth, tileHeight, 
		UnitJumpingVelRecommended, UnitHorizontalVelRecommended,
		nil, movementAnim)
	
	-- It is dangerous to step on it
	self.isSteppable = false
end

function Spiky:instantDeath(particleSystem)
	particleSystem:addUnitFallEffect(self.activeAnim:getActiveTexture(),
		self.x, self.y, self.width, self.height, self.isFacingLeft, 
		self.horizontalVel)
end

function Spiky:hurt(type, particleSystem)
	if type == "step_on" or type == "touch_left" or type == "touch_right" then
		-- You cannot kill spiky like this
		return
	end
	
	self:instantDeath(particleSystem)
end

function Spiky:updateAnimations(deltaTime)
	self.activeAnim = self.movementAnim
	self.activeAnim:update(deltaTime)
end

function Spiky:update(deltaTime, gravityAcc, particleSystem, camera)
	self:reverseDirectionAccordingToCollision()
	self:moveHorizontally(self.isFacingLeft)
	self:superUpdate(deltaTime, gravityAcc, particleSystem, camera)
end