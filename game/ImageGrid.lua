require "Button"
require "Utils"

local ScrollBarWidth = 30
local IdleTime = 0.5

local BackgroundColor = {
	r = 140,
	g = 145,
	b = 171,
	a = 150
}

local ActiveElementColor = {
	r = 160,
	g = 10,
	b = 10,
	a = 180,
}

local ScrollBarColor = {
	r = 50,
	g = 50,
	b = 50,
	a = 255,
}

ImageGrid = GuiElement:new()

function ImageGrid:init(x, y, width, height, imageWidth, imageHeight, font)
	self:super("image_grid", x, y, width, height)
	
	self.imageWidth = imageWidth
	self.imageHeight = imageHeight
	self.font = font
	
	-- The image grid is scrollable only up/down!
	local realWidth = width - ScrollBarWidth
	
	self.numElemsX = math.floor(realWidth/imageWidth)
	self.offsetX = math.fmod(realWidth, imageWidth) / 2
	self.numElemsY = math.floor(height/imageHeight)
	
	self.scrollBarHeight = height/5
	self.scrollBarPos = 0 -- vertical position
	self.scrollingEnabled = false
	
	self.index = 0
	self.activeX = nil
	self.activeY = nil
	self.infoX = nil
	self.infoY = nil
	
	self.idleTimer = 0
	
	-- Create grid
	self.grid = {}
	for i = 0, self.numElemsX - 1 do
		self.grid[i] = {}
	end
end

