require "class"
require "TextureAnimation"
require "TileHeadersProperties"

-- Tile header class
TileHeader = class:new()

function TileHeader:init(name, isBreakable, isBouncable, isOblique, 
	isObliqueLeftSide, isPlatform, isWater, isDeadly, isSecret,
	generatorType, staticBlockName, isFlipped, animation)
	self.name = name
	self.isBreakable = isBreakable
	self.isBouncable = isBouncable
	-- -1 ... oblique from the left
	-- 1 ... oblique from the right
	-- 0 ... is not oblique
	self.oblique = isOblique and (isObliqueLeftSide and -1 or 1) or 0
	self.isPlatform = isPlatform
	self.isWater = isWater
	self.isBackground = isBackground
	self.isDeadly = isDeadly
	self.isSecret = isSecret
	self.generatorType = generatorType
	self.staticBlockName = staticBlockName
	self.isFlipped = isFlipped -- animation flipped horizontally
	self.animation = animation
	
	-- TILE SPECIFIC
	if self.animation.updateCounter == nil then
		self.animation.updateCounter = 0
	end
end

-- Update tile header (texture swapping in animation)
function TileHeader:update(deltaTime, updateCounter)
	if self.animation ~= nil and self.animation.updateCounter < updateCounter then
		self.animation:update(deltaTime)
		self.animation.updateCounter = updateCounter
	end
end