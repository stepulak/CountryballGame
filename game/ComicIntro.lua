require "Runnable"

local SlideStdLastTime = 10

ComicIntro = Runnable:new()

function ComicIntro:init(virtScrWidth, virtScrHeight, font, soundContainer)
	self.virtScrWidth = virtScrWidth
	self.virtScrHeight = virtScrHeight
	self.font = font
	self.soundContainer = soundContainer
	
	self.camX = 0
	self.camY = 0
	
	self.quit = false
	self.paused = true
	
	self.slides = {}
	self.activeSlideIndex = 1
	
	self.backgroundMusic = nil
end

-- @effectType = "horizontal", "vertical", "horiz_verti", 
--	"static", "zoom_out", "fade_in"
--
-- @opts consist of optinal values:
-- 	@opts.lastTime - if not set, then SlideStdLastTime is used
-- 	@opts.subtitles - array of texts
-- 	@opts.speechSoundName - if set, then slide's last time is equal to
-- 		@opts.speechSoundName duration
function ComicIntro:addSlide(texture, effectType, opts)
	local slide = {
		slideType = "casual",
		texture = texture,
		effectType = effectType,
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

-- Insert final slide with "The End" text which will last 
-- as long as the music is playing or if there isn't any
-- background music, then till SlideStdLastTime
function ComicIntro:addTheEndSlide()
	self.slides[#self.slides + 1] = {
		slideType = "text_ending",
		text = "The End",
		effectType = "fade_in",
	}
end

-- Add slide which just fades out everything, including
-- background music, and ends the intro under all circumstances
function ComicIntro:addFadeOutEndSlide()
	self.slides[#self.slides + 1] = {
		slideType = "fade_out_ending",
	}
end

-- Skip currently visible slide
function ComicIntro:skipSlide()
	local currSlide = self.slides[self.activeSlideIndex]
	
	if currSlide.
end

-- Update slide movement according to it's movement type
function ComicIntro:updateSlideMovement(slide)
	if slide.movementType == "horizontal" then
		
	elseif slide.movementType == "vertical" then
	
	elseif slide.movementType == "horiz_verti" then
	
	elseif slide.movementType == "static" then
	
	elseif slide.movementType == "zoom_out" then
	
	end
end

function ComicIntro:start()
	self.paused = false
end

function ComicIntro:handleMouseClick(x, y)
	self.gui:mouseClick(x, y)
end

function ComicIntro:handleMouseRelease(x, y)
	self.gui:mouseRelease(x, y)
end

function ComicIntro:handleTouchPress(id, x, y)
	self.gui:touchPress(id, x, y)
end

function ComicIntro:handleTouchRelease(id, x, y)
	self.gui:touchRelease(id, x, y)
end

function ComicIntro:handleKeyPress(key)
	if key == "escape" then
		self.quit = true
	elseif key == "space" then
		self:skipSlide()
	end
end

function ComicIntro:shouldQuit()
	return self.quit
end

function ComicIntro:update(deltaTime)
	if self.paused == false then
		
	end
end

function ComicIntro:draw()
	
end