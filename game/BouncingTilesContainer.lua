require "LinkedList"
require "BouncingTile"

--  Bouncing tiles container
BouncingTilesContainer = class:new()

function BouncingTilesContainer:init(bouncingTileMaxHeight)
	self.bouncingTileMaxHeight = bouncingTileMaxHeight
	self.tiles = LinkedList:new()
end

function BouncingTilesContainer:addTile(tile)
	self.tiles:pushBack(BouncingTile:new(tile, self.bouncingTileMaxHeight))
end

function BouncingTilesContainer:update(deltaTime)
	local it = self.tiles.head
	
	while it ~= nil do
		it.data:update(deltaTime)
		
		if it.data:shouldBeRemoved() then
			local it2 = it.next
			self.tiles:deleteNode(it)
			it = it2
		else
			it = it.next
		end
	end
end