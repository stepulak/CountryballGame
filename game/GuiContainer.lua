require "GuiElement"

GuiContainer = class:new()

function GuiContainer:init()
	self.elems = {}
	-- simple queue
	self.clickedElems = { left = 0, right = 0 }
end

function GuiContainer:addElement(elem)
	self.elems[1 + #self.elems] = elem
end

-- Process key input (key press, textinput)
-- @fnName = "keyPress", "textInput"
function GuiContainer:processKeyInput(fnName, value)
	local result = false
	
	for i = 1, #self.elems do
		if self.elems[i]:processKeys() then
			result = self.elems[i][fnName](self.elems[i], value) or result
		end
	end
	
	return result
end

function GuiContainer:keyPress(key)
	return self:processKeyInput("keyPress", key)
end

function GuiContainer:textInput(text)
	return self:processKeyInput("textInput", text)
end

function GuiContainer:mouseClick(x, y)
	local clickHandled = false
	
	for i = 1, #self.elems do
		if self.elems[i]:mouseInArea(x, y) then
			self.elems[i]:mouseClick(x, y)
			
			clickHandled = true
			
			-- push it into the queue
			self.clickedElems[self.clickedElems.right] = self.elems[i]
			self.clickedElems.right = self.clickedElems.right + 1
		end
	end
	
	return clickHandled
end

function GuiContainer:mouseRelease(x, y)
	for i = self.clickedElems.left, self.clickedElems.right - 1 do
		if self.clickedElems[i]:mouseInArea(x, y) then
			self.clickedElems[i]:mouseRelease(x, y)
		else
			self.clickedElems[i]:mouseReleaseNotInside(x, y)
		end
	end
	local releaseHandled = self.clickedElems.left < self.clickedElems.right
	
	self.clickedElems.left = self.clickedElems.right
	
	return releaseHandled
end

function GuiContainer:mouseMove(x, y, dx, dy)
	for i = 1, #self.elems do
		self.elems[i]:mouseMove(x, y, dx, dy)
	end
end

function GuiContainer:update(deltaTime, mouseX, mouseY)
	for i = 1, #self.elems do
		self.elems[i]:update(deltaTime, mouseX, mouseY)
	end
end

function GuiContainer:draw(camera)
	for i = 1, #self.elems do
		self.elems[i]:draw(camera)
	end
end