require "Runnable"
require "Release"

local ScrollVelocity = 100

Credits = Runnable:new()

function Credits:init(virtScrWidth, virtScrHeight, fonts, textureContainer)
	self.virtScrWidth = virtScrWidth
	self.virtScrHeight = virtScrHeight
	self.fonts = fonts
	self.gameLogoTex = textureContainer:getTexture("game_logo")
	self.backgroundTex = textureContainer:getTexture("credits_background")
	
	self.offset = 0
	self.overallHeight = 0
	self.started = false
	self.quit = false 
	
	self.content = {}
	self.contentIndex = 1
	
	self.gui = GuiContainer:new()
	
	if MOBILE_RELEASE then
		self:insertQuitElement(self.gui, self.fonts.medium, 
			150, self.virtScrWidth, self.virtScrHeight, textureContainer,
			function() self.started = false end, -- @invokeAction
			function() self.quit = true end, -- @quitAction
			function() self.started = true end) -- @continueAction
	end
end

function Credits:addLineM(text)
	self:addLineSpec(text, self.fonts.medium)
end

function Credits:addLineS(text)
	self:addLineSpec(text, self.fonts.small)
end

function Credits:addLineB(text)
	self:addLineSpec(text, self.fonts.big)
end

function Credits:addLineSpec(text, font)
	local h = font.font:getHeight()
	self:addContent({
		text = text,
		font = font,
		height = h,
	}, h)
end

function Credits:addImg(tex, width, height)
	self:addContent({
		tex = tex,
		width = width,
		height = height,
	}, height)
end

function Credits:addVerticalSpaceS()
	self:addVerticalSpaceSpec(10)
end

function Credits:addVerticalSpaceM()
	self:addVerticalSpaceSpec(30)
end

function Credits:addVerticalSpaceB()
	self:addVerticalSpaceSpec(100)
end

function Credits:addVerticalSpaceSpec(space)
	self:addContent({ height = space }, space)
end

