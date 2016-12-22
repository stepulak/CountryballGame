require "Unit"

Coin = Unit:new()

function Coin:init(x, y, tileWidth, tileHeight, anim)
	self:super("coin", x, y, tileWidth*0.9, tileHeight*0.9, 
		0, 0, anim)
	
	self.friendlyToPlayer = true
end

function Coin:updateAnimations(deltaTime)
	self.activeAnim = self.idleAnim
	self.activeAnim:update(deltaTime)
end