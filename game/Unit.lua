require "class"
require "Utils"

-- Global constants
UnitJumpingVelRecommended = 500
UnitHorizontalVelRecommended = 150

Unit = class:new()

-- Unit constructor 
-- @width, @height are in pixels!
-- all of the animations don't need to be set
function Unit:init(name, 
	x, y, width, height, 
	jumpingVelBase, horizontalVelBase,
	idleAnim, movementAnim, jumpingAnim, 
	swimmingAnim, attackingAnim, deathAnim)
	
	if name == nil then
		return
	end
	
	self.name = name
	
	self.x = x
	self.y = y
	self.width = width
	self.height = height
	
	self.jumpingVelBase = jumpingVelBase
	self.jumpingVelQ = 1
	
	self.horizontalVelBase = horizontalVelBase
	self.horizontalDec = 1000
	
	-- Vertical velocity = y axis
	self.verticalVel = 0
	-- Horizontal velocity = x axis
	self.horizontalVel = 0
	
	self.isJumping = false
	self.isFalling = false
	
	-- is moving horizontally... just in left or right direction
	self.isMovingHor = false
	self.isFacingLeft = true
	self.isHorMovementActive = false
	
	self.sprintEnabled = false
	self.sprintVelQ = 1.5
	
	-- If it's dead, then it may be completely erased
	self.dead = false
	
	-- If timer > 0 then this unit is freezed
	self.freezeTimer = 0
	
	-- Must be changed manually to avoid possibility of being freezed
	self.notFreezable = false
	
	-- Unit can be killed when you step on it
	self.isSteppable = true
	
	-- Must be changed manually to avoid collision
	self.movementAndCollisionDisabled = false
	
	-- If it's positive, then try to jump immediately if possible
	self.tryToJumpTimer = 0
	
	-- If it's positive, the tell the world that this unit wants 
	-- to jump off the platform as soon as possible.
	self.jumpOffPlatformTimer = -1
	
	-- Tell the unit itself that it has collided 
	-- somewhere in horizontal direction...
	-- Possibilities: left, right
	self.collidedHorizontally = nil
	
	-- Unit's indicator, if the unit is inside water or not
	-- If the unit is, then there must be penalty for
	-- both horizontal and vertical velocity...
	self.insideWater = false
	self.waterPenaltyQ = 3
	
	-- Tell to the unit that it is jumping on the trampoline
	self.onTrampoline = false
	
	-- Can it hurt player? Or is it a booster or friendly unit?
	self.friendlyToPlayer = false
	
	-- When fade out is enabled, the unit will fastly 
	-- fadeout and then it will be deleted from the world
	self.isFading = false
	
	-- Alpha channel value
	self.alpha = 255
	
	self:loadAnimations(idleAnim, movementAnim, jumpingAnim, 
		swimmingAnim, attackingAnim, deathAnim)
end

-- Make unit's "constructor" accessible (so Unit is inheritable now)
Unit.super = Unit.init

function Unit:loadAnimations(idleAnim, movementAnim, 
	jumpingAnim, swimmingAnim, attackingAnim, deathAnim)
	
	-- Always create a copy (but it shares textures storage...)
	-- Because each unit have different animation's timing
	if idleAnim then
		self.idleAnim = idleAnim:getCopy()
	end
	if movementAnim then
		self.movementAnim = movementAnim:getCopy()
	end
	if jumpingAnim then
		self.jumpingAnim = jumpingAnim:getCopy()
	end
	if swimmingAnim then
		self.swimmingAnim = swimmingAnim:getCopy()
	end
	if attackingAnim then
		self.attackingAnim = attackingAnim:getCopy()
	end
	if deathAnim then
		self.deathAnim = deathAnim:getCopy()
	end
	
	-- Let's assume that idleAnim is valid, otherwise
	-- this has to be done manually!
	self.activeAnim = self.idleAnim
end

function Unit:fadeOut()
	self.isFading = true
end

function Unit:isInvulnerable()
	return false
end

function Unit:instantDeath(particleSystem)
	-- VIRTUAL
end

-- Hurt this unit with several possibilites.
-- @type:
-- "step_on" -> another unit has stepped on this unit
-- "projectile_left" -> a projectile has passed through this unit from left
-- "projectile_right" -> -||- from right
-- "projectile_top" -> -||- from top
-- "projectile_bottom" -> -||- from bottom
-- "touch_left" -> this unit has touched enemy unit from this unit's left side
-- "touch_right" -> this unit has touched enemy unit from this unit's right side
-- "deadly" -> this unit has touched something deadly (lava, etc...)
function Unit:hurt(type, particleSystem)
	-- VIRTUAL, HAS TO BE IMPLEMENTED
