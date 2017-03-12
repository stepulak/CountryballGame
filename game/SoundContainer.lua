require "class"
require "Utils"
require "LinkedList"

SoundContainer = class:new()

-- @maxHearDist3D - maximum distance (range) of the 3D effect
--		from the center of the camera to still hear the effect...
function SoundContainer:init(maxHearDist3D)
	self.effects = {}
	self.effects3D = {}
	self.music = {}
	self.musicOn = nil
	
	self.muted = false
	
	self.effectVolume = 1
	self.minEffectVolume = 0
	self.musicVolume = 0.6
	self.masterVolume = nil
	
	self.maxHearDist3D = maxHearDist3D
end

-- Set camera for 3D sound, otherwise it wont work...
function SoundContainer:setCamera(camera)
	self.camera = camera
end

-- Multiple different effects can be played simultaneously, but
-- each effect just once.
function SoundContainer:newEffect(name, source)
	self.effects[name] = source
end

-- There can be only one music playing in the background.
function SoundContainer:newMusic(name, source)
	self.music[name] = source
end

function SoundContainer:getEffect(name)
	return self.effects[name]
end

function SoundContainer:getMusic(name)
	return self.music[name]
end

function SoundContainer:loadEffect(name, path)
	self:newEffect(name, love.audio.newSource(path))
end

function SoundContainer:loadMusic(name, path)
	self:newMusic(name, love.audio.newSource(path))
end

-- If the @x and @y are not nil, then play an effect with volatile
-- volume - that means the effect's volume is increased/decreased
-- according to given position compared to the real camera position
function SoundContainer:playEffect(name, loop, x, y)
	if self.effects[name] ~= nil then
		local effect = self.effects[name]
		
		if x ~= nil and y ~= nil and self.camera ~= nil then
			self:tryAdd3DEffect(effect, loop, x, y)
		else
			if effect:isPlaying() then
				effect:stop()
			end
			
			effect:play()
			
			if loop == true then
				-- @loop can be nil!
				effect:setLooping(true)
			end
			
			-- Standart global volume
			effect:setVolume(self.effectVolume)
		end
	end
end

function SoundContainer:playMusic(name, loop)
	if self.music[name] ~= nil then
		-- stop the old one
		if self:isMusicOn() then
			self.musicOn:stop()
		end
		
		self.musicOn = self.music[name]
		self.musicOn:play()
		self.musicOn:setVolume(self.musicVolume)
		
		if loop == true then
			-- @loop can be nil!
			self.musicOn:setLooping(true)
		end
	end
end

-- Get distance from the center of the camera
function SoundContainer:getDistFromCamera(x, y)
	local dX = x - (self.camera.x + self.camera.virtualWidth/2)
	local dY = y - (self.camera.y + self.camera.virtualHeight/2)
	return math.sqrt(dX*dX + dY*dY)
end

function SoundContainer:tryAdd3DEffect(effect, loop, x, y)
	local e = self.effects3D[effect]
	local replace = true
	
	if e ~= nil then
		local distNew = self:getDistFromCamera(x, y)
		local distOld = self:getDistFromCamera(e.x, e.y)
		
		local insideCam = pointInRect(x, y,
			self.camera.x, 
			self.camera.y,
			self.camera.virtualWidth,
			self.camera.virtualHeight)
		
		if insideCam == false and distNew >= distOld then
			replace = false
		end
	end
	
	if replace then
		self.effects3D[effect] = {
			processed = false,
			loop = loop,
			x = x,
			y = y,
		}
	end
end

function SoundContainer:update3DSound()
	for effect, e in pairs(self.effects3D) do
		if e ~= nil then
			local dist = self:getDistFromCamera(e.x, e.y, camera)
			local vol = self.effectVolume * (1 - dist/self.maxHearDist3D)
				
			-- You see, effects "out of hear range" won't be even played
			if e.processed == false and 
				dist < self.maxHearDist3D and
				vol > self.minEffectVolume then
				
				effect:stop()
				effect:play()
				
				-- Volume will be resolved later
				effect:setVolume(vol)
				
				if e.loop == true then
					effect:setLooping(true)
				end
				e.processed = true
			end
			
			if effect:isPlaying() then
				if vol > self.minEffectVolume and
					dist < self.maxHearDist3D then
					effect:setVolume(vol)
				else
					effect:setVolume(0)
				end
			else
				-- Delete effect
				self.effects3D[effect] = nil
			end
		end
	end
end

function SoundContainer:isMusicOn()
	return self.musicOn ~= nil and self.musicOn:isPlaying()
end

function SoundContainer:playMusicOnce(name)
	self:playMusic(name, false)
end

function SoundContainer:normalizeVolume(vol)
	return setWithinRange(vol, 0, 1)
end

function SoundContainer:setEffectVolume(vol)
	self.effectVolume = self:normalizeVolume(vol)
end

function SoundContainer:setMusicVolume(vol)
	self.musicVolume = self:normalizeVolume(vol)
end

function SoundContainer:applyActionPlayingEffects(action)
	for name, source in pairs(self.effects) do
		if source:isPlaying() then
			action(source)
		end
	end
end

function SoundContainer:muteAll()
	-- Change *master* volume to zero
	-- The ratio between custom volumes is preserved
	self.masterVolume = love.audio.getVolume()
	love.audio.setVolume(0)
end

function SoundContainer:unmuteAll()
	if self.masterVolume ~= nil then
		love.audio.setVolume(self.masterVolume)
		self.masterVolume = nil
	end
end

function SoundContainer:pauseAll()
	love.audio.pause()
end

function SoundContainer:resumeAll()
	love.audio.resume()
end

function SoundContainer:stopEffect(name)
	if self.effects[name] then
		self.effects[name]:stop()
	end
end

function SoundContainer:stopEffects()
	self:applyActionPlayingEffects(function(e) e:stop() end) 
end

function SoundContainer:stopMusic()
	if self.musicOn then
		self.musicOn:stop()
		self.musicOn = nil
	end
end

function SoundContainer:stopAll()
	love.audio.stop()
end