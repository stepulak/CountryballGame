require "Unit"

local RotatingVel = 90
local TexRotatingVel = 90

RotatingGhost = Unit:new()

function RotatingGhost:init(x, y, tileWidth, tileHeight, idleAnim)
	self:super("rotating_ghost", x, y, tileWidth/2, tileHeight/2, 
		1, 1, idleAnim)
	
	self.hardX = x
	self.hardY = y
	self.radius = 3 * math.sqrt(tileWidth*tileWidth + tileHeight*tileHeight)
	self.angle = 180
	self.texAngle = 0
	self.x = self.x - self.radius
	self.isSteppable = false
end

function RotatingGhost:isInvulnerable()
	return true
end

function RotatingGhost:updateAnimations(deltaTime)
	self.activeAnim = self.idleAnim
	self.activeAnim:update(deltaTime)
end

-- Rotating Ghost's function only!
function RotatingGhost:updateRotatingMovement(deltaTime, sinCosTable)
	self.x = self.hardX + sinCosTable:cos(self.angle) * self.radius
	self.y = self.hardY - sinCosTable:sin(self.angle) * self.radius
	
	self.angle = math.fmod(self.angle +
		RotatingVel * deltaTime, 360)
		
	self.texAngle = math.fmod(self.texAngle + 
		TexRotatingVel * deltaTime, 360)
end

function RotatingGhost:update(deltaTime, gravityAcc, particleSystem,
	camera, soundContainer)
	
	self:superUpdate(deltaTime, gravityAcc, particleSystem, 
		camera, soundContainer)
	
	-- Make sure that movement will go unnoticed
	self.isFalling = false
	self.isJumping = false
	self.isMovingHor = false
end

function RotatingGhost:draw(camera)
	self:superDraw(camera, self.texAngle)
end