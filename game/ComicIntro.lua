require "Runnable"
require "ParticleSystem"

local SlideStdLastTime = 10
local DoubleClickTime = 0.5
local SlideMovementDist = 150
local SlideZoomQ = 0.5
local SlideTimeToDie = 1

ComicIntro = Runnable:new()

function ComicIntro:init(virtScrWidth, virtScrHeight,
	font, soundContainer, sinCosTable)
	
	self.virtScrWidth = virtScrWidth
	self.virtScrHeight = virtScrHeight
	self.font = font
	self.soundContainer = soundContainer
	self.sinCosTable = sinCosTable
	
	self.quit = false
	self.paused = true
	self.lastClickTimer = 999
	self.shouldDie = false
	self.timerToDie = 0
	
	self.slides = {}
	self.activeSlideIndex = 1
	
	self.particleSystem = ParticleSystem:new()
	
	self.backgroundMusic = nil
end

-- @type = "horizontal", "vertical", "horiz_verti", 
--	"static", "zoom_out", "fade_in", "fade_out", "fade_out_end",
-- 	"fade_in_wait"
--
-- @opts consist of optinal values:
-- 	@opts.lastTime - if not set, then SlideStdLastTime is used
-- 	@opts.subtitles - array of texts
-- 	@opts.speechSoundName - if set, then slide's last time is equal to
-- 		@opts.speechSoundName duration
function ComicIntro:addTextureSlide(texture, texW, texH, type, opts)
	local slide = {
		texture = texture,
		texW = texW,
		texH = texH,
		type = type,
		shouldDie = false, -- for particle's update func
	}
	
	local opts_ = opts or {}
	
	if opts_.speechSoundName ~= nil then
		local sound = self.soundContainer:getEffect(opts_.speechSoundName)
		
		if sound ~= nil then
			slide.speechSoundName = opts_.speechSoundName
			slide.lastTime = sound:getDuration()
		end
	end
	
	if slide.lastTime == nil then
		-- Last time still not set
		slide.lastTime = opts_.lastTime or SlideStdLastTime
	end
	
	slide.subtitles = opts_.subtitles
	
	-- Add it into the list
	self.slides[#self.slides + 1] = slide
end

function ComicIntro:addBackgroundMusic(musicName)
	self.backgroundMusic = musicName
end

-- Let completely die the intro after some time
function ComicIntro:die()
	self.shouldDie = true 
	self.timerToDie = SlideTimeToDie
end

function ComicIntro:preHandleSlide(slide)
	self:createSlideParticle(slide)
end

function ComicIntro:postHandleSlide(slide)
	if slide.type == "fade_out_end" then
		self:die()
	end
end

function ComicIntro:skipSlideViolently(slide)

end

-- Skip currently visible slide
function ComicIntro:skipActiveSlide()
	local currSlide = self.slides[self.activeSlideIndex]
end

-- Create slide particle 
function ComicIntro:createSlideParticle(slide)
	local st = slide.type
	local w, h = slide.texW, slide.texH
	local x = (self.virtScrWidth - w)/2
	local y = (self.virtScrHeight - h)/2
	local angle, vel, propVelQ = 0, 0, 0
	local fadeType = "none"
	local endTime = slide.lastTime
	local skipParticleSystem = false
	
	if st == "horizontal" then
		x = x - SlideMovementDist/2
		vel = SlideMovementDist/endTime
	elseif st == "vertical" then
		y = y - SlideMovementDist/2
		angle = 270
		vel = SlideMovementDist/endTime
	elseif st == "horiz_verti" then
		local qXY = x/y
		x = x - SlideMovementDist/2 * qXY
		y = y - SlideMovementDist/2 * (1 - qXY)
		angle = 315
	elseif st == "static" then
		-- continue
	elseif st == "zoom_out" then
		-- TODO
	elseif st == "fade_in" then
		fadeType = "in"
	elseif st == "fade_out" then
		fadeType = "out"
	elseif st == "fade_out_end" then
		-- continue
		-- not handled here
	elseif st == "fade_in_wait" then
		fadeType = "in"
		-- If there is any active background music,
		-- wait till it ends
		local mus = self.soundContainer:getMusic(self.backgroundMusic)
		if mus ~= nil then
			endTime = mus:getDuration() - mus:tell()
		end
	end
	
	if skipParticleSystem == false then
		self.particleSystem:addSlideParticle(
			texture,
			x, y, w, h,
			angle, vel, propVelQ,
			fadeType, fadeTime, endTime,
			slide,
			-- Spec. update function
			function(particle, cam, deltaTime)
				-- Let this particle die
				if particle.userData.shouldDie then
					-- With or without fadeout effect?
					if particle.fadeOut then
						particle.timer = particle.endTime - particle.fadeTime
					else
						particle.timer = particle.endTime
					end
				end
			end)
	end
end

function ComicIntro:start()
	self.paused = false
end

function ComicIntro:handleMouseClick(x, y)
	if self.lastClickTimer < DoubleClickTime then
		-- It's the double click, skip the slide
		self:skipActiveSlide()
		self.lastClickTimer = 999
	else
		self.lastClickTimer = 0
	end
end

function ComicIntro:handleTouchPress(id, x, y)
	self:handleMouseClick(x, y)
end

function ComicIntro:handleKeyPress(key)
	if key == "escape" then
		self:die()
	elseif key == "space" then
		self:skipSlide()
	end
end

function ComicIntro:shouldQuit()
	return self.quit
end

local FakeCam = { x = 0, y = 0 }

function ComicIntro:update(deltaTime)
	if self.paused == false then
		self.lastClickTimer = self.lastClickTimer + deltaTime
		self.particleSystem:update(FakeCam, deltaTime, self.sinCosTable)
		
		if self.shouldDie then
			self.timerToDie = self.timerToDie - deltaTime
			-- Lower the volume of background music if exits
			local mus = self.soundContainer:getMusic(self.backgroundMusic)
			if mus ~= nil then
				local q = self.timerToDie / SlideTimeToDie
				mus:setVolume(self.soundContainer.musicVolume * q)
			end
			
			if self.timerToDie <= 0 then
				self.soundContainer:stopMusic()
				self.quit = true
			end
		end
	end
end

function ComicIntro:draw()
	self.particleSystem:draw(FakeCam)
end