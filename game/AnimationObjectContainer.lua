require "AnimationObject"

-- Animation object container (set) for
-- storing animation objects, for each type (name) only once
--
-- Like in the TileHeaderContainer, this is used for
-- automatic updates of object's animations etc...

AnimationObjectContainer = class:new()

function AnimationObjectContainer:init()
	self.container = {}
end

function AnimationObjectContainer:add(name, obj)
	self.container[name] = obj
	return obj
end

function AnimationObjectContainer:get(name)
	return self.container[name]
end

function AnimationObjectContainer:updateAnimObjects(deltaTime)
	for name, obj in pairs(self.container) do
		obj.anim:update(deltaTime)
	end
end