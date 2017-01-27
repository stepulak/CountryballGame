require "GuiElement"

-- Offset from the screen border
local VirtualGamepadOffset = 20
local VirtualGamepadPressColorQ = 1.5

local VirtualGamepadDirButColor = {
	r = 0,
	g = 51,
	b = 102,
	a = 255,
}

-- It consist from three sections:
-- *Main direction button (left side of the screen)
-- *A button (right side)
-- *B button (right side)
--
-- And FYI the mouse keyword here refers to touch keyword, because you can
-- use this gamepad with both mouse and touch screen...

VirtualGamepad = GuiElement:new()

function VirtualGamepad:new(virtScrWidth, virtScrHeight, buttonSize, buttonTex)
	self:super("virtual_gamepad", 0, 0, 0, 0)
	
	self.buttonTex = buttonTex
	self.buttonSize = buttonSize
	
	-- Direction button
	self.dirButton = {}
	self.dirButton.size = buttonSize * 2
	self.dirButton.x = VirtualGamepadOffset + self.dirButton.size/2
	self.dirButton.y = virtScrHeight - VirtualGamepadOffset -
		self.dirButton.size/2
	
	-- Small button inside
	self.dirButton.smX = self.dirButton.x
	self.dirButton.smY = self.dirButton.y
end

function VirtualGamepad:mouseInsideButton(x, y, but)
	local dX = x - but.x
	local dY = y - but.y
	return math.sqrt(dX*dX + dY*dY) < but.size
end

function VirtualGamepad:mouseInArea(x, y)
	return self:mouseInsideButton(x, y, self.dirButton) or
		self:mouseInsideButton(x, y, self.aButton) or
		self:mouseInsideButton(x, y, self.bButton)
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

function VirtualGamepad:drawDirectionButton()
	-- Border
	love.graphics.setLineWidth(3)
	love.graphics.setColor(0, 0, 0)
	love.graphics.circle("line", self.dirButton.x, self.dirButton.y,
		self.size, 50)
	love.graphics.setColor(255, 255, 255)
	
	-- Small button inside
end

function VirtualGamepad:draw()
	self:drawDirectionButton()
end