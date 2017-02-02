require "class"
require "Utils"

Camera = class:new()

-- Setup new camera
-- virtualWidth, virtualHeight = in-game resolution
-- screenWidth, screenHeight = screen/window resolution
function Camera:init(x, y, virtualWidth, virtualHeight, screenWidth,
	screenHeight, mapWidth, mapHeight)
	self.x = x
	self.y = y
	self.virtualWidth = virtualWidth
	self.virtualHeight = virtualHeight
	self.screenWidth = screenWidth
	self.screenHeight = screenHeight
	self.mapWidth = mapWidth
	self.mapHeight = mapHeight
	
	self.stack = {}
	self.stackIndex = 0
end

-- Save x, y, virtualWidth, virtualHeight
-- Can be called as many times as wanted
function Camera:push()
	self.stackIndex = self.stackIndex + 1
	
	local t = self.stack[self.stackIndex]
	
	if t == nil then
		-- Empty head? Fill it with new table
		t = {}
		self.stack[self.stackIndex] = t
	end
	
	t.x = self.x
	t.y = self.y
	t.virtualWidth = self.virtualWidth
	t.virtualHeight = self.virtualHeight
end

-- Restore x, y, virtualWidth, virtualHeight
function Camera:pop()
	if self.stackIndex > 0 then
		local t = self.stack[self.stackIndex]
		
		self.x = t.x
		self.y = t.y
		self.virtualWidth = t.virtualWidth
		self.virtualHeight = t.virtualHeight
		
		self.stackIndex = self.stackIndex - 1
	end
end

function Camera:scalePosition(sx, sy)
	self.x = self.x * sx
	self.y = self.y * sy
end

function Camera:scaleVirtualProp(sx, sy)
	self.virtualWidth = self.virtualWidth * sx
	self.virtualHeight = self.virtualHeight * sy
end

-- Calibrate the camera into the map
function Camera:boundToMap()
	self.x = setWithinRange(self.x, 0, self.mapWidth-self.virtualWidth)
	self.y = setWithinRange(self.y, 0, self.mapHeight-self.virtualHeight)
end

function Camera:centerAt(x, y)
	self.x = x-self.virtualWidth/2
	self.y = y-self.virtualHeight/2
	self:boundToMap()
end

function Camera:move(dirX, dirY, distance)
	self.x = self.x + dirX*distance
	self.y = self.y + dirY*distance
	self:boundToMap()
end