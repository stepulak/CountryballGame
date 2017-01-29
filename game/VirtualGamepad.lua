require "GuiElement"

-- Offset from the screen border
local ButtonOffset = 20

local ButColorIdle = {
	r = 0,
	g = 51,
	b = 102,
	a = 255,
}

local ButColorPressed = {
	r = 0,
	g = 71,
	b = 142,
	a = 255,
}

local LabelColorIdle = {
	r = 128,
	g = 0,
	b = 128,
	a = 255,
}

local LabelColorPressed = {
	r = 75,
	g = 0,
	b = 130,
	a = 255,
}

-- Gamepad consist of direction button (joystick)
-- and N action buttons with own one-character-length labels
VirtualGamepad = GuiElement:new()

function VirtualGamepad:init(virtScrWidth, virtScrHeight,
	font, buttonRad, buttonTex)
	
	self:super("virtual_gamepad", 0, 0, 0, 0)
	
	self.virtScrWidth = virtScrWidth
	self.virtScrHeight = virtScrHeight
	self.font = font
	self.buttonRad = buttonRad
	self.buttonTex = buttonTex
	
	self.acButtons = {}
	
	-- Direction button
	self.dirBut = {
		radius = buttonRad * 2.5,
		isPressed = false,
	}
	self.dirBut.x = ButtonOffset + self.dirBut.radius
	self.dirBut.y = virtScrHeight - ButtonOffset - self.dirBut.radius
	
	-- "joystick"
	self.dirBut.smX = self.dirBut.x
	self.dirBut.smY = self.dirBut.y
	self.dirBut.smRadius = buttonRad
	
	-- Direction button's triggers
	self.dirBut.actionPressed = function(b, x, y)
		b:actionMove(x, y, 0, 0)
	end
	
	self.dirBut.actionReleased = function(b, x, y)
		b.smX = b.x
		b.smY = b.y
	end
	
	self.dirBut.actionReleasedNotInside = function(b, x, y)
		b:actionReleased(x, y)
	end
	
	-- Only available for direction button!
	self.dirBut.actionMove = function(b, x, y, dX, dY)
		local maxRad = b.radius - b.smRadius
		local dX = b.x - x
		local dY = b.y - y
		
		if math.sqrt(dX*dX + dY*dY) > maxRad then
			local a = math.atan2(dY, dX) + math.pi
			b.smX = maxRad * math.cos(a) + b.x
			b.smY = maxRad * math.sin(a) + b.y
		else
			b.smX = x
			b.smY = y
		end
	end
	
	-- Touch queue
	self.touches = {}
	-- Single mouse click
	self.click = nil
end

function VirtualGamepad:getNewHorizontalPosButton()
	if #self.acButtons == 0 then
		return self.virtScrWidth - ButtonOffset
	else
		local b = self.acButtons[#self.acButtons]
		return b.x - b.radius/2 - ButtonOffset
	end
end

-- @label should be one-character-long (doesn't matter actually,
-- first character is taken anyway)
-- @actionPressed trigger func when button is pressed
-- @actionReleased trigger func when button is properly released
-- @actionReleasedNotInside trigger func when button is released, but
-- (touch) mouse coordinates are outside it's area
function VirtualGamepad:addActionButton(label, actionPressed, actionReleased,
	actionReleasedNotInside)
	
	local but = {}
	
	but.label = string.sub(label, 1)
	but.radius = self.buttonRad
	but.x = self:getNewHorizontalPosButton() - but.radius/2
	but.y = self.virtScrHeight - ButtonOffset
	but.isPressed = false
	but.actionPressed = actionPressed
	but.actionReleased = actionReleased
	but.actionReleasedNotInside = actionReleasedNotInside
	
	self.acButtons[#self.acButtons + 1] = but
	
	return self
end

-- Return the current direction of direction button (joystick)
-- Possible values: 
-- 	1)		x = 0, y = -1, +1
-- 	2)		x = -1, +1, y = 0
function VirtualGamepad:getDirection()
	local dX = self.dirBut.smX - self.dirBut.x
	local dY = self.dirBut.smY - self.dirBut.y
	
	if math.abs(dX) < math.abs(dY) then
		return 0, getUnitValue(dY)
	else
		return getUnitValue(dX), 0
	end
