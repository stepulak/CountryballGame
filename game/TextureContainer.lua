require "class"
require "TextureAnimation"

TextureContainer = class:new()

function TextureContainer:init()
	self.animations = {}
	self.textures = {}
end

-- Add new animation to the container
function TextureContainer:addAnimation(name, animation)
	self.animations[name] = animation
end

-- Add new texture to the container
function TextureContainer:addTexture(name, texture)
	self.textures[name] = texture
end

-- Get animation from the container
function TextureContainer:getAnimation(name)
	return self.animations[name]
end

-- Get texture from the container
function TextureContainer:getTexture(name)
	return self.textures[name]
end

-- Create an animation with single texture
function TextureContainer:newAnimationWithOneTexture(name, file)
	self:newTexture(name, file)
	self:addAnimation(name, TextureAnimation:new(-1)
		:addTexture(self:getTexture(name)))
end

-- Create an animation with unspecified number of textures
function TextureContainer:newAnimation(name, updateTime, ...)
	local arg = { ... }
	
	self:addAnimation(name, TextureAnimation:new(updateTime))
	
	for i=1, #arg do
		-- Create unique name for each texture
		local textureName = name .. tostring(i)
		
		-- Create texture and add it to the container
		self:getAnimation(name):addTexture(
			self:getTexture(textureName, self:newTexture(textureName, arg[i])))
	end
end

-- Create a new texture
function TextureContainer:newTexture(name, file)
	self:addTexture(name, love.graphics.newImage(file))
end