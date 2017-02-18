require "ParticleSystem"
require "Utils"
require "SoundContainer"

ParallaxBackground = class:new()

local Background = class:new()

-- Separate background level info
function Background:init()
	self.texture = nil
	self.textureName = nil
	
	self.color = nil
	
	self.cloudsEnabled = false
	self.bigClouds = false
	self.numCloudsMax = 0
	self.numClouds = 0
	self.removeClouds = false
	
	self.snowEnabled = false
	self.numSnowFlakesMax = 0
	self.numSnowFlakes = 0
	
	self.rainEnabled = false
	self.numRainDropsMax = 0
	self.numRainDrops = 0
	
	self.particleSystem = nil
	self.cameraVel = 0
end

-- Cloud particle updater (remover)
local function cloudParticleUpdate(particle, camera, deltaTime, background)
	if particle.x <= camera.x - particle.width or
		particle.x >= camera.x + camera.virtualWidth + particle.width or
		background.removeClouds then
		-- Out of map, the particle has to be deleted
		particle.isFree = true
		background.numClouds = background.numClouds-1
	end
end

-- Snow flake or rain drop particle updater (remover)
local function snowRainParticleUpdate(particle, camera, deltaTime, background)
	if particle.x <= -particle.width or 
		
		particle.x >= camera.virtualWidth + particle.width +
		(camera.mapWidth - camera.virtualWidth) * background.cameraVel or
		
		particle.y >= camera.virtualHeight + particle.height +
		(camera.mapHeight - camera.virtualHeight) * background.cameraVel or
		
		particle.y < camera.y-background.cameraVel 
			* camera.virtualHeight/2 - particle.height then
		
		-- Out of map, the particle has to be deleted
		particle.isFree = true
		
		-- Snow or rain? Decide which indicator to decrease
		if particle.userData == "snow" then
			background.numSnowFlakes = background.numSnowFlakes - 1
		else
			background.numRainDrops = background.numRainDrops - 1
		end
	end
end

-- @cloudTexs = array of possible cloud textures!
function ParallaxBackground:init(soundContainer, 
	cloudTexs, snowFlakeTex, rainDropTex)
	
	self.soundContainer = soundContainer
	
	self.cloudTexs = cloudTexs
	self.snowFlakeTex = snowFlakeTex
	self.rainDropTex = rainDropTex
	
	self.numBackgrounds = 4
	self.backgrounds = {}
	for i = 1, self.numBackgrounds do
		self.backgrounds[i] = Background:new()
	end
	
	-- User's constants for weather
	self.lightSnow = 75
	self.heavySnow = 150 
	self.lightRain = 500
	self.heavyRain = 1500
end

-- Check if background lvl is valid
function ParallaxBackground:validBackgroundLvl(lvl)
	return lvl >= 1 and lvl <= self.numBackgrounds
end

-- Check, if background has already a created particle system.
-- If it hasn't, then create one.
function ParallaxBackground:createParticleSystem(backgroundLvl)
	if self.backgrounds[backgroundLvl].particleSystem == nil then
		self.backgrounds[backgroundLvl].particleSystem = ParticleSystem:new()
	end
end

-- Set background texture
-- You can use both back. texture and color simultaneously
function ParallaxBackground:setBackgroundTexture(backgroundLvl,
	texture, textureName)
	
	if self:validBackgroundLvl(backgroundLvl) then
		self.backgrounds[backgroundLvl].texture = texture
		self.backgrounds[backgroundLvl].textureName = textureName
	end
end

-- Set background color
-- You can use both back. texture and color simultaneously
function ParallaxBackground:setBackgroundColor(backgroundLvl, r, g, b, a)
	if self:validBackgroundLvl(backgroundLvl) then
		local color = {}
		color.r, color.g, color.b, color.a = r, g, b, a
		self.backgrounds[backgroundLvl].color = color
	end
end

-- Set camera velocity (how faster or slower will it move
-- compared to normal foreground camera)
function ParallaxBackground:setCameraVelocity(backgroundLvl, cameraVel)
	if self:validBackgroundLvl(backgroundLvl) then
		self.backgrounds[backgroundLvl].cameraVel = cameraVel
	end
end

-- Enable clouds
function ParallaxBackground:enableClouds(backgroundLvl, 
	bigClouds, numCloudsMax)
	
	if self:validBackgroundLvl(backgroundLvl) then
		self.backgrounds[backgroundLvl].cloudsEnabled = true
		self.backgrounds[backgroundLvl].bigClouds = big
		self.backgrounds[backgroundLvl].numCloudsMax = numCloudsMax
		self.backgrounds[backgroundLvl].removeClouds = false
		
		self:createParticleSystem(backgroundLvl)
	end
end