-- @drawable = either texture (image) or draw function
-- @name = name of the image (identifier)
-- @info = brief info about the image 
-- 		(showed only when user points a mouse curson on it)
-- @data = data which can be stored
function ImageGrid:addElement(drawable, name, info, data)
	local t = {}
	
	if type(drawable) == "userdata" then
		-- It's an image, create a drawing lambda function
		local imgW, imgH = self:getImageProportions()
		t.draw = 
			function()
				drawTex(drawable, 0, 0, imgW, imgH)
			end
	else
		-- It's already a function!
		t.draw = drawable
	end
	
	t.name = name
	t.info = info
	t.data = data
	
	-- Add it into the grid
	self.grid[self.index][#self.grid[self.index] + 1] = t
	self.index = math.fmod(self.index + 1, self.numElemsX)
	
	return self
end

function ImageGrid:getActiveElement()
	if self.activeX and self.activeY then
		local active = self.grid[self.activeX][self.activeY]
		return active.name, active.data, active.draw
	else
		return nil, nil
	end
end

-- @x, @y = global coordinates
function ImageGrid:mouseInsideScrollBar(x, y)
	return pointInRect(x, y, self.x + self.width - ScrollBarWidth,
		self.y, ScrollBarWidth, self.height)
end

-- @y = inner y coordinate
function ImageGrid:setScrollBarPos(y)
	self.scrollBarPos = 
		setWithinRange(y, 0, self.height - self.scrollBarHeight)
end

function ImageGrid:getScrollOffset()
	local numElemsY = #self.grid[0] - self.numElemsY
	
	if numElemsY < 0 then
		numElemsY = 0
	end
	
	return (numElemsY * self.imageHeight) *
		(self.scrollBarPos / (self.height - self.scrollBarHeight))
end

-- @x, @y = global coordinates
function ImageGrid:getElementOnInnerCoords(x, y)
	x = x - (self.x + self.offsetX)
	y = y - self.y + self:getScrollOffset()
	
	if x < 0 then
		-- Offset!
		return nil, nil
	end
	
	local acX = math.floor(x / self.imageWidth)
	local acY = math.floor(y/ self.imageHeight) + 1
	
	if self.grid[acX] and self.grid[acX][acY] then
		return acX, acY
	else
		return nil, nil
	end
end

-- @x, @y = global coordinates
function ImageGrid:pickActiveElement(x, y)
	self.activeX, self.activeY = self:getElementOnInnerCoords(x, y)
end

-- @x, @y = global coordinates
function ImageGrid:pickInfoElement(x, y)
	self.infoX, self.infoY = self:getElementOnInnerCoords(x, y)
end

function ImageGrid:mouseClick(x, y)
	if self:mouseInsideScrollBar(x, y) then
		self.scrollingEnabled = true
		self:setScrollBarPos(y - self.y - self.scrollBarHeight/2)
	else
		self:pickActiveElement(x, y)
	end
end

function ImageGrid:mouseRelease(x, y)
	self.scrollingEnabled = false
end

function ImageGrid:mouseReleaseNotInside(x, y)
	self:mouseRelease(x, y)
end

function ImageGrid:mouseMove(x, y, distX, distY)
	if self.scrollingEnabled then
		self:setScrollBarPos(y - self.y - self.scrollBarHeight/2)
	end
	
	-- Reset info indexes and timer
	self.idleTimer = 0
	self.infoX = nil
	self.infoY = nil
end

function ImageGrid:getImageProportions()
	return self.imageWidth * 0.9, self.imageHeight * 0.9
end

function ImageGrid:update(deltaTime, mouseX, mouseY)
	self.idleTimer = self.idleTimer + deltaTime
	
	if self.idleTimer >= IdleTime and
		self:mouseInsideScrollBar(mouseX, mouseY) == false then
		self:pickInfoElement(mouseX, mouseY)
	end
end

function ImageGrid:draw(camera)
	-- Background
	drawRectC("fill", self.x, self.y, self.width, self.height,
		BackgroundColor)
	
	-- Scrollbar
	drawRectC("fill", 
		self.x + self.width - ScrollBarWidth, 
		self.y + self.scrollBarPos, 
		ScrollBarWidth, self.scrollBarHeight, 
		ScrollBarColor)
	
	-- Set scissor
	-- Coordinates for scissor must be set in real screen coordinates!
	local sx, sy = getScaleVirtualToReal(
		camera.screenWidth, camera.virtualWidth,
		camera.screenHeight, camera.virtualHeight)
	
	love.graphics.setScissor(self.x * sx, self.y * sy, 
		self.width * sx, self.height * sy - 10)
	
	local offsetY = self:getScrollOffset()
	
	local imgW, imgH = self:getImageProportions()
	local imgOffsetW = (self.imageWidth - imgW)/2
	local imgOffsetH = (self.imageHeight - imgH)/2
	
	-- Active element
	if self.activeX and self.activeY then
		drawRectC("fill", 
			self.x + self.activeX * self.imageWidth + self.offsetX + imgOffsetW,
			self.y + (self.activeY-1) * self.imageHeight - offsetY + imgOffsetH,
			self.imageWidth, self.imageHeight,
			ActiveElementColor)
	end
	
	-- Elements
	love.graphics.setColor(255, 255, 255, 255)
	
	for x = 0, self.numElemsX-1 do
		for y = 1, #self.grid[x] do
		
			love.graphics.push()
			love.graphics.translate(
				self.x + x * self.imageWidth + self.offsetX + imgOffsetW,
				self.y + (y-1) * self.imageHeight - offsetY + imgOffsetH)
			
			self.grid[x][y].draw()
			
			love.graphics.pop()
		end
	end
	
	-- Remove scissor
	love.graphics.setScissor()
	
	-- Element info
	if self.infoX and self.infoY then
		local elem = self.grid[self.infoX][self.infoY]
		local x = self.x + self.infoX * self.imageWidth + self.offsetX
		local y = self.y + self.infoY * self.imageHeight - offsetY
		local nameStr = "Name: " .. elem.name
		local infoStr = "Info: " .. elem.info
		
		-- Black background
		local width = max(self.font.font:getWidth(nameStr),
			self.font.font:getWidth(infoStr))
			
		drawRect("fill", x, y,
			width, 2 * self.font.font:getHeight(),
			0, 0, 0, 150)
		
		self.font:drawLine(nameStr, x, y)
		self.font:drawLine(infoStr, x, y + self.font.font:getHeight())
	end
end