require "LinkedList"
require "Utils"

-- Active Object table template
-- There can be various types of active objects 
-- (trampoline, teleport, elevator), so it is vital
-- to define every object's behaviour itself.

ActiveObject = class:new()

-- @x, @y, @width, @height in tiles!
function ActiveObject:init(name, x, y, width, height, tileWidth, tileHeight)
	if name == nil then
		return
	end
	
	self.name = name
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	self.realX = tileWidth * (x + width/2)
	self.realY = tileHeight * (y + height/2)
	self.realWidth = width*tileWidth
	self.realHeight = height*tileHeight
	
	self.drawFrameCounter = 0
end

-- Accessible via inheritance
ActiveObject.super = ActiveObject.init

-- Additional setup after insert into a map
function ActiveObject:setup()
	-- VIRTUAL
end

-- Bound unit to this active object
function ActiveObject:boundUnit(unit)
	-- VIRTUAL
end

-- Return true if this unit is already bounded to this active object
function ActiveObject:isAlreadyBounded(unit)
	return false
end

-- Check, if this unit can be bounded to this active object
function ActiveObject:canBeBounded(unit, deltaTime)
	return false
end

-- Handle unit-active object collision
-- Call this function after you find out that this unit cannot be bounded.
function ActiveObject:handleUnitCollision(unit, deltaTime)
	-- VIRTUAL
end

-- We need information if this method was implemented or not.
-- I can see no better option than doing it this way.
ActiveObject.handleUnitCollision = nil

-- Some active objects has to be activated manually by player
-- Return true if the object has been succesfully activated,
-- otherwise return false
function ActiveObject:activate()
	-- VIRTUAL
	return false
end

-- Check unit - active object collision.
-- Return true if these two objects has collided, otherwise return false
function ActiveObject:checkUnitCollision(unit)
	return rectRectCollision(
		unit.x - unit.width/2,
		unit.y - unit.height/2,
		unit.width, unit.height, 
		self.realX - self.realWidth/2,
		self.realY - self.realHeight/2, 
		self.realWidth, self.realHeight)
end

-- Check if the point collided with this active object
-- Return true if they have collided, otherwise false
function ActiveObject:checkPointCollision(x, y)
	return pointInRect(x, y, 
		self.realX - self.realWidth/2, 
		self.realY - self.realHeight/2, 
		self.realWidth, self.realHeight)
end

function ActiveObject:getDir()
	return "unspecified"
end

function ActiveObject:canBeDrawn(drawFrameCounter)
	return self.drawFrameCounter < drawFrameCounter
end

function ActiveObject:update(camera, particleSystem, deltaTime)
	-- VIRTUAL
end

function ActiveObject:draw(camera, drawFrameCounter)
	-- VIRTUAL
	self.drawFrameCounter = drawFrameCounter
end

function ActiveObject:drawRectangleAround(camera, tileWidth, tileHeight)
	-- Count the real area position again from it's tile coordinates
	-- Because the real* coordinates and proportion can be different
	drawRect("line", 
		self.x * tileWidth - camera.x,
		self.y * tileHeight - camera.y,
		self.width * tileWidth, self.height * tileHeight,
		255, 0, 0, 255)
end