require "class"
require "Utils"

GuiElement = class:new()

function GuiElement:init(name, x, y, width, height)
	if name == nil then
		return
	end
	
	self.name = name
	self.x = x
	self.y = y
	self.width = width
	self.height = height
end

-- Inheritance
GuiElement.super = GuiElement.init

function GuiElement:mouseInArea(x, y)
	return pointInRect(x, y, self.x, self.y, self.width, self.height)
end

-- @x, @y are inside gui element
function GuiElement:mouseClick(x, y)

end

-- @x, @y are inside gui element
function GuiElement:mouseRelease(x, y)

end

-- @x, @y are not inside gui element
function GuiElement:mouseReleaseNotInside(x, y)

end

-- @x, @y may not be inside gui element
function GuiElement:mouseMove(x, y, distX, distY)

end

--
-- Touch analogue to Mouse operations
-- By default, the touch is represented as a mouse click.
--

-- @id = identifier of the touch (number)
function GuiElement:touchPress(x, y, id)
	self:mouseClick(x, y)
end

function GuiElement:touchRelease(x, y, id)
	self:mouseRelease(x, y)
end

function GuiElement:touchReleaseNotInside(x, y, id)
	self:mouseReleaseNotInside(x, y)
end

function GuiElement:touchMove(x, y, distX, distY, id)
	self:mouseMove(x, y, distX, distY)
end

-- Tell the gui container that this element wants to get
-- all the text input, keys etc... possible
function GuiElement:processKeys()
	-- VIRTUAL
	return false
end

-- Non-textinput content
-- Don't forget the @return value = true if the key was processed,
-- otherwise false
function GuiElement:keyPress(key)
	return false
end

-- Only textinput content
-- Don't forget the @return value = true if the key was processed,
-- otherwise false
function GuiElement:textInput(text)

end

function GuiElement:update(deltaTime, mouseX, mouseY)

end

-- @camera is mostly unnecessary, but some elements may need it
-- mostly because of the screen / virtual proportions
function GuiElement:draw(camera)

end