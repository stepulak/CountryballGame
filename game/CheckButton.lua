require "GuiElement"

local BackgroundColor = {
	r = 100,
	g = 105,
	b = 100,
	a = 150
}

local CircleClickColor = {
	r = 70,
	g = 70,
	b = 70,
	a = 255,
}

local CircleIdleColor = {
	r = 10,
	g = 10,
	b = 10,
	a = 255
}

CheckButton = GuiElement:new()

function CheckButton:init(label, font, x, y, width, height, action)
	self:super("check_button", x, y, width, height)
	
	self.label = label
	self.font = font
	self.action = action
	self.clicked = false
	self.checked = false
	self.circleRad = height/3
end

function CheckButton:mouseClick(x, y)
	self.clicked = true
end

function CheckButton:mouseRelease(x, y)
	self.clicked = false
	self.checked = not self.checked
	self.action(self.checked)
end

function CheckButton:mouseReleaseNotInside(x, y)
	self.clicked = false
end

function CheckButton:draw()
	-- Background
	drawRectC("fill", self.x, self.y, self.width, self.height,
		BackgroundColor)
	
	local c = self.clicked and CircleClickColor 
		or CircleIdleColor
	
	love.graphics.push()
	love.graphics.translate(self.x + self.circleRad + 2, 
		self.y + self.height/2)

	-- "Check" circle
	love.graphics.setColor(c.r, c.g, c.b, c.a)
	love.graphics.setLineWidth(2)
	love.graphics.circle("line", 0, 0, self.circleRad, 20)
	love.graphics.setLineWidth(1)
	
	-- If it's also checked, then draw inside the check circle smaller
	-- circle, but whole filled with color
	if self.checked then
		love.graphics.circle("fill", 0, 0, self.circleRad * 0.8, 20)
	end
	
	love.graphics.pop()
	
	-- Text
	love.graphics.setColor(255, 255, 255, 255)
	self.font:drawLineCentered(self.label, 
		self.x + self.width/2 + self.circleRad,
		self.y + self.height/2)
end