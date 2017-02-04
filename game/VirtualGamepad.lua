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

function VirtualGamepad:init(camera, font, buttonRad, buttonTex)
	self:super("virtual_gamepad", 0, 0, 0, 0)
	
	self.camera = camera
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
	self.dirBut.y = self.camera.virtualHeight 
		- ButtonOffset - self.dirBut.radius
	
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
	
	-- Only available for direction button!
	self.dirBut.actionMove = function(b, x, y)
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
		return self.camera.virtualWidth
	else
		local b = self.acButtons[#self.acButtons]
		return b.x - b.radius/2 - ButtonOffset
	end
end

-- @label should be one-character-long (doesn't matter actually,
-- first character is taken anyway)
-- @actionPressed trigger func when button is pressed
-- @actionReleased trigger func when button is released
function VirtualGamepad:addActionButton(label, actionPressed, actionReleased)
	local but = {}
	
	but.label = string.sub(label, 1)
	but.radius = self.buttonRad
	but.x = self:getNewHorizontalPosButton() - ButtonOffset - but.radius
	but.y = self.camera.virtualHeight - ButtonOffset - but.radius
	but.isPressed = false
	but.actionPressed = actionPressed
	but.actionReleased = actionReleased
	
	self.acButtons[#self.acButtons + 1] = but
	
	return self
end

-- Return the current direction of direction button (joystick)
-- @return [-1,1], [-1,1]
function VirtualGamepad:getDirection()
	local dMax = self.dirBut.radius - self.dirBut.smRadius
	local dX = self.dirBut.smX - self.dirBut.x
	local dY = self.dirBut.smY - self.dirBut.y
	
	return dX/dMax, dY/dMax
end

function VirtualGamepad:mouseInsideButton(x, y, but)
	local dX = x - but.x
	local dY = y - but.y
	return math.sqrt(dX*dX + dY*dY) < but.radius
end

-- @x, @y are mouse (touch) virtual coordinates
function VirtualGamepad:getActionButtonUnderTouch(x, y)
	for i = 1, #self.acButtons do
		if self:mouseInsideButton(x, y, self.acButtons[i]) then
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
		self.click:actionReleased(x, y)
		self.click.isPressed = false
		-- Processed
		self.click = nil
	end
end

function VirtualGamepad:mouseReleaseNotInside(x, y)
	self:mouseRelease(x, y)
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
	if self.touches[id] ~= nil then
		self:touchRelease(-1, -1, id)
	end
	
	local but = self:getButtonUnderTouch(x, y)
	
	if but ~= nil then
		self.touches[id] = but
		but:actionPressed(x, y)
		but.isPressed = true
	end
end

function VirtualGamepad:touchRelease(x, y, id)
	if self.touches[id] ~= nil then
		self.touches[id]:actionReleased(x, y)
		self.touches[id].isPressed = false
		self.touches[id] = nil
	end
end

function VirtualGamepad:touchReleaseNotInside(x, y, id)
	self:touchRelease(x, y, id)
end

function VirtualGamepad:touchMove(x, y, distX, distY, id)
	-- You can use this only on joystick (direction button)
	if self.touches[id] == self.dirBut then
		self.dirBut:actionMove(distX, distY)
	end
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
		self:drawLabel(b.label, b.x, b.y, b.radius, b.isPressed)
	end
end

function VirtualGamepad:draw(camera)
	self:drawDirectionButton()
	self:drawActionButtons()
end