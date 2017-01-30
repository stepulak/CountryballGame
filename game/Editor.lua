require "World"
require "Gui"
require "UnitConstructionList"
require "ActiveObjectConstructionList"
require "Runnable"

Editor = Runnable:new()

function Editor:init(world, fonts)
	self.name = "editor"
	
	self.fonts = fonts
	self.world = world
	self.screen = world.screen
	self.textureContainer = world.textureContainer
	
	self.gridVisible = false
	self.activePick = nil
	
	self:createGui()
end

function Editor:resume()
	self.world.soundContainer:muteAll()
end

local GridObjW = 75
local GridObjH = 75

function Editor:createTilesGrid()
	local grid = self.multigrid:newImageGrid("Tiles", GridObjW, GridObjH)
	local headers = self.world.headerContainer.tileHeaders
	
	for name, header in pairs(headers) do
		local data = {
			header = header,
			width = self.world.tileWidth,
			height = self.world.tileHeight,
		}
		
		grid:addElement(header.animation:firstTexture(), header.name,
			header.generatorType or "", data)
	end
end

function Editor:createUnitsGrid()
	local grid = self.multigrid:newImageGrid("Units", GridObjW, GridObjH)
	local unitNames = getUnitNamesList()
	
	for i = 1, #unitNames do
		if unitNames[i] ~= "player" then
			local unit = createUnitFromName(unitNames[i], 0, 0, 
				self.world.tileWidth, self.world.tileHeight,
				self.textureContainer, true)
			
			-- "hack" cam
			local fakeCam = { x = -unit.width/2, y = -unit.height/2 }
			
			local unX, unY = getScaleRealToVirtual(
				unit.width, GridObjW, unit.height, GridObjH)
			
			local data = { 
				name = unit.name,
				width = unit.width,
				height = unit.height,
			}
			
			grid:addElement(
				function()
					love.graphics.push()
					
					-- Exception! Rotating ghost is tricky one
					if unit.name == "rotating_ghost" then
						unit.x, unit.y = 0, 0
					else
						love.graphics.scale(unX, unY)
					end
					
					unit:draw(fakeCam, 0)
					love.graphics.pop()
				end,
				unit.name, "", data)
		end
	end
end

function Editor:createActiveObjectsGrid()
	local grid = self.multigrid:newImageGrid("Active objs", GridObjW, GridObjH)
	local objNames = getActiveObjectNamesList()
	local fakeCam = { x = 0, y = 0 }	
	
	for i = 1, #objNames do
		local obj = createActiveObjectFromName(objNames[i], 0, 0,
			self.world.tileWidth, self.world.tileHeight,
			self.textureContainer, true)
		
		-- Fix the minimum size (cannot be smaller than tile)
		local width = setWithinRange(
			obj.realWidth, self.world.tileWidth, 999)
			
		local height = setWithinRange(
			obj.realHeight, self.world.tileHeight, 999)
		
		local obX, obY = getScaleRealToVirtual(
			width, GridObjW, height, GridObjH)
		
		local data = {
			name = obj.name,
			-- obj.realWidth, obj.realHeight can have different 
			-- overall place proportions, stick with these...
			width = obj.width * self.world.tileWidth,
			height = obj.height * self.world.tileHeight,
		}
		
		grid:addElement(
			function()
				love.graphics.push()
				
				-- platform *fix*
				if string.find(objNames[i], "platform") then
					love.graphics.translate(-self.world.tileWidth/3, 0)
				end
				
				love.graphics.scale(obX, obY)
				obj:draw(fakeCam, 0)
				love.graphics.pop()
			end,
			obj.name, "", data)
	end
end

function Editor:createAnimationObjectsGrid()
	local grid = self.multigrid:newImageGrid("Animation objs",
		GridObjW, GridObjH)
	
	local objNames = getAnimationObjectNamesList()
	local fakeCam = { x = 0, y = 0 }
	
	for i = 1, #objNames do
		local obj = createAnimationObjectFromName(objNames[i], 0, 0,
			self.world.tileWidth, self.world.tileHeight,
			self.textureContainer, nil)
		
		local obX, obY = getScaleRealToVirtual(
			obj.realWidth, GridObjW, obj.realHeight, GridObjH)
		
		local info = "Size: " .. obj.width .. ", " .. obj.height
		
		local data = { 
			name = obj.name,
			width = obj.realWidth,
			height = obj.realHeight
		}
		
		grid:addElement(
			function()
				love.graphics.push()
				love.graphics.scale(obX, obY)
				obj:draw(fakeCam, 0)
				love.graphics.pop()
			end,
			obj.name, info, data)
	end
