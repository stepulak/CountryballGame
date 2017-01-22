require "ImageGrid"
require "Button"

local MultiImageGridButtonHeightQ = 1.5
local MultiImageGridButtonWidthQ = 1.2

MultiImageGrid = GuiElement:new()

function MultiImageGrid:init(x, y, width, height, font)
	self:super("multi_image_grid", x, y, width, height)
	
	self.grids = {}
	self.activeGridName = nil
	self.font = font
	self.buttonHeight = self.font.font:getHeight() * 
		MultiImageGridButtonHeightQ
end

-- Return horizontal position of a next button for new image grid
function MultiImageGrid:getNextButtonHorizontalPos()
	local x = self.x
	for name, grid in pairs(self.grids) do
		x = x + grid.button.width
	end
	return x
end

function MultiImageGrid:newImageGrid(gridName, imageWidth, imageHeight)
	local x = self:getNextButtonHorizontalPos()
	
	self.grids[gridName] = {
	
		-- Select button
		button = Button:new(gridName, self.font, x, self.y,  
			self.font.font:getWidth(gridName) * MultiImageGridButtonWidthQ,
			self.buttonHeight,
			-- Action function
			function()
				self.activeGridName = gridName
			end),
			
		-- Image grid
		grid = ImageGrid:new(
			self.x, self.y + self.buttonHeight, 
			self.width, self.height - self.buttonHeight,
			imageWidth, imageHeight, self.font)
	}
	
	if self.activeGridName == nil then
		-- Make the first one active
		self:pressButton(self.grids[gridName].button, 0, 0)
	end
	
	return self:getImageGrid(gridName)
end

function MultiImageGrid:getImageGrid(gridName)
	return self.grids[gridName].grid
end

function MultiImageGrid:getActiveImageGrid()
	if self.activeGridName then
		return self.grids[self.activeGridName].grid
	else
		return nil
	end
end

-- @x, @y = mouse coordinates
function MultiImageGrid:insideButtonArea(x, y)
	return pointInRect(x, y, self.x, self.y, self.width, self.buttonHeight)
end

function MultiImageGrid:mouseInsideScrollBar(x, y)
	if self.activeGridName then
		return self:getActiveImageGrid():mouseInsideScrollBar(x, y)
	else
		return false
	end
end

-- @x, @y = inner mouse coordinates within button area!
function MultiImageGrid:getButton(x, y)
	for name, grid in pairs(self.grids) do
		if grid.button:mouseInArea(x, y) then
			return grid.button
		end
	end
	
	return nil
end

function MultiImageGrid:pressButton(button, x, y)
	if button then
		-- We want to trigger the action immediately
		button:mouseRelease(x, y)
	end
end

function MultiImageGrid:mouseClick(x, y)
	if self:insideButtonArea(x, y) then
		self:pressButton(self:getButton(x, y), x, y)
	elseif self.activeGridName then
		self:getActiveImageGrid():mouseClick(x, y)
	end
end

function MultiImageGrid:mouseRelease(x, y)
	if self:insideButtonArea(x, y) == false then
		self:mouseReleaseNotInside(x, y)
	end
end

function MultiImageGrid:mouseReleaseNotInside(x, y)
	if self.activeGridName then
		self:getActiveImageGrid():mouseRelease(x, y)
	end
end

function MultiImageGrid:mouseMove(x, y, distX, distY)
	if self.activeGridName then
		self:getActiveImageGrid():mouseMove(x, y, distX, distY)
	end
end

function MultiImageGrid:update(deltaTime, mouseX, mouseY)
	if self.activeGridName then
		self:getActiveImageGrid():update(deltaTime, mouseX, mouseY)
	end
end

function MultiImageGrid:draw(camera)
	-- Buttons
	for name, grid in pairs(self.grids) do
		if self.activeGridName ~= name then
			-- Light black under selected button
			drawRect("fill", 
				grid.button.x, grid.button.y,
				grid.button.width, grid.button.height,
				100, 100, 100, 120)
		end
		
		grid.button:draw()
	end
	
	-- Active grid
	if self.activeGridName then
		self:getActiveImageGrid():draw(camera)
	else
		-- Empty rectangle
		drawRect("fill", 
			self.x, self.y + self.buttonHeight,
			self.width, self.height - self.buttonHeight, 
			0, 0, 0, 255)
	end
end