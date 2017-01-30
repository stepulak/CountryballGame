require "class"

Credits = class:new()

function Credits:init(scrVirtWidth, scrVirtHeight, fonts, gameLogoTex)
	self.scrVirtWidth = scrVirtWidth
	self.scrVirtHeight = scrVirtHeight
	self.fonts = fonts
	self.gameLogoTex = gameLogoTex
	
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
end

function Credits:addImg(tex, width, height)
	self.content[#self.content + 1] = {
		tex = tex,
		width = width,
		height = height,
	}
end

function Credits:addVerticalSpace()

end

function Credits:update(deltaTime)
	-- TODO
end

function Credits:draw()
	-- TODO
end

-- Fill this credits with actual data related to this game
function Credits:fill()
	self:addImg(self.gameLogoTex,
		self.gameLogoTex:getWidth(), self.gameLogoTex:getHeight())
	self:addVerticalSpace()
	
	self:addLineM("Stepan Trcka")
	self:addLineS("Programming, game design, level design, graphics")
	self:addVerticalSpace()
	
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
end