require "class"
require "Utils"

TextureAnimation = class:new()

function TextureAnimation:init(updateTime)
	self.textures = {}
	self.updateTime = updateTime
	self.textureIndex = 1
	self.timer = 0
end

-- Get copy of texture animation
-- But do not copy the textures themself
function TextureAnimation:getCopy()
	return clone(self, false)
end

-- Get copy of texture animation, copy array of texture references aswell
function TextureAnimation:deepCopy()
	local c = self:getCopy()
	c.textures = {}
	
	for i=1, #self.textures do
		c.textures[i] = self.textures[i]
	end
	
	return c
end

-- Reverse order of textures of this animation
function TextureAnimation:reverse()
	local n = #self.textures
	local texs = {}
	
	for i=n, 1, -1 do
		texs[i] = self.textures[n-i+1]
	end
	self.textures = texs
	
	return self
end

-- Get all textures from @anim and add it to @self
function TextureAnimation:concat(anim)
	for i=1, #anim.textures do
		self.textures[#self.textures + 1] = anim.textures[i]
	end
	return self
end

-- Add new texture into animation
function TextureAnimation:addTexture(texture)
	self.textures[#self.textures + 1] = texture
	return self
end

-- Add new texture into animation @n times
function TextureAnimation:addTextureN(texture, n)
	for i=1, n do
		self.textures[#self.textures + 1] = texture
	end
	return self
end

-- Return number of textures in this animation
function TextureAnimation:numTextures()
	return #self.textures
end

-- Reset updating stats
function TextureAnimation:reset()
	self.textureIndex = 1
	self.timer = 0
end

function TextureAnimation:nextTexture()
	self.textureIndex = self.textureIndex + 1
	if self.textureIndex > #self.textures then
		self.textureIndex = 1
	end
end

function TextureAnimation:firstTexture()
	return self.textures[1]
end

-- Update animation and possibly swap textures
function TextureAnimation:update(deltaTime)
	if self.updateTime < 0 then
		return
	end
	
	self.timer = self.timer + deltaTime
	if self.timer >= self.updateTime then
		self.timer = self.timer - self.updateTime
		self:nextTexture()
	end
end

-- Get active texture which is ought to be drawn
function TextureAnimation:getActiveTexture()
	return self.textures[self.textureIndex]
end

-- Draw texture animation
function TextureAnimation:draw(camera, x, y, w, h, angle, flip)
	local tex = self.textures[self.textureIndex]
	local texW, texH = tex:getDimensions()
	
	love.graphics.push()
	love.graphics.translate(x + w/2 - camera.x, y + h/2 - camera.y)
	
	if angle ~= 0 then
		love.graphics.rotate(math.rad(angle))
	end
	
	if flip then
		drawTexFlipped(tex, -w/2, -h/2, w, h)
	else
		drawTex(tex, -w/2, -h/2, w, h)
	end
	
	love.graphics.pop()
end