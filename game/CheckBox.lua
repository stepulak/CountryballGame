require "CheckButton"

local LabelBackgroundColor = {
	r = 50,
	g = 50,
	b = 50,
	a = 50,
}

CheckBox = GuiElement:new()

function CheckBox:init(label, font, x, y, width, buttonHeight)
	self:super("check_box", x, y, width, font.font:getHeight())
	
	self.label = label
	self.offsetY = self.height
	self.buttons = {}
	self.buttonHeight = buttonHeight
	self.font = font
	self.checkedButton = nil
	self.clickedButton = nil
end

function CheckBox:addCheckButton(label, action)
	-- Create check button
	local but = CheckButton:new(label, self.font, 
		self.x, self.y + self.height, 
		self.width, self.buttonHeight, action)
		
	-- Add it to the list
	self.buttons[#self.buttons + 1] = but
	
	-- Increase current height
	self.height = self.height + self.buttonHeight
	
	return self
end

function CheckBox:getButton(y)
	local index = math.floor((y - self.y - self.offsetY) / self.buttonHeight) + 1
	
	if index >= 1 and index <= #self.buttons then
		return self.buttons[index]
	else
		return nil
	end
end

function CheckBox:mouseClick(x, y)
	self.clickedButton = self:getButton(y)
	
	if self.clickedButton then
		self.clickedButton:mouseClick(x, y)
	end
end

function CheckBox:mouseRelease(x, y)
	local but = self:getButton(y)
	
	if but ~= nil and but == self.clickedButton then
		-- Does exist any old one checked button?
		if self.checkedButton then
			self.checkedButton:mouseRelease(x, y)
		end
		
		but:mouseRelease(x, y)
		self.checkedButton = but
	else
		self:mouseReleaseNotInside(x, y)
	end
end

function CheckBox:mouseReleaseNotInside(x, y)
	if self.clickedButton then
		self.clickedButton:mouseReleaseNotInside(x, y)
		self.clickedButton = nil
	end
end

function CheckBox:draw()
	-- Label background
	drawRectC("fill", self.x, self.y, 
		self.font.font:getWidth(self.label), self.font.font:getHeight(),
		LabelBackgroundColor)
	
	-- Label
	self.font:drawLine(self.label, self.x, self.y)
	
	-- CheckButtons
	for i = 1, #self.buttons do
		self.buttons[i]:draw()
	end
end