end

-- Freeze unit
-- If the unit is freezed, then it cannot move or do anything at all.
-- Freeze does no damage to the unit.
-- @freezedUnitTexture is optional, if it's passed then this texture
-- will be added to the unit as "an freeze effect"
function Unit:freeze(particleSystem, freezedUnitTexture)
	self.freezeTimer = 2 -- 2 seconds
	
	particleSystem:addFreezedUnitEffect(freezedUnitTexture,
		self.x, self.y, self.width, self.height, self.freezeTimer)
end

function Unit:isFreezed()
	return self.freezeTimer > 0
end

-- Jump or try to jump (setup timer)
function Unit:tryToJump()
	self.tryToJumpTimer = 0.25 -- 250ms
	self:tryToJumpNoTimer()
end

Unit.superTryToJump = Unit.tryToJump

-- Try to jump but do not set a "try-to-jump countdown" timer
function Unit:tryToJumpNoTimer()
	if self.insideWater then
		-- Are you inside the water? No matter what,
		-- you can jump and swim a little bit
		self.isJumping = true
		self.verticalVel = self.jumpingVelBase / 2
		self.tryToJumpTimer = 0
		
		if self.swimmingAnim then
			self.swimmingAnim:nextTexture()
		end
	elseif self.isJumping == false and self.isFalling == false then
		self.isJumping = true
		self.verticalVel = self.jumpingVelBase * self.jumpingVelQ
		self.tryToJumpTimer = 0
		
		-- Always reset jumping quotient
		-- User needs to set it everytime before jumping
		self.jumpingVelQ = 1
	end
end

Unit.superTryToJumpNoTimer = Unit.tryToJumpNoTimer

-- When the unit kills another one by stepping on it,
-- then the killer has to hop a little bit - immediately.
function Unit:hop()
	if self.isFalling then
		self:stopFalling()
	end
	
	-- This cannot happen, but just make sure 
	-- to erase all vertical velocities etc.
	if self.isJumping then
		self:stopJumping()
	end
	
	self.isJumping = true
	self.verticalVel = self.jumpingVelBase / 1.5
	self.tryToJumpTimer = 0
end

