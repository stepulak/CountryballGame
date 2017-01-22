require "Unit"

local CanonBallSizeQ = 0.8
local CanonBallSmashWidthQ = 0.4

CanonBall = Unit:new()

function CanonBall:init(x, y, tileWidth, tileHeight,
	isFacingLeft, movementAnim)
	
	self:super("canonball", x, y, 
		tileWidth * CanonBallSizeQ,
		tileHeight * CanonBallSizeQ,
		0, 500, nil, movementAnim)
	
	self.activeAnim = self.movementAnim
	self.isFacingLeft = isFacingLeft
end

function CanonBall:instantDeath(particleSystem)
	local width = self.width * CanonBallSmashWidthQ
	local x
	
	if self.isFacingLeft then
		x = self.x - self.width/2
	else
		x = self.x + self.width/2 - width
	end
	
	particleSystem:addUnitSmashEffect(self.movementAnim:firstTexture(),
		x + width/2, self.y, width, self.height, self.isFacingLeft)
	
	self.dead = true
end

function CanonBall:hurt(type, particleSystem)
	-- CanonBall generally is easily killable
	if type ~= nil then
		self:instantDeath(particleSystem)
	end
end

function CanonBall:updateAnimations(deltaTime)
	self.activeAnim = self.movementAnim
	self.activeAnim:update(deltaTime)
end

function CanonBall:update(deltaTime, gravityAcc, particleSystem, camera)
	if self.collidedHorizontally == "left" or
		self.collidedHorizontally == "right" then
		self:instantDeath(particleSystem)
	end
	
	self:moveHorizontally(self.isFacingLeft)
	self.isJumping = false
	self.isFalling = false
	self:superUpdate(deltaTime, gravityAcc)
end