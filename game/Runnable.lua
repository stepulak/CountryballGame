require "class"

--
-- Runnable interface
--

Runnable = class:new()

function Runnable:init()
end

function Runnable:handleKeyPress(key)
end

function Runnable:handleKeyRelease(key)
end

function Runnable:handleTextInput(text)
end

function Runnable:handleMouseClick(x, y)
end

function Runnable:handleMouseRelease(x, y)
end

function Runnable:handleMouseMove(x, y, dx, dy)
end

function Runnable:handleTouchPress(id, tx, ty)
end

function Runnable:handleTouchRelease(id, tx, ty)
end

function Runnable:handleTouchMove(id, tx, ty, tdx, tdy)
end

function Runnable:shouldQuit()
	return false
end

function Runnable:update(deltaTime)
end

function Runnable:draw()
end