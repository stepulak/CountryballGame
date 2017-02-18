require "class"
require "TextureAnimation"
require "TileHeadersProperties"

-- Tile header class
TileHeader = class:new()

function TileHeader:init(name, isBreakable, isBouncable, isOblique, 
	isObliqueLeftSide, isPlatform, isWater, isDeadly, isSecret,
	generatorType, staticBlockName, animation)
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
	self.animation = animation
end

-- Update tile header (texture swapping in animation)
function TileHeader:update(deltaTime)
	if self.animation ~= nil then
		self.animation:update(deltaTime)
	end
end