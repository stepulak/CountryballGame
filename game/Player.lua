require "Unit"
require "Projectile"

local AttackTime = 0.2
local TrampolineVelQ = 1.5
-- Invulnerability against rotating ghosts
local InvulnerabilityRGTime = 1
local HatBasicColor = 180
local JumpingVel = 1000
local HorizontaVel = 200
local StarParticleSize = 20
local StarParticleSpawnProbabilityQ = 20
local FartSize = 20 -- :-)
local SprintVelQ = 1.6
local StarDuration = 8

Player = Unit:new()

function Player:init(x, y, 
	tileWidth, tileHeight, 
	numLives, coins, 
	idleAnim, walkingAnim, jumpingAnim, 
	swimmingAnim, attackingAnim, 
	deathTex, helmetTex, starTex, bubbleTex, smokeTex)
	
	self:super("player", x, y, tileWidth, tileHeight, 
		JumpingVel, HorizontaVel, 
		idleAnim, walkingAnim, jumpingAnim,
		swimmingAnim, attackingAnim, nil)
	
	-- There is only one player in the world, so we can afford
	-- storing such data as texture references etc... in it's table
	self.deathTex = deathTex
	self.starTex = starTex
	self.helmetTex = helmetTex
	self.helmetWidth = self.width/1.2
	self.helmetHeight = self.height/2
	self.helmetOffsetX = -self.helmetWidth/2
	self.helmetOffsetY = -self.height/2.4 - self.helmetWidth/2
	
	self.bubbleTex = bubbleTex
	self.smokeTex = smokeTex
	
	-- This animation must take exactly AttackTime seconds.
	self.attackingAnim.updateTime = AttackTime 
		/ self.attackingAnim:numTextures()
	
	self.numLives = numLives
	self.coins = coins
	
	self:hardReset()
end

-- Player function only!
-- Reset player's specified attributes, timers etc...
-- Only coins and lives are preserved
function Player:hardReset()
	self.helmetEnabled = false
	self.flowerType = nil
	self:softReset()
end

-- Reset only succ-after-level stats
function Player:softReset()
	self.dead = false
	self.disappeared = false
	self.isFacingLeft = false
	self.projectileFired = false
	self.sprintEnabled = false
	self.starConsumed = false
	
	self.isControllable = true
	self.helmetBlinkTimer = 0
	self.jumpEffectProcessed = true
	
	self.color = { 
		r = 255,
		g = 255, 
		b = 255 
	}
	self.alpha = 255
	
	self.immuneToDeadlyObjects = false
	-- Invulnerable only against rotating ghosts!
	self.invulnerableRGTimer = 0
	self.immuneToDeadlyObjects = false
	self.invulnerableTimer = 0
	self.attackingTimer = 0
	
	self.sprintEnabled = false
end 

function Player:setTotallyInvulnerable(time)
	self.invulnerableTimer = time
	self.invulnerableRGTimer = time
	self.immuneToDeadlyObjects = true
end

function Player:isInvulnerable()
	return self.invulnerableTimer > 0
end

function Player:tryToJump()
	-- When the player is on trampoline, increase the jumping speed
	self.jumpingVelQ = self.onTrampoline and TrampolineVelQ or 1
	
	if self.isJumping == false then
		self.jumpEffectProcessed = false
	end
	
	self:superTryToJump()
end

function Player:instantDeath(particleSystem, soundContainer)
	particleSystem:addPlayersFallEffect(self.deathTex,
		self.x, self.y, self.width, self.height, 
			-- Update function
			function (particle, camera, deltaTime, userData)
				-- Reverse player's direction when it reaches the top
				if particle.userData == "up" and particle.timer > 0.5 then
					particle.userData = "down"
					particle.dirAngle = 270
					particle.acc = -particle.acc
				end
			end
		)
	
	self.dead = true
	self.numLives = self.numLives - 1
	
	soundContainer:playEffect("player_death")
end

function Player:dropHelmet(type, particleSystem, soundContainer)
	local dir = nil
	
	if type == "projectile_left" or type == "touch_left" then
		dir = "right"
	elseif type == "projectile_right" or type == "touch_right" then
		dir = "left"
	end
	
	-- Drop it
	particleSystem:addFallingRotatingObject(self.helmetTex, 
		self.x + self.helmetOffsetX,
		self.y + self.helmetOffsetY,
		self.helmetWidth, self.helmetHeight, dir, 2)
	
	soundContainer:playEffect("player_drop_helmet")
	
	self.helmetEnabled = false
	self.flowerType = nil
	self.invulnerableTimer = 0.8
end

function Player:hurt(type, particleSystem, soundContainer)
	if self.disappeared == false and self.immuneToDeadlyObjects == false then
		if self.helmetEnabled then
			self:dropHelmet(type, particleSystem, soundContainer)
		elseif self.dead == false then
			-- BUG check if the player is not dead already,
			-- cause if he is, then it could cause unwanted lives reduction
			self:instantDeath(particleSystem, soundContainer)
		end
	end
end

function Player:canBreakTiles()
	return self.helmetEnabled
