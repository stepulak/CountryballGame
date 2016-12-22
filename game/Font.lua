require "class"

Font = class:new()

-- Font constructor
-- @font is font from Love2D
function Font:init(font)
	self.font = font
end

-- Draw line, [x, y] is top-left corner
function Font:drawLine(str, x, y, scale)
	if scale then
		love.graphics.scale(scale, scale)
	end
	love.graphics.setFont(self.font)
	love.graphics.print(str, x, y)
	love.graphics.scale(1, 1)
end

-- Draw line with center of [x, y]
function Font:drawLineCentered(str, x, y, scale)
	local width = self.font:getWidth(str)
	local height = self.font:getHeight()
	
	if scale then
		width, height = width * scale, height * scale
	end
	
	self:drawLine(str, x - width/2, y - height/2, scale)
end