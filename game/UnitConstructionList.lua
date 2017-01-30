require "Unit"
require "Player"
require "Zombie"
require "CanonBall"
require "Turtle"
require "Mushroom"
require "Flower"
require "Star"
require "Coin"
require "Jumper"
require "RotatingGhost"
require "FlyingZombie"
require "BouncingZombie"
require "Spiky"
require "Bomberman"
require "Hammerman"
require "Fish"
require "Rocket"

local constructionList = {
	["player"] = function(p)
		return Player:new(p.x, p.y, p.tileWidth, p.tileHeight, 2, 0,
			p.tc:getAnimation("player_idle"),
			p.tc:getAnimation("player_walking"),
			p.tc:getAnimation("player_jumping"),
			p.tc:getAnimation("player_swimming"),
			p.tc:getAnimation("player_attacking"),
			p.tc:getTexture("player_dead"),
			p.tc:getTexture("players_helmet"),
			p.tc:getTexture("star"),
			p.tc:getTexture("bubble"),
			p.tc:getTexture("smoke"))
	end,
	
	["turtle"] = function(p)
		return Turtle:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.tc:getAnimation("turtle"), 
			p.tc:getTexture("turtle_shell"))
	end,
	
	["zombie"] = function(p)
		return Zombie:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.tc:getAnimation("zombie"))
	end,
	
	["star"] = function(p)
		return Star:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.dirLeft, p.tc:getTexture("star"))
	end,
	
	["spiky"] = function(p)
		return Spiky:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.tc:getAnimation("spiky"))
	end,
	
	["rocket"] = function(p)
		return Rocket:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.tc:getAnimation("rocket"), 
			p.tc:getTexture("smoke"))
	end,
	
	["mushroom_grow"] = function(p)
		return Mushroom:new("grow", p.x, p.y, p.tileWidth, p.tileHeight,
			p.dirLeft, p.tc:getTexture("mushroom_grow"))
	end,
	
	["mushroom_life"] = function(p)
		return Mushroom:new("life", p.x, p.y, p.tileWidth, p.tileHeight,
			p.dirLeft, p.tc:getTexture("mushroom_life"))
	end,
	
	["jumper"] = function(p)
		return Jumper:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.tc:getAnimation("jumper_idle"),
			p.tc:getAnimation("jumper_jumping"))
	end,
	
	["hammerman"] = function(p)
		return Hammerman:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.tc:getAnimation("hammerman_idle"),
			p.tc:getAnimation("hammerman_jumping"),
			p.tc:getAnimation("hammerman_attacking"))
	end,
	
	["flying_zombie"] = function(p)
		return FlyingZombie:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.tc:getAnimation("flying_zombie"))
	end,
	
	["fireflower"] = function(p)
		return Flower:new("fire", p.x, p.y, p.tileWidth, p.tileHeight,
			p.tc:getTexture("fireflower"))
	end,
	
	["iceflower"] = function(p)
		return Flower:new("ice", p.x, p.y, p.tileWidth, p.tileHeight,
			p.tc:getTexture("iceflower"))
	end,
	
	["fish"] = function(p)
		return Fish:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.tc:getAnimation("fish"))
	end,
	
	["coin"] = function(p)
		return Coin:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.tc:getAnimation("coin"))
	end,
	
	["canonball"] = function(p)
		return CanonBall:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.dirLeft, p.tc:getAnimation("canonball"))
	end,
	
	["bouncing_zombie"] = function(p)
		return BouncingZombie:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.tc:getAnimation("bouncing_zombie"))
	end,
	
	["bomberman"] = function(p)
		return Bomberman:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.tc:getAnimation("bomberman_walking"),
			p.tc:getAnimation("bomberman_countdown"),
			p.tc:getAnimation("explosion"))
	end,
	
	["rotating_ghost"] = function(p)
		return RotatingGhost:new(p.x, p.y, p.tileWidth, p.tileHeight,
			p.tc:getAnimation("rotating_ghost"))
	end,
}

-- @dirLeft, @type is optional
function createUnitFromName(name, 
	x, y, tileWidth, tileHeight, 
	textureContainer, dirLeft)
	
	if constructionList[name] == nil then
		return nil
	end
	
	if dirLeft == nil then
		dirLeft = true
	end
	
	local params = {
		["x"] = x,
		["y"] = y,
		["tileWidth"] = tileWidth,
		["tileHeight"] = tileHeight,
		["tc"] = textureContainer,
		["dirLeft"] = dirLeft
	}
	
	return constructionList[name](params)
end

function getUnitNamesList()
	return getKeysFromTable(constructionList)
end