-- Setup a timer in which the unit can jump off the platform 
-- (If the unit's standing on any...)
function Unit:tryToJumpOffPlatform()
	self.jumpOffPlatformTimer = 0.2 -- 200ms
end

function Unit:stopJumping()
	if self.isJumping then
		self.isJumping = false
		self.isFalling = true
		self.verticalVel = 0
	end
end

function Unit:startFalling()
	if self.isJumping == false and self.isFalling == false then
		self.isFalling = true
		self.verticalVel = 0
	end
end

function Unit:stopFalling()
	if self.isFalling then
		self.isFalling = false
		self.verticalVel = 0
	end
end

-- @velName ... "verticalVel" or "horizontalVel"
function Unit:getSpecificDist(velName, deltaTime)
	if self.insideWater then
		return self[velName] / self.waterPenaltyQ * deltaTime
	else
		return self[velName] * deltaTime
	end
end

function Unit:getVerticalDist(deltaTime)
	return self:getSpecificDist("verticalVel", deltaTime)
end

function Unit:getHorizontalDist(deltaTime)
	return self:getSpecificDist("horizontalVel", deltaTime)
end

-- Get simple velocity vector 
-- @return horizontal_dir, vertical_dir
-- The possibilities are: { [m, n] | m, n <- {-1, 0, 1} }
-- The value represents movement on axis in specified direction
function Unit:getDirectionVector()
	local x, y = 0, 0
	
	if self.isJumping then
		y = -1
	elseif self.isFalling then
		y = 1
	end
	
	if self.isMovingHor then
		if self.isFacingLeft then
			x = -1
		else
			x = 1
		end
	end
	
	return x, y
end

function Unit:canBeRemoved()
	return self.dead
end

function Unit:canBreakTiles()
	return false
end

function Unit:canBounceTiles()
	return true
end

function Unit:tryToEnableSprint()
	-- VIRTUAL
end

-- Return new projectile's attributes created by this unit
-- If the projectile's first attribute is nil, then this
-- unit hasn't fired any projectile yet
-- return @projectile_name, @x, @y, @size, @dirLeft, @isGood
function Unit:getCreatedProjectile()
	return nil
end

function Unit:resetInactiveAnimations()
	local timer = self.activeAnim.timer
	local index = self.activeAnim.textureIndex
	
	if self.idleAnim then
		self.idleAnim:reset()
	end
	if self.jumpingAnim then
		self.jumpingAnim:reset()
	end
	if self.movementAnim then
		self.movementAnim:reset()
	end
	if self.swimmingAnim then
		self.swimmingAnim:reset()
	end
	if self.attackingAnim then
		self.attackingAnim:reset()
	end
	if self.deathAnim then
		self.deathAnim:reset()
	end
	
	-- Restore data
	self.activeAnim.timer = timer
	self.activeAnim.textureIndex = index
end

-- Function called everytime you want to resolve and update animations.
function Unit:updateAnimations(deltaTime)
	-- VIRTUAL
end

-- Move unit horizontally (walk)
function Unit:moveHorizontally(dirLeft)
	self.isMovingHor = true
	self.isFacingLeft = dirLeft
	
	if self.horizontalVel < self.horizontalVelBase then
		self.horizontalVel = self.horizontalVelBase
	end
	
	self.isHorMovementActive = true
end

-- Move unit in specific direction
-- Does not multiply the distances with the deltaTime at all.
function Unit:moveSpecific(distX, distY)
	self.x = self.x + distX
	self.y = self.y + distY
end

-- If the unit has collided somewhere (and it's not deadly obviously)
-- then reverse it's horizontal direction
function Unit:reverseDirectionAccordingToCollision()
	if self.collidedHorizontally == "left" and self.isFacingLeft then
		self.isFacingLeft = false
	elseif self.collidedHorizontally == "right" and not self.isFacingLeft then
		self.isFacingLeft = true
	end
	self.collidedHorizontally = nil
end

-- Return unit's left boundary (position and tile index)
function Unit:getLeftBoundary(tileWidth)
	local boundary = self.x - self.width/2
	return boundary, math.floor(boundary / tileWidth)
end

-- Return unit's right boundary (position and tile index)
-- distError = distanceError ~> 0 (has to be a very small number)
function Unit:getRightBoundary(tileWidth, distError)
	local boundary = self.x + self.width/2
	return boundary, math.floor((boundary-distError) / tileWidth)
end

-- Return unit's top boundary
function Unit:getTopBoundary(tileHeight)
	local boundary = self.y - self.height/2
	return boundary, math.floor(boundary / tileHeight)
end

-- Return unit's bot boundary
-- distError = distanceError ~> 0 (has to be a very small number)
function Unit:getBotBoundary(tileHeight, distError)
	local boundary = self.y + self.height/2
	return boundary, math.floor((boundary-distError) / tileHeight)
end

function Unit:isInsideCamera(camera)
	return pointInRect(self.x, self.y, 
		camera.x - self.width/2,
		camera.y - self.height/2, 
		camera.virtualWidth + self.width,
		camera.virtualHeight + self.height)
end

-- Check whether the unit is inside "down" world
-- (it means that the upper border is not checked)
function Unit:isInsideDownWorld(camera)
	local upperBound = -999
	
	return pointInRect(self.x, self.y, 
		-self.width/2, upperBound, 
		camera.mapWidth + self.width/2,
		camera.mapHeight + self.height/2 - upperBound)
end

function Unit:getFaceDir()
	return self.isFacingLeft and "left" or "right"
end

-- Resolve collision with some generic rectangle
-- If this unit is inside, move it a little bit away
-- so the collision would disappear
function Unit:resolveRectCollision(centerX, centerY, w, h, deltaTime)
	local vx, vy = self:getDirectionVector()
	local distX, distY = getShortestDistanceRectRectCollision(vx, vy,
		self.x, self.y, self.width, self.height, centerX, centerY, w, h)
	
	if math.abs(distX) > 2 * self:getHorizontalDist(deltaTime) and
		math.abs(distY) > 2 * self:getVerticalDist(deltaTime) then
		-- You cannot step back if you are too deep...
		return
	end
	
	-- Take the shortest distance and the move back
	if math.abs(distX) < math.abs(distY) then
		self.x = self.x + distX
		
		if distX > 0 then
			self.collidedHorizontally = "left"
		else
			self.collidedHorizontally = "right"
		end
	else
		self.y = self.y + distY
		
		if distY < 0 then
			self:stopFalling()
		else
			self:stopJumping()
		end
	end
end

function Unit:checkUnitCollisionInvulnerability(unit, particleSystem)
	local selfInvul = self:isInvulnerable()
	local enemyInvul = unit:isInvulnerable()
	
	if selfInvul and enemyInvul then
		-- Can't do nothing
		return true
	elseif selfInvul then
		unit:hurt(unit.isFacingLeft and "touch_left" or "touch_right",
			particleSystem)
		return true
	elseif enemyInvul then
		self:hurt(self.isFacingLeft and "touch_left" or "touch_right",
			particleSystem)
		return true
	end
	
	return false
end

-- Determine the collision type, victim and killer and
-- according to circumstances resolve the conflict
function Unit:resolveUnitVerticalCollision(unit, dist,
	particleSystem, deltaTime)
	
	if dist > 0 then
		-- Wasn't resolved
		return false
	end
	
	local killer, victim
		
	if self.y >= unit.y then -- UP
		killer = unit
		victim = self
	else
		killer = self
		victim = unit
	end
	
	local maxDist = killer:getVerticalDist(deltaTime)
	
	if -dist <= maxDist and victim.isSteppable then	
		if victim.isJumping then
			victim:stopJumping()
		end
		
		victim:hurt("step_on", particleSystem)
		killer:hop()
		killer:moveSpecific(0, -maxDist)
		
		return true
	end
	
	return false
end

function Unit:shouldBeUnitCollisionSkipped(unit)
	-- Necessary function, but implementation could be done better 
	-- (via OOP for each unit's class)
	
	-- Skip player - booster collision
	if self.name == "player" and unit.friendlyToPlayer or
		(self.friendlyToPlayer and unit.name == "player") then
		return true
	end
	
	-- Skip rotating_ghost - anything collision
	if self.name == "rotating_ghost" then
		return true
	end
	
	-- Not player - rotating_ghost collision
	if unit.name == "rotating_ghost" and self.name ~= "player" then
		return true
	end
	
	-- Handled in player's collision function
	if unit.name == "turtle" and self.name == "player" then
		return true
	end
end

-- Special horizontal collision player - badguy, mad turtle - others etc...
function Unit:handleSpecialHorizontalCollision(unit)
	-- HAS TO BE IMPLEMENTED SEPARATELY
	return false
end

function Unit:resolveUnitHorizontalCollision(unit, dist, 
	particleSystem, deltaTime)
	
	if dist > 0 then
		-- Wasn't resolved
		return false
	end
	
	if self:handleSpecialHorizontalCollision(unit, particleSystem) or 
		unit:handleSpecialHorizontalCollision(self, particleSystem) then
		return true -- Was handled
	else
		if self.x < unit.x then
			self.collidedHorizontally = "right"
			unit.collidedHorizontally = "left"
		else
			self.collidedHorizontally = "left"
			unit.collidedHorizontally = "right"
		end
		
		return true
	end
	
	return false
end

-- Resolve unit-unit collision
function Unit:resolveUnitCollision(unit, particleSystem, deltaTime)
	if self:shouldBeUnitCollisionSkipped(unit) then
		return
	end
	
	if self:checkUnitCollisionInvulnerability(unit, particleSystem) then
		return
	end
	
	distX, distY = getDistanceRectRect(
		self.x, self.y, self.width, self.height,
		unit.x, unit.y, unit.width, unit.height)
	
	if self:resolveUnitVerticalCollision(unit, distY,
		particleSystem, deltaTime) then
		-- Was resolved succesfully
		return
	end
	
	self:resolveUnitHorizontalCollision(unit, distX, particleSystem, deltaTime)
end

Unit.superResolveUnitCollision = Unit.resolveUnitCollision

function Unit:resolveDeadlyProjectileCollision(projectile, particleSystem)
	local offsetX = projectile.x - self.x
	local offsetY = projectile.y - self.y
	
	local projectileDir
	
	if math.abs(offsetX) < math.abs(offsetY) then
		projectileDir = offsetX < 0 
			and "projectile_left" or "projectile_right"
	else
		projectileDir = offsetY < 0
			and "projectile_top" or "projectile_bottom"
	end
	
	self:hurt(projectileDir, particleSystem)
end

-- Check if this unit has collided with given projectile.
-- If yes, then resolve the collision - depends on the
-- projectile's type and direction damage or change this unit.
--
-- The @freezedUnitTexture is optional, 
-- if it's passed and the projectile is iceball, then this texture
-- will be added to the unit as "an freeze effect"
function Unit:resolveProjectileCollision(projectile, 
	particleSystem, freezedUnitTexture)
	
	if self:isPointInside(projectile.x, projectile.y) then
		-- They have collided...
		if projectile.type == "fireball" or projectile.type == "hammer" then
			self:resolveDeadlyProjectileCollision(projectile, particleSystem)
		elseif projectile.type == "iceball" and self.notFreezable == false then
			self:freeze(particleSystem, freezedUnitTexture)
		end
		
		-- This projectile will be removed... for sure
		if projectile.type ~= "hammer" then
			projectile:fadeOut()
		else
			projectile:remove()
		end
	end
end

function Unit:doesCollideWithUnit(unit)
	return rectRectCollision(self.x - self.width/2, 
		self.y - self.height/2, self.width, self.height,
		unit.x - unit.width/2, unit.y - unit.height/2,
		unit.width, unit.height)
end

function Unit:isPointInside(x, y)
	return pointInRect(x, y, self.x - self.width/2,
		self.y - self.height/2, self.width, self.height)
end

function Unit:updateVerticalMovement(deltaTime, gravityAcc)
	if self.isJumping then
		self.verticalVel = self.verticalVel - gravityAcc * deltaTime
		
		if self.verticalVel <= 0 then
			self.verticalVel = 0
			self.isJumping = false
			self.isFalling = true
		end
	elseif self.isFalling then
		self.verticalVel = self.verticalVel + gravityAcc * deltaTime
		
		if self.verticalVel > self.jumpingVelBase then
			self.verticalVel = self.jumpingVelBase
		end
	end
end

function Unit:updateHorizontalMovement(deltaTime, gravityAcc)
	if self.isMovingHor then
		if self.isHorMovementActive then
			self.isHorMovementActive = false
			
			if self.sprintEnabled and 
				self.horizontalVel < self.horizontalVelBase * self.sprintVelQ then
				-- Sprint enabled? Increase actual horizontal velocity
				-- if it is possible...
				self.horizontalVel = self.horizontalVel + 
					self.horizontalDec * deltaTime
			end
		else
			self.horizontalVel = self.horizontalVel - 
				self.horizontalDec * deltaTime
				
			-- Disable sprint if you are not moving at all
			self.sprintEnabled = false
			
			if self.horizontalVel <= 0 then
				self.horizontalVel = 0
				self.isMovingHor = false
			end
		end
	end
end

function Unit:updateBasicTimers(deltaTime)
	if self.tryToJumpTimer > 0 then
		self.tryToJumpTimer = self.tryToJumpTimer - deltaTime
		self:tryToJumpNoTimer()
	end
	
	if self.jumpOffPlatformTimer > 0 then
		self.jumpOffPlatformTimer = self.jumpOffPlatformTimer - deltaTime
	end
	
	if self.isFading then
		self.alpha = self.alpha - 2048 * deltaTime
		
		if self.alpha <= 0 then
			self.isFading = false
			self.alpha = 0
			self.dead = true
		end
	end
end

-- Freeze timer has to be updated separately,
-- because this is the only function which is 
-- called upon unit while it's freezed
function Unit:updateFreezeTimer(deltaTime)
	if self.freezeTimer > 0 then
		self.freezeTimer = self.freezeTimer - deltaTime
	end
end

-- Camera and particle system are not used right now, 
-- but for some units they may come handy later
function Unit:update(deltaTime, gravityAcc, particleSystem, camera)
	self:updateVerticalMovement(deltaTime, gravityAcc)
	self:updateHorizontalMovement(deltaTime, gravityAcc)
	self:updateBasicTimers(deltaTime)
end

-- Make update function accessible in inheritance
Unit.superUpdate = Unit.update

function Unit:drawRectangleAround(camera)
	love.graphics.rectangle("line", self.x - self.width/2 - camera.x,
		self.y-self.height/2-camera.y, self.width, self.height)
end

-- Draw unit
function Unit:draw(camera, texAngle)
	-- texAngle is either set and not null or null
	local angle = texAngle ~= nil and texAngle or 0
	
	local r, g, b = love.graphics.getColor()
	love.graphics.setColor(r, g, b, self.alpha)
	
	self.activeAnim:draw(camera, self.x - self.width/2, 
		self.y - self.height/2, self.width, self.height, angle,
		self.isFacingLeft)
		
	love.graphics.setColor(r, g, b, 255)
end

-- Make draw function accessible in inheritance
Unit.superDraw = Unit.draw