end

function Editor:createTileCheckBox()
	self.tileType = "collidable"
	
	local chbox = CheckBox:new("Tile type", self.fonts.medium, 
		0.55 * self.screen.virtualWidth, 20, 200, 40)
	
	chbox:addCheckButton("collidable", 
		function() 
			self.tileType = "collidable"
		end)
	
	chbox:addCheckButton("background",
		function()
			self.tileType = "background"
		end)
	
	chbox:addCheckButton("water",
		function()
			self.tileType = "water"
		end)
	
	self.gui:addElement(chbox)
end

function Editor:createAnimationObjectCheckBox()
	self.animObjPosition = "foreground"
	
	local chbox = CheckBox:new("Animation object pos", self.fonts.medium,
		0.75 * self.screen.virtualWidth, 20, 200, 40)
	
	chbox:addCheckButton("foreground",
		function()
			self.animObjPosition = "foreground"
		end)
	
	chbox:addCheckButton("background",
		function()
			self.animObjPosition = "background"
		end)
	
	self.gui:addElement(chbox)
end

function Editor:createInsertCheckBox()
	self.insertDirection = "left"
	
	local chbox = CheckBox:new("Inserting dir", self.fonts.medium,
		0.75 * self.screen.virtualWidth, 150, 200, 40)
	
	chbox:addCheckButton("left",
		function()
			self.insertDirection = "left"
		end)
		
	chbox:addCheckButton("right",
		function()
			self.insertDirection = "right"
		end)
	
	self.gui:addElement(chbox)
end

function Editor:createActionCheckBox()
	self.actionMode = "nothing"
	
	local chbox = CheckBox:new("Action", self.fonts.medium,
		0.75 * self.screen.virtualWidth, 300, 200, 40)
	
	chbox:addCheckButton("nothing",
		function()
			self.actionMode = "nothing" -- safe part :)
		end)
	
	chbox:addCheckButton("remove",
		function()
			self.actionMode = "remove"
		end)
		
	chbox:addCheckButton("insert",
		function()
			self.actionMode = "insert"
		end)
		
	
	self.gui:addElement(chbox)
end

function Editor:createGui()
	self.gui = GuiContainer:new()
	
	self.multigrid = MultiImageGrid:new(20, 20, 
		self.screen.virtualWidth/2,
		self.screen.virtualHeight/2,
		self.fonts.medium)
	
	self.gui:addElement(self.multigrid)
	
	-- Grids
	self:createTilesGrid()
	self:createUnitsGrid()
	self:createActiveObjectsGrid()
	self:createAnimationObjectsGrid()
	
	-- Checkboxes
	self:createTileCheckBox()
	self:createAnimationObjectCheckBox()
	self:createInsertCheckBox()
	self:createActionCheckBox()
	
	-- Console
	self.console = Console:new(20, self.screen.virtualHeight - 
		self.fonts.medium.font:getHeight(), self.fonts.medium)
	
	self.gui:addElement(self.console)
	
	self.gui:addElement(Button:new("Prerun weather", self.fonts.medium,
		0.55 * self.screen.virtualWidth, 200, 220, 40,
		function() 
			self.world:preRunWeather()
		end))
end

function Editor:setCameraVelocity(words)
	local backgroundLvl = tonumber(words[2])
	local velocity = math.abs(tonumber(words[3]))
	
	f.world:setCameraVelocityParallaxBackground(backgroundLvl, velocity)
end

function Editor:connectTeleports(words)
	local t1X = tonumber(words[2])
	local t1Y = tonumber(words[3])
	local t2X = tonumber(words[4])
	local t2Y = tonumber(words[5])
	
	if t1X == nil or t1Y == nil or t2X == nil or t2Y == nil then
		print("Unvalid teleport coordinates")
		return
	end
	
	if self.world:connectTeleports(t1X, t1Y, t2X, t2Y) then
		print("Teleports connected")
	end
end

function Editor:setPlayersSpawnPos(words)
	local x, y = 5, 2
	
	if words[2] ~= "default" then
		x = tonumber(words[2])
		y = tonumber(words[3])
	end
	
	if self.world:setPlayersSpawnPosition(x, y) then
		print("Spawn position set")
	end
end