end

function VirtualGamepad:mouseInsideButton(x, y, but)
	local dX = x - but.x
	local dY = y - but.y
	return math.sqrt(dX*dX + dY*dY) < but.radius
end

-- @x, @y are mouse (touch) virtual coordinates
function VirtualGamepad:getActionButtonUnderTouch(x, y)
	for i = 1, #self.acButtons do
		if mouseInsideButton(x, y, self.acButtons[i]) then
			return self.acButtons[i]
		end
	end
	
	return nil
end

function VirtualGamepad:getButtonUnderTouch(x, y)
	if self:mouseInsideButton(x, y, self.dirBut) then
		return self.dirBut
	else
		return self:getActionButtonUnderTouch(x, y)
	end
end

function VirtualGamepad:mouseInArea(x, y)
	return self:getButtonUnderTouch(x, y) ~= nil
end

function VirtualGamepad:mouseClick(x, y)
	if self.click ~= nil then
		-- This should not happen, but beware of any anomalies
		self:mouseReleaseNotInside(-1, -1)
	end
	
	local but = self:getButtonUnderTouch(x, y)
	
	if but ~= nil then
		self.click = but
		but:actionPressed(x, y)
		but.isPressed = true
	end
end

function VirtualGamepad:mouseRelease(x, y)
	if self.click ~= nil then
		-- Check out if the coordinates aren't inside another button
		-- (which obviously is part of the gamepad)
		if self:mouseInsideButton(x, y, self.click) then
			self.click:actionReleased(x, y)
		else
			self.click:actionReleasedNotInside(x, y)
		end
		self.click.isPressed = false
		-- Processed
		self.click = nil
	end
end

function VirtualGamepad:mouseReleaseNotInside(x, y)
	if self.click ~= nil then
		-- Outside the gamepad, then it's outside of all gamepad's buttons
		self.click:actionReleasedNotInside(x, y)
		self.click.isPressed = false
		-- Processed
		self.click = nil
	end
end

function VirtualGamepad:mouseMove(x, y, distX, distY)
	if self.click == self.dirBut then
		self.click:actionMove(x, y, distX, distY)
	end
end

--
-- Touch analogue
--
function VirtualGamepad:touchPress(x, y, id)
end

function VirtualGamepad:touchRelease(x, y, id)
end

function VirtualGamepad:touchReleaseNotInside(x, y, id)
end

function VirtualGamepad:touchMove(x, y, distX, distY, id)
end

function VirtualGamepad:drawButton(x, y, rad, isPressed)
	local c = isPressed and ButColorPressed or ButColorIdle
	love.graphics.setColor(c.r, c.g, c.b, c.a)
	drawTex(self.buttonTex, x - rad, y - rad, rad*2, rad*2)
	love.graphics.setColor(255, 255, 255, 255)
end

function VirtualGamepad:drawLabel(label, x, y, rad, isPressed)
	local c = isPressed and LabelColorPressed or LabelColorIdle
	love.graphics.setColor(c.r, c.g, c.b, c.a)
	self.font:drawLineCentered(label, x, y)
	love.graphics.setColor(255, 255, 255, 255)
end

function VirtualGamepad:drawDirectionButton()
	-- Area
	love.graphics.setLineWidth(3)
	love.graphics.setColor(0, 30, 50, 100)
	love.graphics.circle("fill", self.dirBut.x, self.dirBut.y, 
		self.dirBut.radius, 50)
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setLineWidth(1)
	
	-- Small button
	self:drawButton(self.dirBut.smX, self.dirBut.smY, self.dirBut.smRadius, 
		self.dirBut.isPressed)
end

function VirtualGamepad:drawActionButtons()
	for i = 1, #self.acButtons do
		local b = self.acButtons[i]
		self:drawButton(b.x, b.y, b.radius, b.isPressed)
	end
end

function VirtualGamepad:draw(camera)
	self:drawDirectionButton()
	self:drawActionButtons()
end