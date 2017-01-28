require "GuiElement"

-- Offset from the screen border
local VirtualGamepadOffset = 20
local VirtualGamepadPressColorQ = 1.5

local VirtualGamepadButColor = {
	r = 0,
	g = 51,
	b = 102,
	a = 255,
}

-- Gamepad consist of direction joystick and N action buttons (A, B, C, ...)
-- FYI the mouse keyword here refers to touch keyword, because you can
-- use this gamepad with both mouse and touch screen...
VirtualGamepad = GuiElement:new()

function VirtualGamepad:new(virtScrWidth, virtScrHeight, buttonRad, buttonTex)
	self:super("virtual_gamepad", 0, 0, 0, 0)
	
	self.virtScrWidth = virtScrWidth
	self.virtScrHeight = virtScrHeight
	self.buttonRad = buttonRad
	self.buttonTex = buttonTex
	
	-- Direction button
	self.dirBut = {
		radius = buttonRad * 2
	}
	self.dirBut.x = VirtualGamepadOffset + self.dirBut.radius/2
	self.dirBut.y = virtScrHeight - VirtualGamepadOffset -
		self.dirBut.radius/2
	
	-- direction button of "joystick"
	self.dirBut.smX = self.dirBut.x
	self.dirBut.smY = self.dirBut.y
	
	self.acButtons = {}
end

function VirtualGamepad:getNewHorizontalPosButton()
	if #self.acButtons == 0 then
		return self.virtScrWidth - VirtualGamepadOffset
	else
		local b = self.acButtons[#self.acButtons]
		return b.x - b.radius/2 - VirtualGamepadOffset
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
	but.y = self.virtScrHeight - VirtualGamepadOffset
	
	self.acButtons[#self.acButtons + 1] = but
end

function VirtualGamepad:mouseInsideButton(x, y, but)
	local dX = x - but.x
	local dY = y - but.y
	return math.sqrt(dX*dX + dY*dY) < but.radius
end

function VirtualGamepad:mouseInsideActionButtons(x, y)
	for i=1, #self.acButtons do
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

-- Mouse click = touch down
function VirtualGamepad:mouseClick(x, y)
end

-- Touch up
function VirtualGamepad:mouseRelease(x, y)
end

function VirtualGamepad:mouseReleaseNotInside(x, y)
end

function VirtualGamepad:mouseMove(x, y, distX, distY)
end

function VirtualGamepad:draw()
end