function Editor:setPlayersFinishLine(words)
	local x = self.world.numTilesWidth - 3
	
	if words[2] ~= "default" then
		x = tonumber(words[2])
	end
	
	if self.world:setPlayersFinishLine(x) then
		print("Finish line set")
	end
end

function Editor:changeWeather(words)
	local weatherName = words[1] == "snow" and "Snow" or "Rain"
	local operation = words[2]
	local backgroundLvl = tonumber(words[3])
	
	if operation == "enable" then
		self.world:enableWeather(backgroundLvl, weatherName, 
			words[4] == "true")
		
		print(weatherName .. " may have been enabled")
	elseif operation == "disable" then
		self.world:disableWeather(backgroundLvl, weatherName)
		
		print(weatherName .. " may have been disabled")
	end
end

function Editor:changeClouds(words)
	local operation = words[2]
	local backgroundLvl = tonumber(words[3])
	
	if operation == "enable" then
		local bigClouds = (words[4] == "true") -- or "false"
		local numCloudsMax = tonumber(words[5])
		
		self.world:enableWeather(backgroundLvl, "Clouds", 
			bigClouds, numCloudsMax)
			
		print("Clouds may have been enabled")
	elseif operation == "disable" then
		self.world:disableWeather(backgroundLvl, "Clouds")
		
		print("Clouds may have been disabled")
	end
end

function Editor:changeBackgroundColor(words)
	local backgroundLvl = tonumber(words[2])
	local r = setWithinRange(tonumber(words[3]), 0, 255)
	local g = setWithinRange(tonumber(words[4]), 0, 255)
	local b = setWithinRange(tonumber(words[5]), 0, 255)
	local a = setWithinRange(tonumber(words[6]), 0, 255)
	
	self.world:setBackgroundColor(backgroundLvl, r, g, b, a)
	
	print("Background color may have been set")
end

function Editor:changeBackgroundTexture(words)
	local backgroundLvl = tonumber(words[2])
	local textureName = words[3]
	
	self.world:setBackgroundTexture(backgroundLvl, textureName)
	
	print("Background texture may have been set")
end

function Editor:loadWorldFrom(filename)
	if filename == nil then
		print("Missing filename")
		return
	end
	
	if self.world:loadFromSaveDir(filename) then
		print("World has been loaded")
	else
		print("World hasn't been loaded")
	end
end

function Editor:saveWorldInto(filename)
	if filename == nil then
		print("Missing filename")
		return
	end
	
	self.world:saveInto(filename)
	self.lastSavePath = filename
	
	print("World may have been saved")
end

function Editor:setWorldMusic(name)
	self.world:setBackgroundMusic(name)
	
	print("Music may have been set")
end

function Editor:parseCommandFromConsole(cmd)
	local words = splitStringBySpace(cmd)
	
	if words[1] == "camera_velocity" then
		-- format: camera_velocity @backgroundLvl @velocity
		self:setCameraVelocity(words)
	elseif words[1] == "background_texture" then
		-- format: background_texture @backgroundLvl @textureName
		-- Note that @textureName must be valid texture from textureContainer
		self:changeBackgroundTexture(words)
	elseif words[1] == "background_color" then
		-- format: background_color @backgroundLvl @r @g @b @a
		-- @r,g,b,a from range [0, 255]
		self:changeBackgroundColor(words)
	elseif words[1] == "clouds" then
		-- 1) format: clouds enable @backgroundLvl @bigClouds @numCloudsMax
		-- 2) format: clouds disable @backgroundLvl
		self:changeClouds(words)
	elseif words[1] == "snow" or words[1] == "rain" then
		-- 1) format: snow|rain enable @backgroundLvl light|heavy
		-- 2) format: snow|rain disable @backgroundLvl
		self:changeWeather(words)
	elseif words[1] == "spawn_pos" then
		-- format: spawn_pos default|(@tileX @tileY)
		self:setPlayersSpawnPos(words)
	elseif words[1] == "connect_teleports" then
		-- format: connect_teleports @t1-tileX @t1-tileY @t2-tileX @t2-tileY
		self:connectTeleports(words)
	elseif words[1] == "finish_line" then
		-- format: finish_line default|@tileX
		self:setPlayersFinishLine(words)
	elseif words[1] == "save" then
		self:saveWorldInto(words[2])
	elseif words[1] == "load" then
		self:loadWorldFrom(words[2])
	elseif words[1] == "set_music" then
		self:setWorldMusic(words[2])
	end
end

local EditorDefaultWorldPath = "quicksave.lua"