-- Disable clouds
function ParallaxBackground:disableClouds(backgroundLvl)
	if self:validBackgroundLvl(backgroundLvl) then
		self.backgrounds[backgroundLvl].cloudsEnabled = false
		self.backgrounds[backgroundLvl].removeClouds = true
	end
end

-- Enable snow
function ParallaxBackground:enableSnow(backgroundLvl, heavy)
	if self:validBackgroundLvl(backgroundLvl) then
		self.backgrounds[backgroundLvl].snowEnabled = true
		self.backgrounds[backgroundLvl].numSnowFlakesMax = 
			heavy and self.heavySnow or self.lightSnow
			
		self:createParticleSystem(backgroundLvl)
	end
end

-- Disable snow
function ParallaxBackground:disableSnow(backgroundLvl)
	if self:validBackgroundLvl(backgroundLvl) then
		self.backgrounds[backgroundLvl].snowEnabled = false
	end
end

-- Enable rain
function ParallaxBackground:enableRain(backgroundLvl, heavy)
	if self:validBackgroundLvl(backgroundLvl) then
		self.backgrounds[backgroundLvl].rainEnabled = true
		self.backgrounds[backgroundLvl].numRainDropsMax = 
			heavy and self.heavyRain or self.lightRain
			
		self:createParticleSystem(backgroundLvl)
		self.soundContainer:playEffect("rain", true)
	end
end

-- Disable rain
function ParallaxBackground:disableRain(backgroundLvl)
	if self:validBackgroundLvl(backgroundLvl) then
		self.backgrounds[backgroundLvl].rainEnabled = false
		
		-- Check whether is another rain enabled
		-- If not, stop the raining sound effect
		for i = 1, self.numBackgrounds do
			if self.backgrounds[i].rainEnabled then
				return
			end
		end
		
		self.soundContainer:stopEffect("rain")
	end
end

-- Check, if object is filled into horizontal map properly
-- If not, move it about half the screen size inside
local function fillXPositionIntoMap(x, width, camera)
	if x + width/2 <= 0 then
		x = x + camera.virtualWidth/2
	elseif x - width/2 >= camera.mapWidth then
		x = x - camera.virtualWidth/2
	end
	
	return x
end

