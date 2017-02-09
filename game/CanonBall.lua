require "Unit"

local BallSizeQ = 0.8
local SmashWidthQ = 0.4

CanonBall = Unit:new()

function CanonBall:init(x, y, tileWidth, tileHeight,
	isFacingLeft, movementAnim)
	
	self:super("canonball", x, y, 
		tileWidth * BallSizeQ,
		tileHeight * BallSizeQ,
		0, 500, nil, movementAnim)
	
	self.activeAnim = self.movementAnim
	self.isFacingLeft = isFacingLeft
end

function CanonBall:instantDeath(particleSystem, soundContainer)
	local width = self.width * SmashWidthQ
	local x
	
	if self.isFacingLeft then
		x = self.x - self.width/2
	else
		x = self.x + self.width/2 - width
	end
	
	particleSystem:addUnitSmashFallEffect(self.movementAnim:firstTexture(),
		x + width/2, self.y, width, self.height, self.isFacingLeft)
	
	soundContainer:playEffect("canonball_smash")
	
	self.dead = true
end

function CanonBall:hurt(type, particleSystem, soundContainer)
	-- CanonBall is easily killable
	self:instantDeath(particleSystem, soundContainer)
end

function CanonBall:updateAnimations(deltaTime)
	self.activeAnim = self.movementAnim
	self.activeAnim:update(deltaTime)
end

function CanonBall:update(deltaTime, gravityAcc, particleSystem,
	camera, soundContainer)
	
	if self.collidedHorizontally == "left" or
		self.collidedHorizontally == "right" then
		self:instantDeath(particleSystem, soundContainer)
	end
	
	self:moveHorizontally(self.isFacingLeft)
	self.isJumping = false
	self.isFalling = false
	
	self:superUpdate(deltaTime, gravityAcc, particleSystem,
		camera, soundContainer)
end