end

function Player:getCreatedProjectile()
	if self.flowerType ~= nil and self.projectileFired then
		self.projectileFired = false
		
		local projName = self.flowerType == "fireflower" 
			and "fireball" or "iceball"
		
		return projName,
			self.x + (self.isFacingLeft and -self.width/2 or self.width/2),
			self.y - self.height/3, 20, self.isFacingLeft, true
	else
		return nil
	end
end

-- @velQ is in [0, 1]
function Player:moveHorizontally(dirLeft, velQ)
	self.isMovingHor = true
	self.isFacingLeft = dirLeft
	self.horizontalVel = self.horizontalVelBase * velQ
	
	-- Do not forget to add additional velocity booster if sprint is enabled
	if self.sprintEnabled then
		self.horizontalVel = self.horizontalVel * SprintVelQ
	end
	
	self.isHorMovementActive = true
end

-- Player function only!
function Player:tryToAttack(soundContainer)
	if self.helmetEnabled and self.flowerType ~= nil then
		self.projectileFired = true
		self.attackingTimer = AttackTime
		soundContainer:playEffect("player_shooting")
	end
end

function Player:tryToEnableSprint()
	if self.isFalling == false and self.isJumping == false then
		self.sprintEnabled = true
	end
end

-- Player function only!
-- Increase coins by one and check, if you have above 100 coins.
-- If you do, then increase your number of lives.
function Player:increaseNumCoins()
	self.coins = self.coins + 1
	
	if self.coins == 100 then
		self.coins = 0
		self:increaseNumLives()
	end
end

function Player:increaseNumLives()
	self.numLives = self.numLives + 1
end

function Player:addHelmet()
	self.helmetEnabled = true
	self.helmetBlinkTimer = 1
end

function Player:consumeStar(soundContainer)
	self.invulnerableTimer = StarDuration
	self.starConsumed = true
	soundContainer:playMusic("star")
end

function Player:disappear()
	self.movementAndCollisionDisabled = true
	self.disappeared = true
end

function Player:boostPlayer(unit, soundContainer)
	if unit.isFading then
		-- Booster has been used already before
		return
	end
	
	if unit.name == "mushroom_life" then
		self:increaseNumLives()
		soundContainer:playEffect("lifeup")
	elseif unit.name == "mushroom_grow" then
		self:addHelmet()
		soundContainer:playEffect("boost_pick")
	elseif unit.name == "star" then
		self:consumeStar(soundContainer)
	elseif unit.name == "fireflower" or unit.name == "iceflower" then
		if self.helmetEnabled == false then
			self:addHelmet()
		end
		self.flowerType = unit.name
		soundContainer:playEffect("boost_pick")
	elseif unit.name == "coin" then
		self:increaseNumCoins()
		soundContainer:playEffect("coin_pick")
	elseif unit.name == "rocket" then
		unit:startRocket(soundContainer)
		self:disappear()
		return
	end
	
	unit:fadeOut()
end

function Player:handleSpecialHorizontalCollision(unit, particleSystem,
	soundContainer)
	
	self:hurt(unit.isFacingLeft and "touch_right" or "touch_left",
		particleSystem, soundContainer)
	
	return true
end

function Player:resolveUnitCollision(unit, particleSystem, deltaTime,
	soundContainer)
	
	if unit.friendlyToPlayer then
		self:boostPlayer(unit, soundContainer)
	elseif unit.name == "rotating_ghost" and self.invulnerableRGTimer <= 0 then
		-- HINT: remove if player has not circular shape!
		if pointInCircle(unit.x, unit.y, self.x, self.y, self.width/2) then
			self:hurt("projectile_bottom", particleSystem, soundContainer)
			self.invulnerableRGTimer = InvulnerabilityRGTime
		end
	else
		self:superResolveUnitCollision(unit, particleSystem,
			deltaTime, soundContainer)
	end
end

function Player:updateAnimations(deltaTime)
	if self.insideWater then
		if self.isJumping or self.isFalling then
			self.activeAnim = self.swimmingAnim
			
			-- Are you at the beginning of the animation? Stop updating now.
			if self.isJumping then
				self.swimmingAnim:update(deltaTime)
				if self.textureIndex == 1 then
					self.swimmingAnim:reset()
				end
			else
				self.swimmingAnim:reset()
			end

			return
		end
	end
	
	if self.isJumping or self.isFalling then
		self.activeAnim = self.jumpingAnim
	elseif self.isMovingHor then
		self.activeAnim = self.movementAnim
	elseif self.attackingTimer > 0 then
		self.activeAnim = self.attackingAnim
	else
		self.activeAnim = self.idleAnim
	end
	
	local animationDeltaTimeQ = self.horizontalVel/self.horizontalVelBase
	
	self.activeAnim:update(deltaTime * animationDeltaTimeQ)
	self:resetInactiveAnimations()
end

