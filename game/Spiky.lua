require "Unit"

Spiky = Unit:new()

function Spiky:init(x, y, tileWidth, tileHeight, movementAnim)
	self:super("spiky", x, y, tileWidth, tileHeight, 
		UnitJumpingVelRecommended, UnitHorizontalVelRecommended,
		nil, movementAnim)
	
	-- It is dangerous to step on it
	self.isSteppable = false
	self.activeAnim = movementAnim
end

function Spiky:instantDeath(particleSystem, soundContainer)
	particleSystem:addUnitDirectedFallEffect(self.activeAnim:getActiveTexture(),
		self.x, self.y, self.width, self.height, self.isFacingLeft, 
		self.horizontalVel)
	
	self.dead = true
end

function Spiky:hurt(type, particleSystem, soundContainer)
	if type == "step_on" then
		-- You cannot kill spiky like this
		return
	end
	
	self:instantDeath(particleSystem, soundContainer)
	self:playStdHurtEffect(type, soundContainer)
end

function Spiky:updateAnimations(deltaTime)
	self.activeAnim = self.movementAnim
	self.activeAnim:update(deltaTime)
end

function Spiky:update(deltaTime, gravityAcc, particleSystem,
	camera, soundContainer)
	
	self:reverseDirectionAccordingToCollision()
	self:moveHorizontally(self.isFacingLeft)
	self:superUpdate(deltaTime, gravityAcc, particleSystem,
		camera, soundContainer)
end