function Editor:quickSave()
	self:saveWorldInto(self.lastSavePath and self.lastSavePath or EditorDefaultWorldPath)
	
	if self.lastSavePath == nil then
		self.lastSavePath = EditorDefaultWorldPath
	end
end

function Editor:quickLoad()
	self:loadWorldFrom(self.lastSavePath or EditorDefaultWorldPath)
end

function Editor:shouldSelectNewPick()
	if self.activePick == nil or 
		self.activePick.from ~= self.multigrid.activeGridName then
		return true
	else
		local name = self.multigrid:getActiveImageGrid():getActiveElement()
		return name ~= self.activePick.name
	end
end

local EditorPickSize = 30

function Editor:selectNewPick()
	if self.multigrid:getActiveImageGrid():getActiveElement() == nil then
		return
	end
	
	self.activePick = {}
	self.activePick.from = self.multigrid.activeGridName
	
	local name, data, draw = 
		self.multigrid:getActiveImageGrid():getActiveElement()
	
	self.activePick.name = name
	self.activePick.data = data
	
	-- Scale the pick so that it would looks real in map
	local scX, scY = getScaleVirtualToReal(
		EditorPickSize, data.width, EditorPickSize, data.height)
	
	self.activePick.draw = 
		function()
			love.graphics.push()
			love.graphics.scale(scX, scY)
			draw()
			love.graphics.pop()
		end
end

function Editor:insertPick()
	local data = self.activePick.data
	local from = self.activePick.from
	
	local mx, my = getScaledMousePosition(self.world.camera, true)
	local tx, ty = self:tileCoords(mx, my)
	
	if from == "Tiles" then
		-- Set it into the world's grid
		self.world:setTile(tx, ty, self.tileType, data.header.name)
	elseif from == "Units" then
		-- Center of the unit!
		local cX = tx * self.world.tileWidth + data.width/2
		local cY = ty * self.world.tileHeight + data.height/2
		
		-- Remember, that changing the insert direction is only 
		-- applicable on some units, whereas most of them have
		-- their default movement direction set to left
		local unit = createUnitFromName(data.name, cX, cY,
			self.world.tileWidth, self.world.tileHeight,
			self.textureContainer, self.insertDirection == "left")
		
		self.world:addUnit(unit)
	elseif from == "Active objs" then
		local obj = createActiveObjectFromName(data.name, tx, ty, 
			self.world.tileWidth, self.world.tileHeight,
			self.textureContainer, self.insertDirection == "left")
		
		if self.world:addActiveObject(obj) then
			print("Active object has been added")
		else
			print("Active object couldn't have been added")
		end
	elseif from == "Animation objs" then
		local obj = createAnimationObjectFromName(
			data.name, tx, ty,
			self.world.tileWidth, self.world.tileHeight, 
			self.textureContainer, self.world.animObjContainer)
			
		if self.world:addAnimationObject(obj, self.animObjPosition) then
			print("Animation object has been added")
		else
			print("Animation object couldn't have been added")
		end
	end
end

-- First, try to remove unit on mouse cursor
-- If there is none, try to remove active object
-- Then continue (only if you fail) to animation object
-- and end up with tiles
function Editor:removeObj()
	local mx, my = getScaledMousePosition(self.world.camera, true)
	
	if self.world:removeUnit(mx, my) == false then
		local tx, ty = self:tileCoords(mx, my)
		
		if self.world:removeActiveObject(tx, ty) == false then
			local res = self.world:removeAnimationObject(tx, ty, "foreground")
			local res2 = self.world:removeAnimationObject(tx, ty, "background")
			
			if res == false and res2 == false then
				-- Finally remove the tile
				self.world:removeTile(tx, ty)
			end
		end
	end
end

-- Get tile coordinates from real coordinates
function Editor:tileCoords(x, y)
	return math.floor(x / self.world.tileWidth),
		math.floor(y / self.world.tileHeight)
end

-- Simple camera input control handler
-- Move in direction specified by pressed keys
function Editor:handleCameraConrol(deltaTime)
	local dirX = 0
	local dirY = 0
	
	if love.keyboard.isDown("a") then
		dirX = dirX - 1
	end
	if love.keyboard.isDown("d") then
		dirX = dirX + 1
	end
	if love.keyboard.isDown("w") then
		dirY = dirY - 1
	end
	if love.keyboard.isDown("s") then
		dirY = dirY + 1
	end
	
	self.world.camera:move(dirX, dirY, 300 * deltaTime)
end

