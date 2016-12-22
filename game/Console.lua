require "GuiElement"

-- Console is Windows/Linux/OS X component only!

Console = GuiElement:new()

function Console:init(x, y, font)
	self:super("console", x, y, 0, 0)
	
	self.font = font
	self.height = font.font:getHeight()
	
	self.content = ""
	self.contentReady = false -- Content is ready to be extracted
	
	-- Content's index and it's real position on the screen
	self.index = 0
	self.indexPosition = 0
	
	-- Is console active?
	self.isActive = false
end

function Console:mouseInArea(x, y)
	-- Skip clicking
	return false
end

function Console:setisActive()
	self.isActive = true
	love.keyboard.setTextInput(true)
end

function Console:setInisActive()
	self.isActive = false
	love.keyboard.setTextInput(false)
end

-- Get the console's content a remove it
function Console:getContent()
	local content = self.content
	
	self.content = ""
	self.contentReady = false
	self.index = 0
	self.indexPosition = 0
	
	return content
end

function Console:processKeys()
	return true
end

function Console:removeCharacterAtIndex()
	if self.content ~= "" and self.index > 0 then
		self.content = string.sub(self.content, 1, self.index - 1) ..
			string.sub(self.content, self.index + 1)
		
		self:indexDecrease()
	end
end

function Console:countIndexPosition()
	self.indexPosition = self.font.font:getWidth(
		string.sub(self.content, 1, self.index))
end

function Console:indexDecrease()
	self.index = self.index - 1
	
	if self.index < 0 then
		self.index = 0
	end
	
	self:countIndexPosition()
end

function Console:indexIncrease()
	self.index = self.index + 1
	
	if self.index > string.len(self.content) then
		self.index = string.len(self.content)
	end
	
	self:countIndexPosition()
end

function Console:keyPress(key)
	if key == "t" then
		self:setisActive()
		return true 
	elseif self.isActive then
		if key == "return" then
			self.contentReady = true
			self:setInisActive()
		elseif key == "escape" then
			self:setInisActive()
		elseif key == "backspace" then
			self:removeCharacterAtIndex()
		elseif key == "left" then
			self:indexDecrease()
		elseif key == "right" then
			self:indexIncrease()
		end
		
		return true
	end
	
	return false
end

function Console:textInput(text)
	if self.isActive then
		-- Add the text after index
		self.content = string.sub(self.content, 1, self.index) .. text ..
			string.sub(self.content, self.index + 1)

		-- Update index
		self.index = self.index + string.len(text)
		self:countIndexPosition()
		
		return true
	else
		return false
	end
end

function Console:draw()
	-- Text
	self.font:drawLine(self.content, self.x, self.y)
	
	-- Cursor
	love.graphics.setColor(255, 0, 0)
	love.graphics.line(self.x + self.indexPosition, self.y - 2, 
		self.x + self.indexPosition, self.y + self.height + 2)
	love.graphics.setColor(255, 255, 255)
end