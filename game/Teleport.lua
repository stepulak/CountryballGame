require "ActiveObject"

Teleport = ActiveObject:new()

local colors = {
	[1] = { r = 255, g = 50, b = 50 },
	[2] = { r = 50, g = 255, b = 50 },
	[3] = { r = 50, g = 50, b = 255 },
	[4] = { r = 200, g = 100, b = 100 },
	[5] = { r = 100, g = 200, b = 100 },
	[6] = { r = 100, g = 100, b = 200 },
}

local UnitProcessingTime = 0.25-- 250ms

function Teleport:init(x, y, tileWidth, tileHeight, teleportAnim)
	self:super("teleport", x, y, 1, 1, tileWidth, tileHeight)
	
	self.color = colors[math.random(1, #colors)]
	self.anim = teleportAnim:getCopy()
	self.boundedUnits = {}
	self.processedUnits = nil
	self.processingOut = false
	self.twin = nil
	self.unavailableTimer = 0
end

-- Set twin teleport
-- Teleport only function!
-- Return the teleport itself so you can concat function calls
function Teleport:setTwin(twin)
	self.twin = twin
	return self
end

function Teleport:boundUnit(unit)
	-- Use table as a key
	self.boundedUnits[unit] = unit
end

function Teleport:isAlreadyBounded(unit)
	return self.boundedUnits[unit] ~= nil
end

function Teleport:canBeBounded(unit)
	-- Every unit in collision with this teleport can be bounded
	-- if the unit is not dead
	return unit.dead == false
end

function Teleport:checkPointCollision(x, y)
	return false
end

function Teleport:activate()
	-- Units cannot be teleported elsewhere
	if self.twin == nil or self.twin.unavailableTimer > 0 
		or self.unavailableTimer > 0 then
		return false
	end
	
	self.processedUnits = self.boundedUnits
	self.boundedUnits = {}
	self.processingOut = true
	self.unavailableTimer = UnitProcessingTime
	return true
end

function Teleport:update(camera, particleSystem, deltaTime)
	if self.unavailableTimer > 0 then
		self.unavailableTimer = self.unavailableTimer - deltaTime
		
		-- Maybe some units are being teleported
		-- Precount alpha channel for every teleported unit
		local alpha = 255 * (self.unavailableTimer / UnitProcessingTime)
		
		if self.processingOut == false then
			alpha = 255 - alpha
		end
		
		for key, unit in pairs(self.processedUnits) do
			unit.alpha = alpha
		end
		
		-- Check, if you should finally teleport the units and
		-- end the fading effect
		if self.unavailableTimer <= 0 then
		
			if self.processingOut then
				local offsetX = self.twin.realX - self.realX
				local offsetY = self.twin.realY - self.realY
				
				for key, unit in pairs(self.processedUnits) do
					unit.x = unit.x + offsetX
					unit.y = unit.y + offsetY
				end
				
				-- Setup twin to recieve the teleported units
				self.twin.processingOut = false
				self.twin.unavailableTimer = UnitProcessingTime
				self.twin.processedUnits = self.processedUnits
			end
			
			self.processingOut = nil
			self.unavailableTimer = 0
			self.processedUnits = nil
		end
	end
	
	self.anim:update(deltaTime)
end

function Teleport:draw(camera, drawFrameCounter)
	self.drawFrameCounter = drawFrameCounter
	
	love.graphics.setColor(self.color.r, self.color.g, self.color.b)
	
	self.anim:draw(camera, self.realX - self.realWidth/2, 
		self.realY - self.realHeight/2, self.realWidth, self.realHeight, 0)
		
	love.graphics.setColor(255, 255, 255)
end
