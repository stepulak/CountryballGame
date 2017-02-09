require "class"
require "Utils"

SoundContainer = class:new()

function SoundContainer:init()
	self.effects = {}
	self.music = {}
	self.musicOn = nil
	
	self.muted = false
	
	self.effectVolume = 0.7
	self.musicVolume = 0.4
	self.masterVolume = nil
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

function SoundContainer:playEffect(name, loop)
	if self.effects[name] ~= nil then
		if self.effects[name]:isPlaying() then
			self.effects[name]:stop()
		end
		
		self.effects[name]:play()
		self.effects[name]:setVolume(self.effectVolume)
		
		if loop == true then
			self.effects[name]:setLooping()
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
			self.musicOn:setLooping(loop)
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