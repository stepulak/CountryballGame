require "class"
require "Utils"

local SoundContainerEffectVolume = 0.5
local SoundContainerMusicVolume = 0.7

SoundContainer = class:new()

function SoundContainer:init()
	self.effects = {}
	self.music = {}
	self.musicOn = nil
	
	self.muted = false
	
	self.effectVolume = SoundContainerEffectVolume
	self.musicVolume = SoundContainerMusicVolume
	self.masterVolume = nil
end

-- Multiple effects can be played simultaneously, but one effect just once
function SoundContainer:newEffect(name, source)
	self.effects[name] = source
end

-- There can be only one playing music in the background
function SoundContainer:newMusic(name, source)
	self.music[name] = source
end

function SoundContainer:loadEffect(name, path)
	self:newEffect(name, love.audio.newSource(path))
end

function SoundContainer:loadMusic(name, path)
	self:newMusic(name, love.audio.newSource(path))
end

function SoundContainer:playEffect(name)
	if self.effects[name] ~= nil then
		if self.effects[name]:isPlaying() then
			self.effects[name]:stop()
		end
		
		self.effects[name]:play()
		self.effects[name]:setVolume(self.effectVolume)
	end
end

function SoundContainer:playMusic(name, loop)
	if self.music[name] ~= nil then
		-- stop the old one
		if self.musicOn ~= nil then
			self.musicOn:stop()
		end
		
		self.musicOn = self.music[name]
		self.musicOn:play()
		self.musicOn:setLooping(loop)
		self.musicOn:setVolume(self.musicVolume)
	end
end

function SoundContainer:playMusicLoop(name)
	self:playMusic(name, true)
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

function SoundContainer:mute()
	-- Change *master* volume to zero
	-- Other custom volumes are preserved
	self.masterVolume = love.audio.getVolume()
	love.audio.setVolume(0)
end

function SoundContainer:unmute()
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