function Credits:addContent(content, height)
	content.currHeight = self.overallHeight
	self.content[#self.content + 1] = content
	self.overallHeight = self.overallHeight + height
end

function Credits:shouldQuit()
	return self.offset >= self.overallHeight + self.virtScrHeight 
		or self.quit
end

function Credits:start()
	self.offset = 0
	self.started = true
	self.quit = false
	self.contentIndex = 1
end

function Credits:handleMouseClick(x, y)
	self.gui:mouseClick(x, y)
end

function Credits:handleMouseRelease(x, y)
	self.gui:mouseRelease(x, y)
end

function Credits:handleKeyPress(key)
	if key == "escape" then
		self.quit = true
	end
end

function Credits:update(deltaTime)
	if self.started then
		self.offset = self.offset + ScrollVelocity * deltaTime
		
		local firstContent = self.content[self.contentIndex]
		if firstContent.currHeight + firstContent.height 
			<= self.offset - self.virtScrHeight then
			
			if self.content[self.contentIndex + 1] ~= nil then
				self.contentIndex = self.contentIndex + 1
			end
		end
	end
	
	self.gui:update(deltaTime)
end

function Credits:draw()
	if self.backgroundTex ~= nil then
		drawTex(self.backgroundTex, 0, 0,
			self.virtScrWidth, self.virtScrHeight)
	end
	
	local firstContent = self.content[self.contentIndex]
	local transY = self.virtScrHeight + firstContent.currHeight - self.offset
	local y = 0
	
	love.graphics.translate(0, transY)
	
	for i = self.contentIndex, #self.content do
		local c = self.content[i]
		
		if c.text ~= nil then
			c.font:drawLineCentered(c.text, self.virtScrWidth/2, y)
		elseif c.tex ~= nil then
			drawTex(c.tex, self.virtScrWidth/2 - c.width/2, y,
				c.width, c.height)
		end
		
		y = y + c.height
		
		if y >= self.virtScrHeight + math.abs(transY)*2 then
			-- You do not need to draw anymore, it's outside of the screen
			break
		end
	end
	
	love.graphics.translate(0, -transY)
	
	self.gui:draw()
end

-- Fill this credits with actual data related to this game
function Credits:fill()
	self:addImg(self.gameLogoTex,
		self.gameLogoTex:getWidth(), self.gameLogoTex:getHeight())
	self:addVerticalSpaceB()
	
	--
	-- MAIN DEVELOPMENT
	--
	self:addLineB("Development")
	self:addVerticalSpaceM()
	
	self:addLineM("Stepan Trcka")
	self:addLineS("Programming, game design, level design, graphics")
	self:addVerticalSpaceB()
	
	--
	-- MUSIC
	--
	self:addLineB("Music")
	self:addVerticalSpaceM()
	
	self:addLineM("\"Game Menu\"")
	self:addLineS("by Eric Matyas")
	self:addLineS("www.soundimage.org")
	self:addVerticalSpaceB()
	
	--
	-- SOUNDS
	-- 
	self:addLineB("Sound effects")
	self:addVerticalSpaceM()
	
	self:addLineM("Player shooting")
	self:addLineS("(player_shooting.wav)")
	self:addLineS("Author: Nathan McCoy (Super Tux), GPLv2+CC-by-sa")
	self:addLineS("Source: http://supertux.github.io")
	self:addVerticalSpaceS()
	
	self:addLineM("Player death")
	self:addLineS("(player_death.wav)")
	self:addLineS("MatzeB (Super Tux), GPLv2+CC-by-sa")
	self:addLineS("Source: http://supertux.github.io")
	self:addVerticalSpaceS()
	
	self:addLineM("Player jump")
	self:addLineS("(fart.mp3)")
	self:addLineS("Source: https://www.youtube.com/watch?v=B-uIfFgMPyw")
	self:addVerticalSpaceS()
	
	self:addLineM("Water splash")
	self:addLineS("(splash.mp3)")
	self:addLineS("Author: Michel Baradari, CC-BY 3.0")
	self:addLineS("Source: http://opengameart.org/content/water-splashes")
	self:addVerticalSpaceS()
	
	self:addLineM("Unit smash")
	self:addLineS("(smash.mp3)")
	self:addLineS("Author: Independent.nu, CC0")
	self:addLineS("Source: http://opengameart.org/content/8-wet-squish-slurp-impacts")
	self:addVerticalSpaceS()
	
	self:addLineM("Unit smash 2")
	self:addLineS("(smash_duck.mp3)")
	self:addLineS("Source: https://www.youtube.com/watch?v=B-uIfFgMPyw")
	self:addVerticalSpaceS()
	
	self:addLineM("Canon shot")
	self:addLineS("(canon_shot.ogg)")
	self:addLineS("Author: Stephen M. Cameron, CC-BY-SA 3.0")
	self:addLineS("Source: http://opengameart.org/content/action-shooter-soundset-wwvi")
	self:addVerticalSpaceS()
	
	self:addLineM("Boost spawn")
	self:addLineS("(boost_spawn.mp3)")
	self:addLineS("Author: ViRiX, CC-BY 3.0")
	self:addLineS("Source: http://opengameart.org/content/ui-and-item-sound-effect-jingles-sample-2")
	self:addVerticalSpaceS()
	
	self:addLineM("Boost pick")
	self:addLineS("(boost_pick.mp3)")
	self:addLineS("Author: ViRiX, CC-BY 3.0")
	self:addLineS("Source: http://opengameart.org/content/ui-and-item-sound-effect-jingles-sample-2")
	self:addVerticalSpaceS()
	
	self:addLineM("Freeze")
	self:addLineS("(freeze.mp3)")
	self:addLineS("Author: artisticdude, CC0")
	self:addLineS("Source: http://opengameart.org/content/freeze-spell-0")
	self:addVerticalSpaceS()
	
	self:addLineM("Coin pick")
	self:addLineS("(coin_pick.wav)")
	self:addLineS("Author: Luke.RUSTLTD, CC0")
	self:addLineS("Source: http://opengameart.org/content/10-8bit-coin-sounds")
	self:addVerticalSpaceS()
	
	self:addLineM("Block break")
	self:addLineS("(block_break.mp3)")
	self:addLineS("Author: Independent.nu, CC0")
	self:addLineS("Source: http://opengameart.org/content/5-break-crunch-impacts")
	self:addVerticalSpaceS()
	
	self:addLineM("Block bounce")
	self:addLineS("(block_bounce.mp3)")
	self:addLineS("Author: Independent.nu, CC0")
	self:addLineS("Source: http://opengameart.org/content/35-wooden-crackshitsdestructions")
	self:addVerticalSpaceS()
	
	self:addLineM("Block break unable")
	self:addLineS("(block_unable.wav)")
	self:addLineS("Author: Yaniel, (Super Tux) GPLv2+CC-by-sa")
	self:addLineS("Source: http://supertux.github.io")
	self:addVerticalSpaceS()
	
	self:addLineM("Explosion")
	self:addLineS("(explosion.mp3)")
	self:addLineS("Source: https://www.youtube.com/watch?v=B-uIfFgMPyw")
	self:addVerticalSpaceS()
	
	self:addLineM("Forest rain")
	self:addLineS("(forest_rain.mp3)")
	self:addLineS("Author: Alexander, CC BY-NC 4.0")
	self:addLineS("Source: http://www.orangefreesounds.com/forest-rain-sound/")
	self:addVerticalSpaceS()
	
	self:addLineM("Canonball smash")
	self:addLineS("(canonball_smash.mp3)")
	self:addLineS("Source: https://www.youtube.com/watch?v=B-uIfFgMPyw")
	self:addVerticalSpaceS()
	
	self:addLineM("Unit death")
	self:addLineS("(unit_death.wav)")
	self:addLineS("Author: Nathan McCoy (Super Tux), GPLv2+CC-by-sa")
	self:addLineS("Source: http://supertux.github.io")
	self:addVerticalSpaceS()
	
	self:addLineM("Life up")
	self:addLineS("(lifeup.wav)")
	self:addLineS("Author: Nathan McCoy (Super Tux), GPLv2+CC-by-sa")
	self:addLineS("Source: http://supertux.github.io")
	self:addVerticalSpaceS()
	
	self:addLineM("Turtle bump")
	self:addLineS("(turtle_bump.wav)")
	self:addLineS("Author: Some_Person (Super Tux), GPLv2+CC-by-sa")
	self:addLineS("Source: http://supertux.github.io")
	self:addVerticalSpaceS()
	
	self:addLineM("Turtle touch")
	self:addLineS("(turtle_touch.wav)")
	self:addLineS("Author: Some_Person (Super Tux), GPLv2+CC-by-sa")
	self:addLineS("Source: http://supertux.github.io")
	self:addVerticalSpaceS()
	
	self:addLineM("Rocket engine blast")
	self:addLineS("(rocket_engine.mp3)")
	self:addLineS("Author: dobroride, CC Sampling Plus 1.0")
	self:addLineS("Source: http://soundbible.com/1498-Rocket.html")
	self:addVerticalSpaceB()
	
	--
	-- SPECIAL THANKS
	--
	self:addLineB("Special thanks to")
	self:addVerticalSpaceM()
	
	self:addLineM("Textcraft - https://textcraft.net")
	self:addLineS("Text & logo maker")
	self:addVerticalSpaceM()
	
	self:addLineM("Lua - https://www.lua.org")
	self:addLineS("Lua - the programming language")
	self:addVerticalSpaceM()
	
	self:addLineM("LOVE2D - https://love2d.org")
	self:addLineS("2D *awesome* game development framework")
	self:addVerticalSpaceM()
	
	self:addVerticalSpaceB()
	self:addLineM("(c) 2017 Stepan Trcka")
	self:addVerticalSpaceS()
	self:addLineM("https://github.com/stepulak/CountryballGame")
	self:addVerticalSpaceB()
	
	return self
end