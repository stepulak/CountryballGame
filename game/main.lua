require "Game"
require "TileHeader"
require "Font"
require "TexturesLoad"
require "Utils"

local screen = {
	virtualWidth = 1200,
	virtualHeight = 900,
	width,
	height,
}

local game
local sinCosTable
local textureContainer
local headerContainer
local fonts

-- Load all tile headers based on their properties in TileHeadersProperties
function loadTileHeaders()
	headerContainer = TileHeaderContainer:new()
	fillTileHeaderContainer(headerContainer, textureContainer)
end

function loadFonts()
	--[[
	fonts = {
		small = Font:new(love.graphics.newFont("assets/font/Crom_v1.ttf", 16)),
		medium = Font:new(love.graphics.newFont("assets/font/Crom_v1.ttf", 25)),
		big = Font:new(love.graphics.newFont("assets/font/Crom_v1.ttf", 38))
	}]]
	fonts = {
		small = Font:new(love.graphics.newFont(16)),
		medium = Font:new(love.graphics.newFont(25)),
		big = Font:new(love.graphics.newFont(38))
	}
end

function love.load()
	-- Set new randomseed
	math.randomseed(os.time())
	
	-- Find out the dimensions of window (or screen if fullscreen is enabled)
	screen.width, screen.height = love.window.getMode()
	
	-- Disabled by default
	love.keyboard.setTextInput(false)
	
	sinCosTable = SinCosTable:new()
	textureContainer = loadTextures()
	loadTileHeaders()
	loadFonts()
	
	game = Game:new(screen, textureContainer, headerContainer, sinCosTable, fonts)
end

-- Transform mouse coordinates from real coordinates to virtual coordinates
function transformMouseCoordinates(x, y)
	local sx, sy = getScaleRealToVirtual(screen.width, screen.virtualWidth,
		screen.height, screen.virtualHeight)
	return x * sx, y * sy
end

function love.keypressed(key, scancode, isRepeated)
	game:handleKeyPress(key)
	
	-- Unusual but escape is used for another purposes
	if key == "f1" then
		love.event.quit()
	end
end

function love.keyreleased(key, scancode, isRepeated)
	game:handleKeyRelease(key)
end

function love.textinput(text)
	game:handleTextInput(text)
end

function love.mousepressed(x, y, button, isTouch)
	local tx, ty = transformMouseCoordinates(x, y)
	game:handleMouseClick(tx, ty)
end

function love.mousereleased(x, y, button, isTouch)
	local tx, ty = transformMouseCoordinates(x, y)
	game:handleMouseRelease(tx, ty)
end

function love.mousemoved(x, y, dx, dy, istouch)
	local tx, ty = transformMouseCoordinates(x, y)
	-- distance can be transformed too with the same function
	local tdx, tdy = transformMouseCoordinates(dx, dy)
	game:handleMouseMove(tx, ty, tdx, tdy)
end

function love.update(deltaTime)
	game:update(deltaTime)
end

function love.draw()
	local sx, sy = getScaleVirtualToReal(screen.width, screen.virtualWidth,
		screen.height, screen.virtualHeight)
		
	love.graphics.scale(sx, sy)
	game:draw()
	love.graphics.scale(1, 1)
end