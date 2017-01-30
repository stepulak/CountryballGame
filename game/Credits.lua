require "Runnable"

local ScrollVelocity = 50

Credits = Runnable:new()

function Credits:init(scrVirtWidth, scrVirtHeight, fonts, gameLogoTex)
	self.scrVirtWidth = scrVirtWidth
	self.scrVirtHeight = scrVirtHeight
	self.fonts = fonts
	self.gameLogoTex = gameLogoTex
	
	self.offset = 0
	self.overallHeight = 0
	
	self.content = {}
end

function Credits:addLineM(text)
	self:addLineSpec(text, self.fonts.medium)
end

function Credits:addLineS(text)
	self:addLineSpec(text, self.fonts.small)
end

function Credits:addLineSpec(text, font)
	self.content[#self.content + 1] = {
		text = text,
		font = font
	}
	self.overallHeight = self.overallHeight + font:getHeight()
end

function Credits:addImg(tex, width, height)
	self.content[#self.content + 1] = {
		tex = tex,
		width = width,
		height = height,
	}
	self.overallHeight = self.overallHeight + height
end

function Credits:addVerticalSpaceS()
	self:addVerticalSpaceSpec(10)
end

function Credits:addVerticalSpaceM()
	self:addVerticalSpaceSpec(30)
end

function Credits:addVerticalSpaceSpec(prop)
	self.content[#self.content + 1] = {
		space = prop,
	}
	self.overallHeight = self.overallHeight + prop
end

function Credits:shouldQuit()
	return self.offset >= self.overallHeight
end

function Credits:update(deltaTime)
	self.offset = self.offset + ScrollVelocity * deltaTime
end

function Credits:draw()

end

-- Fill this credits with actual data related to this game
function Credits:fill()
	self:addImg(self.gameLogoTex,
		self.gameLogoTex:getWidth(), self.gameLogoTex:getHeight())
	self:addVerticalSpace()
	
	self:addLineM("Stepan Trcka")
	self:addLineS("Programming, game design, level design, graphics")
	self:addVerticalSpaceM()
	
	--
	-- SOUNDS
	-- 
	self:addLineM("Sounds")
	
	self:addLineM("Player shoot (player_shoot.wav)")
	self:addLineS("Author: Nathan McCoy (Super Tux), GPLv2+CC-by-sa")
	
	self:addLineM("Player death (player_death.wav)")
	self:addLineS("MatzeB (Super Tux), GPLv2+CC-by-sa")
	
	self:addLineM("Water splash (splash.mp3)")
	self:addLineS("Author: Michel Baradari, CC-BY 3.0")
	self:addLineS("Source: http://opengameart.org/content/water-splashes")
	
	self:addLineM("Unit smash (smash.mp3)")
	self:addLineS("Author: Independent.nu, CC0")
	self:addLineS("Source: http://opengameart.org/content/8-wet-squish-slurp-impacts")
	
	self:addLineM("Player jump (fart.mp3)")
	self:addLineS("Source: https://www.youtube.com/watch?v=B-uIfFgMPyw")
	
	self:addVerticalSpace()
	
	return self
end