require "Runnable"
require "Release"

local BackButtonWidth = 200

Controls = Runnable:new()

function Controls:init(virtScrWidth, virtScrHeight, fonts, textureContainer)
	self.virtScrWidth = virtScrWidth
	self.virtScrHeight = virtScrHeight
	self.fonts = fonts
	
	self.quit = false
	self.gui = GuiContainer:new()
	
	local font = fonts.medium
	local butHeight = font.font:getHeight() * 1.8
	
	self.gui:addElement(TexturedButton:new(
		"Back",
		font,
		virtScrWidth/2 - BackButtonWidth/2,
		virtScrHeight - butHeight*2,
		BackButtonWidth,
		butHeight,
		textureContainer:getTexture("button_idle"),
		textureContainer:getTexture("button_click"),
		function() self.quit = true end))
end

function Controls:start()
	self.quit = false
end

function Controls:shouldQuit()
	return self.quit
end

function Controls:handleMouseClick(x, y)
	self.gui:mouseClick(x, y)
end

function Controls:handleMouseRelease(x, y)
	self.gui:mouseRelease(x, y)
end

function Controls:handleTouchPress(id, x, y)
	self.gui:touchPress(id, x, y)
end

function Controls:handleTouchRelease(id, x, y)
	self.gui:touchRelease(id, x, y)
end

function Controls:handleKeyPress(key)
	if key == "escape" then
		self.quit = true
	end
end

function Controls:update(deltaTime)
	self.gui:update(deltaTime)
end

function Controls:drawControls()
	local f = self.fonts.big
	local x = self.virtScrWidth/2
	local y = 100
	local offsetY = f.font:getHeight() * 1.2
	
	if MOBILE_RELEASE then
		f:drawLineCentered("Gamepad Left - Left Movement", x, y)
		y = y + offsetY
		f:drawLineCentered("Gamepad Right - Right Movement", x, y)
		y = y + offsetY
		f:drawLineCentered("X - Jump", x, y)
		y = y + offsetY
		f:drawLineCentered("Y - Shooting / Sprint Activation", x, y)
		y = y + offsetY
		f:drawLineCentered("Gamepad Up + X - Teleport Activation", x, y)
		y = y + offsetY
		f:drawLineCentered("Gamepad Down + X - Jump Off Platform", x, y)
	else
		f:drawLineCentered("A / D - Left / Right Movement", x, y)
		y = y + offsetY
		f:drawLineCentered("SPACE - Jump", x, y)
		y = y + offsetY
		f:drawLineCentered("M - Shooting / Sprint Activation", x, y)
		y = y + offsetY
		f:drawLineCentered("W + SPACE - Teleport Activation", x, y)
		y = y + offsetY
		f:drawLineCentered("S + SPACE - Jump Off Platform", x, y)
	end
end

function Controls:draw()
	self:drawControls()
	self.gui:draw()
end