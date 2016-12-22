require "class"

-- Boost generator
-- This generator creates an effect of in-game
-- production of the new mushrooms and flowers for the player
-- from the bounded tile
BoostGenerator = class:new()

-- @boostUnit remember, that proportions of this unit must be
-- exactly tileWidth x tileHeight !!
function BoostGenerator:init(centerX, centerY,
	tileWidth, tileHeight, boostUnit)
	self.x = centerX
	self.y = centerY
	self.width = tileWidth
	self.height = tileHeight
	self.boostUnit = boostUnit
	self.boostUnit.movementAndCollisionDisabled = true
end

function BoostGenerator:shouldBeDestroyed()
	return self.boostUnit.y <= self.y - self.height
end

function BoostGenerator:getTilePosition()
	return math.floor((self.x - self.width/2) / self.width,
		math.floor((self.y - self.height/2) / self.height))
end

function BoostGenerator:update(deltaTime)
	self.boostUnit.y = self.boostUnit.y - 100 * deltaTime
	
	if self:shouldBeDestroyed() then
		self.boostUnit.y = self.y - self.height
		self.boostUnit.movementAndCollisionDisabled = false
	end
end