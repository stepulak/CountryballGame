require "AnimationScene"
require "Game"

Campaign = Runnable:new()

function Campaign:init(screen, textureContainer, soundContainer,
	headerContainer, sinCosTable, fonts)
	
	self.screen = screen
	self.textureContainer = textureContainer
	self.soundContainer = soundContainer
	self.headerContainer = headerContainer
	self.sinCosTable = sinCosTable
	self.fonts = fonts
	
	self.name = nil
	self.content = {}
	self.run = nil -- Active runnable content
	
	self.hasSavefile = false
end

function Campaign:addLevel(worldLoadFunc)
	self.content[#self.content + 1] = {
		type = "level",
		loadFunc = worldLoadFunc,
	}
end

function Campaign:addScene(sceneLoadFunc)
	self.content[#self.content + 1] = {
		type = "scene",
		loadFunc = sceneLoadFunc,
	}
end

function Campaign:setName(name)
	self.name = name
end

-- Load campaign's savefile's content from love.filesystem.getSaveDirectory()
-- Campaign's name (via Campaign:setName()) must be set first!
function Campaign:loadSavefile()
	local filename = self.name .. ".lua"
	
	if love.filesystem.exists(filename) then
		self.hasSavefile = true
		-- TODO
	else
		self.hasSavefile = false
	end
end

-- Can you continue playing? Is there any savefile of it?
function Campaign:canContinue()
	return self.hasSavefile
end

-- Load save file and continue playing the campaign.
function Campaign:continue()

end

-- Reset save file (if it exists) and play the campaign from start.
function Campaign:freshStart()

end

function Campaign:handleKeyRelease(key)
	self.run:handleKeyRelease(key)
end

function Campaign:handleTextInput(text)
	self.run:handleTextInput(text)
end

function Campaign:handleMouseClick(x, y)
	self.run:handleMouseClick(x, y)
end

function Campaign:handleMouseRelease(x, y)
	self.run:handleMouseRelease(x, y)
end

function Campaign:handleMouseMove(x, y, dx, dy)
	self.run:handleMouseMove(x, y, dx, dy)
end

function Campaign:handleTouchPress(id, tx, ty)
	self.run:handleTouchPress(id, tx, ty)
end

function Campaign:handleTouchRelease(id, tx, ty)
	self.run:handleTouchRelease(id, tx, ty)
end

function Campaign:handleTouchMove(id, tx, ty, tdx, tdy)
	self.run:handleTouchMove(id, tx, ty, tdx, tdy)
end

function Campaign:shouldQuit()
	return false
end

function Campaign:update(deltaTime)
	self.run:update(deltaTime)
end

function Campaign:draw()
	self.run:draw()
end