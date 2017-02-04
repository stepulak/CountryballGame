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
-- @action = "keyPress", "textInput"
function GuiContainer:processKeyInput(action, value)
	local result = false
	
	for i = 1, #self.elems do
		if self.elems[i]:processKeys() then
			result = self.elems[i][action](self.elems[i], value) or result
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

-- @action is either "mouseClick" or "touchPress"
-- If the @action is "touchPress", then the touch id must be available aswell
function GuiContainer:applyPress(x, y, action, ...)
	local handled = false
	local id = ...
	
	for i = 1, #self.elems do
		local e = self.elems[i]
		
		if e:mouseInArea(x, y) then
			-- Call the action
			e[action](e, x, y, id)
			
			-- push it into the queue
			self.clickedElems[self.clickedElems.right] = e
			self.clickedElems.right = self.clickedElems.right + 1
			
			handled = true
		end
	end
	
	return handled
end

-- @action is either "mouseRelease" or "touchRelease"
-- If the @action is "touchRelease", then the touch id must be available aswell
function GuiContainer:applyRelease(x, y, action, ...)
	local handled = self.clickedElems.left < self.clickedElems.right
	local id = ...
	
	for i = self.clickedElems.left, self.clickedElems.right - 1 do
		local e = self.clickedElems[i]
		
		if e:mouseInArea(x, y) then
			e[action](e, x, y, id)
		else
			e[action .. "NotInside"](e, x, y, id)
		end
	end
	self.clickedElems.left = self.clickedElems.right
	
	return handled
end

function GuiContainer:mouseClick(x, y)
	return self:applyPress(x, y, "mouseClick")
end

function GuiContainer:mouseRelease(x, y)
	return self:applyRelease(x, y, "mouseRelease")
end

function GuiContainer:mouseMove(x, y, dx, dy)
	for i = 1, #self.elems do
		self.elems[i]:mouseMove(x, y, dx, dy)
	end
end

-- TOUCH
function GuiContainer:touchPress(id, x, y)
	return self:applyPress(x, y, "touchPress", id)
end

function GuiContainer:touchRelease(id, x, y)
	return self:applyRelease(x, y, "touchRelease", id)
end

function GuiContainer:touchMove(id, x, y, dx, dy)
	for i = 1, #self.elems do
		self.elems[i]:touchMove(x, y, dx, dy, id)
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