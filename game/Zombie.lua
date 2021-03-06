require "Unit"
require "Utils"

local SmashTime = 2
local SmashHeightQ = 0.2

Zombie = Unit:new()

function Zombie:init(x, y, tileWidth, tileHeight, movementAnim)	
	self:super("zombie", x, y, tileWidth, tileHeight,
		UnitJumpingVelRecommended, UnitHorizontalVelRecommended,
		nil, movementAnim)
	
	self.activeAnim = movementAnim
end

function Zombie:instantDeath(particleSystem, soundContainer)
	particleSystem:addUnitDirectedFallEffect(self.movementAnim:getActiveTexture(),
		self.x, self.y, self.width, self.height, self.isFacingLeft, 
		self.horizontalVel)
	
	self.dead = true
end

-- Zombie function only!
function Zombie:smash(particleSystem, soundContainer)
	local height = self.height * SmashHeightQ
	
	particleSystem:addUnitSmashStaticEffect(
		self.movementAnim:getActiveTexture(), self.x, 
		self.y + self.height/2 - height/2, self.width, height,
		self.isFacingLeft, SmashTime)
	
	-- Smash effect (smash2 is a joke)
	if math.random() < 0.7 then
		soundContainer:playEffect("smash", false, self.x, self.y)
	else
		soundContainer:playEffect("smash2", false, self.x, self.y)
	end
	
	self.dead = true
end

function Zombie:hurt(type, particleSystem, soundContainer)
	if type == "step_on" then
		self:smash(particleSystem, soundContainer)
	else
		self:instantDeath(particleSystem, soundContainer)
		self:playStdHurtEffect(type, soundContainer)
	end
end

function Zombie:updateAnimations(deltaTime)
	self.activeAnim = self.movementAnim
	self.movementAnim:update(deltaTime)
end

function Zombie:update(deltaTime, gravityAcc, particleSystem,
	camera, soundContainer)
	
	self:reverseDirectionAccordingToCollision()
	self:moveHorizontally(self.isFacingLeft)
	self:superUpdate(deltaTime, gravityAcc, particleSystem,
		camera, soundContainer)
end