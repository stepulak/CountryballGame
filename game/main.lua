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

local paused = false

-- Load all tile headers based on their properties in TileHeadersProperties
function loadTileHeaders()
	headerContainer = TileHeaderContainer:new()
	fillTileHeaderContainer(headerContainer, textureContainer)
end

function loadFonts()
	fonts = {
		small = Font:new(love.graphics.newFont(16)),
		medium = Font:new(love.graphics.newFont(25)),
		big = Font:new(love.graphics.newFont(38))
	}
end

function love.load()
	-- Create save directory if it doesn't exist yet
	love.filesystem.createDirectory(SAVE_DIR)
	
	-- Set new randomseed
	math.randomseed(os.time())
	
	-- Find out the dimensions of window (or screen if fullscreen is enabled)
	screen.width, screen.height = love.window.getMode()
	
	-- Disabled by default
	love.keyboard.setTextInput(false)
	
	sinCosTable = SinCosTable:new()
	textureContainer = loadTextures()
	soundContainer = loadSounds(screen)
	loadTileHeaders()
	loadFonts()
	
	mainMenu = MainMenu:new(screen, textureContainer, soundContainer,
		headerContainer, sinCosTable, fonts)
end

-- Transform mouse coordinates from real coordinates to virtual coordinates
function transformMouseCoordinates(x, y)
	local sx, sy = getScaleRealToVirtual(
		screen.width, screen.virtualWidth,
		screen.height, screen.virtualHeight)
	return x * sx, y * sy
end

function screenshot()
	local sh = love.graphics.newScreenshot()
	sh:encode("png", os.time() .. ".png")
end

function love.keypressed(key, scancode, isRepeated)
	mainMenu:handleKeyPress(key)
	
	-- Unusual but escape key is used for other purposes
	if key == "f1" then
		love.event.quit()
	elseif key == "f12" then
		screenshot()
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

--
-- Since the love.touchreleased and the love.touchmoved are not working at all
-- (atleast on my mobile phone *wtf*?) So we have to create our own mechanism
-- using love.touch.getTouches() and love.touch.getPosition()
-- to "simulate" release and movement.

local touches = {}

function addTouch(id, tx, ty)
	touches[id] = { 
		x = tx,
		y = ty,
		active = false,
	}
end

function updateTouches()
	local currTouches = love.touch.getTouches()
	
	for _, id in pairs(currTouches) do
		if touches[id] ~= nil then
			-- Touch is still active (pressure on the screen)
			touches[id].active = true
		end
	end
	
	-- Update active/inactive touches
	for id, touch in pairs(touches) do
		if touch.active then
			-- They are active, process the touchmove
			local x, y = love.touch.getPosition(id)
			transformMouseCoordinates(x, y)
			
			if x ~= touch.x or y ~= touch.y then
				mainMenu:handleTouchMove(id, x, y, x - touch.x, y - touch.y)
				touch.x = x
				touch.y = y
			end
			
			touch.active = false
		else
			-- Inactive, process the touchrelease
			mainMenu:handleTouchRelease(id, touch.x, touch.y)
			touches[id] = nil
		end
	end
end

function love.touchpressed(id, x, y, dx, dy, pressure)
	local tx, ty = transformMouseCoordinates(x, y)
	mainMenu:handleTouchPress(id, tx, ty)
	addTouch(id, tx, ty)
end

function love.touchreleased(id, x, y, dx, dy, pressure)
	-- Not working
end

function love.touchmoved(id, x, y, dx, dy, pressure)
	-- Not working
end

-- Mute/unmute if it's paused/unpaused
function checkAudio()
	if paused then
		love.audio.pause()
	else
		love.audio.resume()
	end
end

function love.focus(foc)
	paused = not foc
	checkAudio()
end

function love.visible(vis)
	paused = not vis
	checkAudio()
end

function love.update(deltaTime)
	if deltaTime > MIN_FPS then
		deltaTime = MIN_FPS
	end
	
	if paused == false then
		updateTouches()
		mainMenu:update(deltaTime)
		
		if mainMenu:shouldQuit() then
			love.event.push("quit")
		end
	end
end

function love.draw()
	local sx, sy = getScaleVirtualToReal(screen.width, screen.virtualWidth,
		screen.height, screen.virtualHeight)
		
	love.graphics.scale(sx, sy)
	mainMenu:draw()
	love.graphics.scale(1, 1)
end