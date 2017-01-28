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

-- Gamepad consist of direction joystick and N action buttons (A, B, C, ...)
-- FYI the mouse keyword here refers to touch keyword, because you can
-- use this gamepad with both mouse and touch screen...
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
		radius = buttonRad * 2.5
	}
	self.dirBut.x = ButtonOffset + self.dirBut.radius
	self.dirBut.y = virtScrHeight - ButtonOffset - self.dirBut.radius
	
	-- direction button of "joystick"
	self.dirBut.smX = self.dirBut.x
	self.dirBut.smY = self.dirBut.y
	
	self.dirBut.isPressed = false
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
-- @actionReleased trigger func when button is released
function VirtualGamepad:addActionButton(label, actionPressed, actionReleased)
	local but = {}
	
	but.label = string.sub(label, 1)
	but.actionPressed = actionPressed
	but.actionReleased = actionReleased
	but.radius = self.buttonRad
	but.x = self:getNewHorizontalPosButton() - but.radius/2
	but.y = self.virtScrHeight - ButtonOffset
	but.isPressed = false
	
	self.acButtons[#self.acButtons + 1] = but
	
	return self
end

-- Return the current direction of direction button (joystick)
-- possible values: {[x, y] | x <- {-1,0,1}, y <- {-1,0,1}}
function VirtualGamepad:getDirection()
	return 0, 0
end

function VirtualGamepad:mouseInsideButton(x, y, but)
	local dX = x - but.x
	local dY = y - but.y
	return math.sqrt(dX*dX + dY*dY) < but.radius
end

function VirtualGamepad:mouseInsideActionButtons(x, y)
	for i = 1, #self.acButtons do
		if mouseInsideButton(x, y, self.acButtons[i]) then
			return true
		end
	end
	
	return false
end

function VirtualGamepad:mouseInArea(x, y)
	return self:mouseInsideButton(x, y, self.dirBut) or
		self:mouseInsideActionButtons(x, y)
end

function VirtualGamepad:mouseClick(x, y)
end

function VirtualGamepad:mouseRelease(x, y)
end

function VirtualGamepad:mouseReleaseNotInside(x, y)
end

function VirtualGamepad:mouseMove(x, y, distX, distY)
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
	self:drawButton(self.dirBut.smX, self.dirBut.smY, self.buttonRad, 
		self.dirBut.pressed)
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