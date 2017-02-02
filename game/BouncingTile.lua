require "class"

local BouncingVel = 500

BouncingTile = class:new()

function BouncingTile:init(tileRef, bouncingMaxHeight)
	self.tileRef = tileRef
	self.initPosition = tileRef.verticalOffset
	self.bouncingMaxHeight = bouncingMaxHeight
	self.isFalling = false
	self.position = 0
	self.timerToStart = 0 -- can be changed for later bouncing
end

function BouncingTile:update(deltaTime)
	if self.timerToStart <= 0 then
		local dirVertical = self.isFalling and -1 or 1
		local dist = BouncingVel * deltaTime * dirVertical
		
		-- Update it's position
		self.tileRef.verticalOffset = self.tileRef.verticalOffset - dist
		self.position = self.position + dist
		
		if self.position > self.bouncingMaxHeight then
			self.isFalling = true
			self.position = self.bouncingMaxHeight
		elseif self.position < 0 then
			-- Get the tile's offset back into initial position
			self.tileRef.verticalOffset = self.initPosition
			self.tileRef.isBouncing = false
		end
	else
		self.timerToStart = self.timerToStart - deltaTime
	end
end

function BouncingTile:shouldBeRemoved()
	return self.position < 0
end