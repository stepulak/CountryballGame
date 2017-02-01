require "Button"

TexturedButton = Button:new()

function TexturedButton:init(label, font, x, y, width, height, 
	texIdle, texClick, action)
	
	-- inheritance
	if label == nil then
		return
	end
	
	self:buttonSuper(label, font, x, y, width, height, action)
	
	self.texIdle = texIdle
	self.texClick = texClick
end

-- triple inheritance
TexturedButton.texturedButtonSuper = TexturedButton.init

-- Just overwrite the draw function
function TexturedButton:draw()
	local tex = self.clicked and self.texClick or self.texIdle
	
	-- Texture background
	drawTex(tex, self.x, self.y, self.width, self.height)
	
	-- Text
	self.font:drawLineCentered(self.label, self.x + self.width/2,
		self.y + self.height/2)
end