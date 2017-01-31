require "MainMenu"
require "TileHeader"
require "Font"
require "TexturesLoad"
require "SoundsLoad"
require "Utils"

local screen = {
	virtualWidth = 1200,
	virtualHeight = 675,
	width,
	height,
}

local mainMenu
local sinCosTable
local textureContainer
local soundContainer
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
	soundContainer = loadSounds()
	loadTileHeaders()
	loadFonts()
	
	mainMenu = MainMenu:new(screen, textureContainer, soundContainer,
		headerContainer, sinCosTable, fonts)
end

-- Transform mouse coordinates from real coordinates to virtual coordinates
function transformMouseCoordinates(x, y)
	local sx, sy = getScaleRealToVirtual(screen.width, screen.virtualWidth,
		screen.height, screen.virtualHeight)
	return x * sx, y * sy
end

function love.keypressed(key, scancode, isRepeated)
	mainMenu:handleKeyPress(key)
	
	-- Unusual but escape is used for another purposes
	if key == "f1" then
		love.event.quit()
	end
end

function love.keyreleased(key, scancode, isRepeated)
	mainMenu:handleKeyRelease(key)
end

function love.textinput(text)
	mainMenu:handleTextInput(text)
end

function love.mousepressed(x, y, button, isTouch)
	if isTouch == false then
		local tx, ty = transformMouseCoordinates(x, y)
		mainMenu:handleMouseClick(tx, ty)
	end
end

function love.mousereleased(x, y, button, isTouch)
	if isTouch == false then
		local tx, ty = transformMouseCoordinates(x, y)
		mainMenu:handleMouseRelease(tx, ty)
	end
end

function love.mousemoved(x, y, dx, dy, isTouch)
	if isTouch == false then
		local tx, ty = transformMouseCoordinates(x, y)
		-- distance can be transformed too with the same function
		local tdx, tdy = transformMouseCoordinates(dx, dy)
		mainMenu:handleMouseMove(tx, ty, tdx, tdy)
	end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	local tx, ty = transformMouseCoordinates(x, y)
	mainMenu:handleTouchPress(id, tx, ty)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
	local tx, ty = transformMouseCoordinates(x, y)
	mainMenu:handleTouchRelease(id, tx, ty)
end

function love.touchmoved(id, x, y, dx, dy, pressure)
	local tx, ty = transformMouseCoordinates(x, y)
	local tdx, tdy = transformMouseCoordinates(dx, dy)
	mainMenu:handleTouchMove(id, tx, ty, tdx, tdy)
end

function love.update(deltaTime)
	mainMenu:update(deltaTime)
end

function love.draw()
	local sx, sy = getScaleVirtualToReal(screen.width, screen.virtualWidth,
		screen.height, screen.virtualHeight)
		
	love.graphics.scale(sx, sy)
	mainMenu:draw()
	love.graphics.scale(1, 1)
end