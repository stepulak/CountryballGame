require "class"
require "Tile"

TileHeaderContainer = class:new()

function TileHeaderContainer:init()
	self.tileHeaders = {}
end

-- Add tile header to the container
function TileHeaderContainer:addHeader(name, header)
	self.tileHeaders[name] = header
	return self
end

-- Get tile header from the container
function TileHeaderContainer:getHeader(headerName)
	return self.tileHeaders[headerName]
end

-- Update tile headers in the container
function TileHeaderContainer:updateTileHeaders(deltaTime, updateCounter)
	for name, header in pairs(self.tileHeaders) do
		if header ~= nil then
			header:update(deltaTime, updateCounter)
		end
	end
end