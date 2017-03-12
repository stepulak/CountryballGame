require "class"
require "Utils"
require "LinkedList"

SoundContainer = class:new()

function SoundContainer:init()
	self.effects = {}
	self.effects3D = LinkedList:new()
	self.music = {}
	self.musicOn = nil
	
	self.muted = false
	
	self.effectVolume = 1
	self.minEffectVolume = 0
	self.musicVolume = 0.6
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

-- If the @x and @y are not nil, then play an effect with volatile
-- volume - that means the effect's volume is increased/decreased
-- according to given position compared to the real camera position
function SoundContainer:playEffect(name, loop, x, y)
	if self.effects[name] ~= nil then
		local effect = self.effects[name]
		
		if effect:isPlaying() then
			effect:stop()
		end
		
		effect:play()
		
		if loop == true then
			-- @loop can be nil!
			effect:setLooping(true)
		end
		
		if x ~= nil and y ~= nil then
			self.effects3D:pushBack({effect = effect, x = x, y = y})
			effect:setVolume(0)
		else
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

function SoundContainer:update3DSound(camera)
	local maxHearDist = camera.virtualWidth * 1.5
	local it = self.effects3D.head
	
	while it ~= nil do
		local e = it.data
		
		if e.effect:isPlaying() then
			local dX = e.x - (camera.x + camera.virtualWidth/2)
			local dY = e.y - (camera.y + camera.virtualHeight/2)
			local dist = math.sqrt(dX*dX + dY*dY)
			
			if dist >= maxHearDist then
				e.effect:setVolume(0)
			else
				local volume = self.effectVolume * (1 - dist/maxHearDist)
				
				if volume > self.minEffectVolume then
					e.effect:setVolume(self.effectVolume * (1 - dist/maxHearDist))
				else
					e.effect:setVolume(0)
				end
			end
			
			it = it.next
		else
			-- Delete and skip
			local it2 = it.next
			self.effects3D:deleteNode(it)
			it = it2
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