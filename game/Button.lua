require "GuiElement"

local ButtonIdleColor = {
	r = 140,
	g = 145,
	b = 171,
	a = 150
}

local ButtonClickedColor = {
	r = 160,
	g = 165,
	b = 191,
	a = 180,
}

Button = GuiElement:new()

function Button:init(label, font, x, y, width, height, action)
	-- inheritance
	if label == nil then
		return
	end
	
	self:super("button", x, y, width, height)
	
	self.label = label
	self.font = font
	self.action = action
	self.clicked = false
end

-- double inheritance
Button.buttonSuper = Button.init

function Button:mouseClick(x, y)
	self.clicked = true
end

function Button:mouseRelease(x, y)
	self.clicked = false
	self.action()
end

function Button:mouseReleaseNotInside(x, y)
	self.clicked = false
	-- Do not perform the action
end

function Button:draw()
	local col = self.clicked and ButtonClickedColor or ButtonIdleColor
	
	-- Background
	drawRectC("fill", self.x, self.y, self.width, self.height, col)
	
	-- Text
	self.font:drawLineCentered(self.label, self.x + self.width/2,
		self.y + self.height/2)
end