function Editor:handleKeyPress(key)
	if self.gui:keyPress(key) then
		-- continue
	elseif key == "1" then
		self.gridVisible = not self.gridVisible
	elseif key == "f5" then
		self:quickSave()
	elseif key == "f6" then
		self:quickLoad()
	else
		-- Key wasn't processed
		return false
	end
	
	-- Key was processed
	return true
end

function Editor:isGuiActive()
	return self.console.isActive or love.keyboard.isDown("tab")
end

function Editor:handleTextInput(text)
	if self:isGuiActive() then
		self.gui:textInput(text)
	end
end

function Editor:handleKeysStillPressed(deltaTime)
	if self.console.isActive == false then
		self:handleCameraConrol(deltaTime)
	end
end

function Editor:handleMouseClick(x, y)
	if self:isGuiActive() then
		self.gui:mouseClick(x, y)
	elseif self:isInsertModeActive() then
		self:insertPick(x, y)
	elseif self.actionMode == "remove" then
		self:removeObj()
	end
end

function Editor:handleMouseRelease(x, y)
	if self:isGuiActive() then
		self.gui:mouseRelease(x, y)
	end
end

function Editor:handleMouseMove(x, y, dx, dy)
	if self:isGuiActive() then
		self.gui:mouseMove(x, y, dx, dy)
	end
end

function Editor:update(deltaTime)
	self:handleKeysStillPressed(deltaTime)
	
	local mx, my = getScaledMousePosition(self.world.camera, false)
	self.gui:update(deltaTime, mx, my)
	
	if self.console.contentReady then
		-- User has pressed an enter
		self:parseCommandFromConsole(self.console:getContent())
	end
	
	if self:shouldSelectNewPick() then
		self:selectNewPick()
	end
end

function Editor:isInsertModeActive()
	return self.actionMode == "insert" and self.activePick ~= nil
end

function Editor:drawActivePick()
	local pickW = self.activePick.data.width
	local pickH = self.activePick.data.height
	
	local mx, my = getScaledMousePosition(self.world.camera, true)
	
	-- Light up tiles
	self.world:lightUpTilesAtPosition(
		mx + pickW/2, my + pickH/2, pickW, pickH)
	
	-- Translate the mouse position back
	mx = mx - self.world.camera.x 
	my = my - self.world.camera.y
	
	love.graphics.translate(mx, my)
	
	self.activePick.draw()
	self.fonts.medium:drawLine(self.activePick.name, EditorPickSize, 0)
	
	love.graphics.translate(-mx, -my)
end

local EditorSkullSize = 30

-- "wrong thing can happen in you click the button" indicator
function Editor:drawSkullOnMousePosition()
	local mx, my = getScaledMousePosition(self.world.camera)
	
	love.graphics.translate(mx, my)
	
	drawTex(self.textureContainer:getTexture("skull"),
		0, 0, EditorSkullSize, EditorSkullSize)
		
	love.graphics.translate(-mx, -my)
end

function Editor:drawStats()
	local mx, my = getScaledMousePosition(self.world.camera, true)
	local tx, ty = self:tileCoords(mx, my)
	local font = self.fonts.medium
	
	love.graphics.setColor(255, 50, 50)
	
	font:drawLine("Tile position: " .. tx .. ", " .. ty, 10, 10)
	font:drawLine("ActionMode: " .. self.actionMode, 10, 30)
	font:drawLine("Insert dir: " .. self.insertDirection, 10, 50)
	font:drawLine("Tile type: " .. self.tileType, 10, 70)
	font:drawLine("AnimObj pos: " .. self.animObjPosition, 10, 90)
	
	love.graphics.setColor(255, 255, 255)
end

function Editor:drawGuiMode()
	self.gui:draw(self.world.camera)
end

function Editor:drawWorkMode()
	-- Grid border lines
	if self.gridVisible then
		self.world:drawGridLines()
	end
	
	if self:isInsertModeActive() then
		self:drawActivePick()
	elseif self.actionMode == "remove" then
		self:drawSkullOnMousePosition()
	end
	
	self:drawStats()
end

function Editor:draw()
	self.world:draw()
	self.world:drawPlayersSpawnPosition()
	self.world:drawPlayersFinishLine()
	self.world:drawRectangleAroundUnits()
	self.world:drawRectangleAroundObjs("animationObj")
	self.world:drawRectangleAroundObjs("activeObj")
	
	if self:isGuiActive() then
		self:drawGuiMode()
	else
		self:drawWorkMode()
	end
end