-- Update clouds generation if possible
function ParallaxBackground:updateClouds(background, deltaTime, camera)
	if background.numClouds < background.numCloudsMax then
		local x = (camera.x - camera.virtualWidth/2) * background.cameraVel +
			math.random() * camera.virtualWidth * 2.5
		local y = camera.y + math.random() * camera.virtualHeight/3
		local width = 70 + math.random() * camera.virtualWidth/10
		local height = 35 + math.random() * camera.virtualHeight/10
		
		if background.bigClouds == true then
			width = width*2
			height = height*2
		end
		if height > width then
			height = width
		end
		
		x = fillXPositionIntoMap(x, width, camera)
		
		background.particleSystem:addCloudParticle(
			self.cloudTexs[math.random(1, #self.cloudTexs)], 
			x, y, width, height,
			math.random() < 0.5,
			cloudParticleUpdate)
			
		background.numClouds = background.numClouds + 1
	end
end

-- Update snow generation if possible
function ParallaxBackground:updateSnow(background, deltaTime, 
	camera, disableRandom)
	
	if disableRandom == false and
		math.random() > 0.05 * background.numSnowFlakesMax * deltaTime then
		return
	end
	
	if background.numSnowFlakes < background.numSnowFlakesMax then
		-- Setup position and proportions
		local x = math.random() * camera.virtualWidth * 2 + 
			camera.x - camera.virtualWidth/2
		local y = camera.y - camera.virtualHeight/3 * background.cameraVel
		local size = 10 + math.random() * 10
		
		-- Cannot be outside the map
		x = fillXPositionIntoMap(x, size, camera)
		
		background.particleSystem:addSnowParticle(self.snowFlakeTex,
			x, y, size, size, snowRainParticleUpdate)
			
		background.numSnowFlakes = background.numSnowFlakes + 1
	end
end

-- Update rain generation if possible
function ParallaxBackground:updateRain(background, deltaTime, 
	camera, disableRandom)
	
	if disableRandom == false and
		math.random() > 0.07 * background.numRainDropsMax * deltaTime then
		return
	end
	
	if background.numRainDrops < background.numRainDropsMax then
		-- Setup position (upper or right border of the screen)
		local pos = math.random() * (camera.virtualWidth + 
			camera.virtualHeight / 2)
			
		local x, y
		
		if pos < camera.virtualWidth then
			x = camera.x + pos
			y = camera.y
		else
			x = camera.x + camera.virtualWidth
			y = (pos - camera.virtualWidth) * 1.2
		end
		
		background.particleSystem:addRainParticle(self.rainDropTex,
			x, y, 4, 20, snowRainParticleUpdate)
		
		background.numRainDrops = background.numRainDrops + 1
	end
end

-- Pre-run enabled weather for about 10 seconds on the background
-- So the user can already see the full result.
function ParallaxBackground:preRunWeather(camera, sinCosTable)
	local timer = 0
	local deltaTime = 1/60
	
	while timer < 10 do
		self:update(camera, deltaTime, sinCosTable, true)
		timer = timer + deltaTime
	end
end

-- Update parallax background 
-- @disableRandom = used for pre-counting weather 
-- 	(false in normal in-game update)
function ParallaxBackground:update(camera, deltaTime,
	sinCosTable, disableRandom)
	
	for i = 1, self.numBackgrounds do
		-- Update particle system
		if self.backgrounds[i].particleSystem ~= nil then
			local background = self.backgrounds[i]
			
			camera:push()
			
			camera:scalePosition(background.cameraVel, background.cameraVel)
			
			background.particleSystem:update(camera, deltaTime, 
				sinCosTable, background)
			
			if background.cloudsEnabled then
				self:updateClouds(background, deltaTime, camera)
			end
			if background.snowEnabled then
				self:updateSnow(background, deltaTime, camera, false)
			end
			if background.rainEnabled then
				self:updateRain(background, deltaTime, camera, false)
			end
			
			camera:pop()
		end
	end
end

-- Draw texture on background
function ParallaxBackground:drawBackgroundTexture(texture, cameraVel, camera)
	local texW = texture:getWidth()
	local texH = camera.virtualHeight * (cameraVel+1)
	local startX = -math.fmod(camera.x*cameraVel, texW)
	local startY = camera.y / (camera.mapHeight-camera.virtualHeight) *
		camera.virtualHeight * cameraVel
	
	for x = startX, camera.virtualWidth, texW do
		drawTex(texture, x, -startY, texW, texH)
	end
end

-- Draw color on background
function ParallaxBackground:drawBackgroundColor(r, g, b, a, camera)
	love.graphics.setColor(r, g, b, a)
	love.graphics.rect("fill", camera.x, camera.y, 
		camera.virtualWidth, camera.virtualHeight)
	love.graphics.setColor(255, 255, 255, 255)
end

-- Draw parallax background
function ParallaxBackground:draw(camera)
	for i = 1, self.numBackgrounds do
		local background = self.backgrounds[i]
		
		if background.color ~= nil then
			background.drawBackgroundColor(background.color.r,
				background.color.g, background.color.b, background.color.a,
				camera)
		end
		
		if background.texture ~= nil then
			self:drawBackgroundTexture(background.texture,
				background.cameraVel, camera)
		end
		
		-- Particle system
		if background.particleSystem ~= nil then
			-- Save camera position
			camera:push()
			camera:scalePosition(background.cameraVel, background.cameraVel)
			
			background.particleSystem:draw(camera)
			
			-- Restore it
			camera:pop()
		end
	end
end

function ParallaxBackground:saveTo(file)
	checkWriteLn(file, "-- Parallax background begin")
	
	for i = 1, self.numBackgrounds do
		local b = self.backgrounds[i]
		checkWriteLn(file, "-- Background begin: " .. i)
		
		-- Background texture
		if b.texture ~= nil then
			checkWriteLn(file, "world:setBackgroundTexture(" .. i ..
				", \"" .. b.textureName .. "\")")
		end
		
		-- Background color
		if b.color ~= nil then
			checkWriteLn(file, "world:setBackgroundColor(" .. i ..
				", " .. b.color.r .. ", " .. b.color.g .. ", " ..
				", " .. b.color.b .. ", " .. b.color.a .. ")")
		end
		
		-- Clouds
		if b.cloudsEnabled then
			checkWriteLn(file, "world:enableWeather(" .. i ..
				", \"Clouds\", " .. tostring(b.bigClouds) .. ", " ..
				b.numCloudsMax .. ")")
		end
		
		-- Snow
		if b.snowEnabled then
			checkWriteLn(file, "world:enableWeather(" .. i .. ", \"Snow\", "
			.. tostring(b.numSnowFlakesMax == self.heavySnow) .. ")")
		end
		
		-- Rain
		if b.snowEnabled then
			checkWriteLn(file, "world:enableWeather(" .. i .. ", \"Rain\", "
			.. tostring(b.numRainDropsMax == self.heavyRain) .. ")")
		end
		
		checkWriteLn(file, "world:setCameraVelocityParallaxBackground(" ..
			i .. ", " .. b.cameraVel .. ")")
		
		checkWriteLn(file, "-- Background end")
	end
	
	checkWriteLn(file, "-- Parallax background end\n")
end