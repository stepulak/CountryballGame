require "Runnable"
require "ParticleSystem"

local DoubleClickTime = 0.5
local SlideMovementDist = 100
local SlideZoomQ = 0.5
local SlideTimeToEnd = 1
local StdSubtitlesColor = { r = 255, g = 255, b = 255 }

AnimationScene = Runnable:new()

function AnimationScene:init(virtScrWidth, virtScrHeight,
	font, soundContainer, sinCosTable)
	
	self.virtScrWidth = virtScrWidth
	self.virtScrHeight = virtScrHeight
	self.font = font
	self.soundContainer = soundContainer
	self.sinCosTable = sinCosTable
	
	self.quit = false
	self.paused = true
	self.lastClickTimer = 999
	self.shouldEnd = false
	self.timerToEnd = 0
	self.slideLastTime = 7
	
	self.slides = {}
	self.activeSlideIndex = 1
	
	self.particleSystem = ParticleSystem:new()
	
	self.backgroundMusic = nil
	self.backgroundColor = nil
end

-- @movemenType = "horizontal", "vertical", "diagonal", "static", "zoom_out", "zoom_in"
-- @fadeType = "fade_in", "fade_out", "fade_in_wait", "fade_in_out", "static"
--
-- If @texW or @texH is nil, then default @texture proportion is used...
--
-- @opts consist of optinal values:
-- 	@opts.backgroundColor - use this background color instead 
--								of default background color
-- 	@opts.lastTime - if not set, then self.slideLastTime is used
-- 	@opts.subtitles - array of texts
--  @opts.subtitlesColor - color of subtitles
-- 	@opts.speechSoundName - speech sound which will be played
--								 during slide's presentation
--  @opts.zoomVel - use this velocity instead of default zoom velocity
function AnimationScene:addTextureSlide(texture, texW, texH,
	movementType, fadeType, opts)
	
	local slide = {
		texture = texture,
		texW = texW or texture:getWidth(),
		texH = texH or texture:getHeight(),
		movementType = movementType,
		fadeType = fadeType,
		shouldEnd = false, -- for particle's update func
	}
	
	local opts_ = opts or {}
	
	if opts_.speechSoundName ~= nil then
		local sound = self.soundContainer:getEffect(opts_.speechSoundName)
		
		if sound ~= nil then
			slide.speechSoundName = opts_.speechSoundName
			
			-- Setup the slide duration - choose higher time
			local dur = sound:getDuration()
			slide.lastTime = dur < self.slideLastTime and self.slideLastTime or dur
		end
	end
	
	if slide.lastTime == nil then
		-- Last time still not set
		slide.lastTime = opts_.lastTime or self.slideLastTime
	end
	
	if opts_.subtitles ~= nil then
		slide.subtitles = opts_.subtitles
		slide.subtitlesIndex = 1
		slide.subtitlesTimer = 0
		slide.subtitlesUpdateTime = slide.lastTime/#slide.subtitles
		slide.subtitlesColor = opts_.subtitlesColor or StdSubtitlesColor
	end
	
	slide.backgroundColor = opts_.backgroundColor
	slide.zoomVel = opts_.zoomVel or 0.1
	
	-- Add it into the list
	self.slides[#self.slides + 1] = slide
end

-- Create slide particle 
function AnimationScene:createSlideParticle(slide)
	local mvType = slide.movementType
	local fdType = slide.fadeType
	
	local w, h = slide.texW, slide.texH
	local x = (self.virtScrWidth - w)/2
	local y = (self.virtScrHeight - h)/2
	local angle, vel, propVelQ = 0, 0, 0
	local fadeType = "none"
	local endTime = slide.lastTime
	local skipParticleSystem = false
	
	if mvType == "horizontal" then
		x = x - SlideMovementDist/2
		vel = SlideMovementDist/endTime
	elseif mvType == "vertical" then
		y = y - SlideMovementDist/2
		angle = 270
		vel = SlideMovementDist/endTime
	elseif mvType == "diagonal" then
		local qXY = self.virtScrWidth/self.virtScrHeight
		x = x - SlideMovementDist/2 * qXY
		y = y - SlideMovementDist/2 * (1/qXY)
		angle = 315
		vel = SlideMovementDist/endTime
	elseif mvType == "zoom_out" then
		propVelQ = -slide.zoomVel
	elseif mvType == "zoom_in" then
		propVelQ = slide.zoomVel
	end
	
	if fdType == "fade_in" then
		fadeType = "in"
	elseif fdType == "fade_out" then
		fadeType = "out"
	elseif fdType == "fade_in_wait" then
		fadeType = "in"
		
		-- If there is any active background music, wait till it ends
		local mus = self.soundContainer:getMusic(self.backgroundMusic)
		if mus ~= nil then
			endTime = mus:getDuration() - mus:tell()
			slide.lastTime = endTime
			--vel = SlideMovementDist/endTime
		end
	elseif fdType == "fade_in_out" then
		fadeType = "both"
	end
	
	if skipParticleSystem == false then
		self.particleSystem:addSlideParticle(
			slide.texture,
			x + w/2, y + h/2, w, h,
			angle, vel, propVelQ,
			fadeType,
			endTime,
			slide,
			-- Spec. update function
			function(particle, cam, deltaTime)
				-- Let this particle die
				if particle.userData.shouldEnd then
					particle.userData.shouldEnd = false
					particle.timer = particle.endTime
				end
			end)
	end
end

function AnimationScene:addBackgroundMusic(musicName)
	self.backgroundMusic = musicName
end

function AnimationScene:setBackgroundColor(color)
	self.backgroundColor = color
end

function AnimationScene:setSlideLastTime(lastTime)
	self.slideLastTime = lastTime
end

-- Let completely end the scene after some time
function AnimationScene:endIntro()
	self.shouldEnd = true 
	self.timerToEnd = SlideTimeToEnd
end

function AnimationScene:activateSlide(slide)
	if slide ~= nil then
		self:createSlideParticle(slide)
		-- Does it have speech? Play it
		if slide.speechSoundName ~= nil then
			self.soundContainer:playEffect(slide.speechSoundName)
		end
	else
		self:endIntro()
	end
end

function AnimationScene:nextSlide()
	local ac = self.slides[self.activeSlideIndex]
	self.activeSlideIndex = self.activeSlideIndex + 1
	self:activateSlide(self.slides[self.activeSlideIndex])
end

-- Skip currently visible slide
function AnimationScene:skipActiveSlide()
	local ac = self.slides[self.activeSlideIndex]
	
	if ac ~= nil then
		if ac.speechSoundName ~= nil then
			self.soundContainer:stopEffect(ac.speechSoundName)
		end
		ac.shouldEnd = true
		self:nextSlide()
	end
end

function AnimationScene:updateActiveSlide(deltaTime)
	local ac = self.slides[self.activeSlideIndex]
	
	if ac ~= nil then
		ac.lastTime = ac.lastTime - deltaTime
		
		if ac.subtitles ~= nil then
			ac.subtitlesTimer = ac.subtitlesTimer + deltaTime
			
			if ac.subtitlesTimer >= ac.subtitlesUpdateTime then
				ac.subtitlesTimer = 0
				ac.subtitlesIndex = ac.subtitlesIndex + 1
			end
		end
		
		-- Slide and it's particle are dead already
		if ac.lastTime <= 0 then
			self:nextSlide()
		end
	elseif self.shouldEnd == false then
		self:endIntro()
	end
end

function AnimationScene:start()
	self.paused = false
	self.activeSlideIndex = 1
	self:activateSlide(self.slides[self.activeSlideIndex])
	
	-- Play background music if any exits
	if self.backgroundMusic ~= nil then
		self.soundContainer:playMusic(self.backgroundMusic)
	end
end

function AnimationScene:updateEnding(deltaTime)
	self.timerToEnd = self.timerToEnd - deltaTime
	
	-- Lower the volume of background music if exits
	local mus = self.soundContainer:getMusic(self.backgroundMusic)
	if mus ~= nil then
		local q = self.timerToEnd / SlideTimeToEnd
		mus:setVolume(self.soundContainer.musicVolume * q)
	end
	
	if self.timerToEnd <= 0 then
		self.soundContainer:stopAll()
		self.quit = true
	end
end

function AnimationScene:handleMouseClick(x, y)
	if self.lastClickTimer < DoubleClickTime then
		-- It's the double click, skip the slide
		self:skipActiveSlide()
		self.lastClickTimer = 999
	else
		self.lastClickTimer = 0
	end
end

function AnimationScene:handleTouchPress(id, x, y)
	self:handleMouseClick(x, y)
end

function AnimationScene:handleKeyPress(key)
	if key == "escape" then
		--self:endIntro()
	elseif key == "space" then
		--self:skipActiveSlide()
	end
end

function AnimationScene:shouldQuit()
	return self.quit
end

local FakeCam = { x = 0, y = 0 }

function AnimationScene:update(deltaTime)
	if self.paused == false then
		if self.shouldEnd then
			self:updateEnding(deltaTime)
		end
		self.lastClickTimer = self.lastClickTimer + deltaTime
		
		self.particleSystem:update(FakeCam, deltaTime, self.sinCosTable)
		self:updateActiveSlide(deltaTime)
	end
end

function AnimationScene:drawActiveSlideSubtitles()
	local ac = self.slides[self.activeSlideIndex]
	
	-- Does the active slide exist? Do subtitles exist?
	if ac ~= nil and ac.subtitles ~= nil and 
		ac.subtitles[ac.subtitlesIndex] ~= nil then
		
		local c = ac.subtitlesColor
		love.graphics.setColor(c.r, c.g, c.b)
		
		self.font:drawLineCentered(
			ac.subtitles[ac.subtitlesIndex],
			self.virtScrWidth/2,
			self.virtScrHeight * 0.8)
		
		love.graphics.setColor(255, 255, 255)
	end
end

function AnimationScene:draw()
	if self.backgroundColor ~= nil then
		local color = self.backgroundColor
		local ac = self.slides[self.activeSlideIndex]
		
		if ac ~= nil and ac.backgroundColor ~= nil then
			color = self.slides[self.activeSlideIndex].backgroundColor
		end
		
		drawRectC("fill", 0, 0,
			self.virtScrWidth, self.virtScrHeight,
			color)
	end
	
	self.particleSystem:draw(FakeCam)
	self:drawActiveSlideSubtitles()
end