-- Lower the volume of the playing "star consumed" music
-- if your invulnerability is comming to an end.
function Player:starChangeVolumeMusic(soundContainer)
	local mus = soundContainer:getMusic("star")
	
	if mus ~= nil then
		local fadeOutTime = StarDuration/10
		
		-- The music exists
		if self.invulnerableTimer < fadeOutTime and self.invulnerableTimer >= 0 then
			local q = self.invulnerableTimer/fadeOutTime
			mus:setVolume(q * soundContainer.musicVolume)
		end
	end
end

-- Create fading stars around player if it's moving and also star is consumed
function Player:spawnStars(deltaTime, particleSystem)
	if self:isIdle() == false and 
		math.random() < deltaTime * StarParticleSpawnProbabilityQ then
		
		local vx, vy = self:getDirectionVector()
		local angle = vx < 0 and 0 or 180
		
		particleSystem:addStarParticle(self.starTex, self.x, self.y,
			StarParticleSize, StarParticleSize,
			angle + math.random(-45, 45))
	end
end

function Player:addFartTexEffect(particleSystem, fartTex)
	local x, angle
	
	if self.isFacingLeft then
		x = self.x + self.width/4
		angle = 20
	else
		x = self.x - self.width/4
		angle = 160
	end
	
	particleSystem:addSmokeParticle(fartTex, x, self.y + self.height/4,
		FartSize, FartSize, angle, 0.5)
end

function Player:updatePlayer(deltaTime, particleSystem, soundContainer)
	if self.attackingTimer > 0 then
		self.attackingTimer = self.attackingTimer - deltaTime
		
		if self.attackingTimer < 0 then
			self.attackingTimer = 0
			-- You can't process the projectile anymore after
			-- the attacking process has ran out of time.
			self.projectileFired = false
		end
	end
	
	if self.invulnerableTimer > 0 then
		self.invulnerableTimer = self.invulnerableTimer - deltaTime
		
		-- Pick a new color
		if self.starConsumed then
			mutateColor(self.color)
			self:spawnStars(deltaTime, particleSystem)
			self:starChangeVolumeMusic(soundContainer)
		end
		
		if self.invulnerableTimer < 0 then
			self.invulnerableTimer = 0
			self.starConsumed = false
			soundContainer:stopMusic()
		end
	end
	
	if self.invulnerableRGTimer > 0 then
		self.invulnerableRGTimer = self.invulnerableRGTimer - deltaTime
	end
	
	if self.helmetBlinkTimer > 0 then
		self.helmetBlinkTimer = self.helmetBlinkTimer - deltaTime
	end
	
	-- Remember to play sound when player jumps or try to swim in the water
	-- FYI this could not be done inside tryToJump(), because we don't know
	-- when precisely will the player jump
	if self.isJumping and self.jumpEffectProcessed == false then
		self.jumpEffectProcessed = true
		
		-- "fart" effect
		if self.insideWater then
			soundContainer:playEffect("player_swim")
			self:addFartTexEffect(particleSystem, self.bubbleTex)
		else
			soundContainer:playEffect("player_jump")
			self:addFartTexEffect(particleSystem, self.smokeTex)
		end
	end
	
	-- Sprint update
	if self.isMovingHor == false then
		self.sprintEnabled = false
	end
end

function Player:isIdle()
	return self.isFalling == false 
		and self.isJumping == false
		and self.isMovingHor == false
end

function Player:update(deltaTime, gravityAcc, particleSystem,
	camera, soundContainer)
	
	if self.disappeared == false then
		self:superUpdate(deltaTime, gravityAcc, particleSystem,
			camera, soundContainer)
		
		self:updatePlayer(deltaTime, particleSystem, soundContainer)
	end
end

function Player:drawHelmet(camera)
	if self.helmetBlinkTimer > 0 then
		-- Every odd 100 ms skip rendering
		-- Every even 100 ms continue rendering
		if math.fmod(math.floor(self.helmetBlinkTimer * 10), 2) == 1 then
			return
		end
	end
	
	local r, g, b, a = love.graphics.getColor()
	local alpha = self.alpha * 1.5
	
	if self.flowerType == "fireflower" then
		love.graphics.setColor(HatBasicColor * r/255, 0, 0, alpha)
	elseif self.flowerType == "iceflower" then
		love.graphics.setColor(0, 0, HatBasicColor * b/255, alpha)
	else
		love.graphics.setColor(0, HatBasicColor * g/255, 0, alpha)
	end

	local draw = not self.isFacingLeft and drawTex or drawTexFlipped
	
	draw(self.helmetTex, 
		self.x + self.helmetOffsetX - camera.x,
		self.y + self.helmetOffsetY - camera.y,
		self.helmetWidth, self.helmetHeight)
	
	love.graphics.setColor(r, g, b, a)
end

function Player:draw(camera)
	if self.disappeared == false then
	
		if self:isInvulnerable() and self.starConsumed then
			love.graphics.setColor(self.color.r, self.color.g,
				self.color.b, self.alpha)
		end
		
		self:superDraw(camera)
		
		if self.helmetEnabled then
			self:drawHelmet(camera)
		end
		
		love.graphics.setColor(255, 255, 255, 255)
	end
end