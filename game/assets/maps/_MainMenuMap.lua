function _MainMenuWorldLoad(...)

-- Automatically generated world load file
-- Can be edited manually

local world = ...
world:createEmptyWorld(20, 12)

-- Grid begin
world.tileWidth = 60
world.tileHeight = 60
local h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wood_oblique_left")
world.tiles[0][5] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[0][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[0][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wood_oblique_left")
world.tiles[1][4] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wooden_background")
world.tiles[1][5] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wood")
world.tiles[1][6] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wood")
world.tiles[1][7] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wood")
world.tiles[1][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wood")
world.tiles[1][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[1][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[1][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wood_oblique_left")
world.tiles[2][3] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wooden_background")
world.tiles[2][4] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wooden_background")
world.tiles[2][5] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wooden_platform")
world.tiles[2][7] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[2][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[2][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wood_oblique_left")
world.tiles[3][2] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wooden_background")
world.tiles[3][3] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wooden_background")
world.tiles[3][4] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wooden_background")
world.tiles[3][5] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wooden_platform")
world.tiles[3][7] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[3][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[3][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wood_oblique_right")
world.tiles[4][2] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wooden_background")
world.tiles[4][3] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wooden_background")
world.tiles[4][4] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wooden_background")
world.tiles[4][5] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wooden_platform")
world.tiles[4][7] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[4][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[4][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("brick_dark")
world.tiles[5][2] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("brick_dark")
world.tiles[5][3] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wooden_background")
world.tiles[5][4] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wooden_background")
world.tiles[5][5] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wooden_platform")
world.tiles[5][7] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[5][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[5][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wood_oblique_right")
world.tiles[6][4] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wooden_background")
world.tiles[6][5] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wood")
world.tiles[6][6] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wood")
world.tiles[6][7] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[6][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[6][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("wood_oblique_right")
world.tiles[7][5] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[7][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[7][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[8][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[8][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[9][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[9][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[10][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[10][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[11][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[11][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_bright")
world.tiles[12][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_bright")
world.tiles[12][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[12][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[12][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_top")
world.tiles[13][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[13][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[13][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[13][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_top")
world.tiles[14][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[14][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[14][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[14][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_top")
world.tiles[15][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[15][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[15][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[15][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_top")
world.tiles[16][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[16][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[16][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[16][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_top")
world.tiles[17][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[17][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[17][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[17][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_top")
world.tiles[18][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[18][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[18][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[18][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_bright")
world.tiles[19][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_bright")
world.tiles[19][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[19][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("static_block_dark")
world.tiles[19][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
-- Grid end

-- Animation objects begin
world:fillObjectIntoGrid(createAnimationObjectFromName("torch", 2, 8, world.tileWidth,  world.tileHeight, world.textureContainer, world.animObjContainer), "backgroundObj")
world:fillObjectIntoGrid(createAnimationObjectFromName("torch", 5, 8, world.tileWidth,  world.tileHeight, world.textureContainer, world.animObjContainer), "backgroundObj")
world:fillObjectIntoGrid(createAnimationObjectFromName("tree_light_1_3", 8, 7, world.tileWidth,  world.tileHeight, world.textureContainer, world.animObjContainer), "foregroundObj")
world:fillObjectIntoGrid(createAnimationObjectFromName("grass_1_1", 9, 9, world.tileWidth,  world.tileHeight, world.textureContainer, world.animObjContainer), "foregroundObj")
world:fillObjectIntoGrid(createAnimationObjectFromName("tree_light_1_3", 10, 7, world.tileWidth,  world.tileHeight, world.textureContainer, world.animObjContainer), "backgroundObj")
world:fillObjectIntoGrid(createAnimationObjectFromName("grass_1_1", 11, 9, world.tileWidth,  world.tileHeight, world.textureContainer, world.animObjContainer), "foregroundObj")
-- Animation objects end

-- Active objects begin
local acObj
acObj = createActiveObjectFromName("trampoline", 12, 7, world.tileWidth, world.tileHeight, world.textureContainer, false, nil)
world:addActiveObject(acObj)
acObj = createActiveObjectFromName("teleport", 4, 9, world.tileWidth, world.tileHeight, world.textureContainer, false, nil)
world:addActiveObject(acObj)
acObj = createActiveObjectFromName("teleport", 3, 9, world.tileWidth, world.tileHeight, world.textureContainer, false, nil)
world:addActiveObject(acObj)
acObj = createActiveObjectFromName("horizontal_platform_start", 12, 5, world.tileWidth, world.tileHeight, world.textureContainer, false, nil)
world:addActiveObject(acObj)
acObj = createActiveObjectFromName("smoke_source", 5, 1, world.tileWidth, world.tileHeight, world.textureContainer, false, nil)
world:addActiveObject(acObj)
-- Active objects end

-- Units begin
local unit
unit = createUnitFromName("fish", 1098.792889118, 538.93965195289, world.tileWidth, world.tileHeight, world.textureContainer, true)
world:addUnit(unit)
unit = createUnitFromName("fireflower", 147, 393, world.tileWidth, world.tileHeight, world.textureContainer, true)
world:addUnit(unit)
unit = createUnitFromName("fireflower", 327, 393, world.tileWidth, world.tileHeight, world.textureContainer, true)
world:addUnit(unit)
unit = createUnitFromName("iceflower", 207, 393, world.tileWidth, world.tileHeight, world.textureContainer, true)
world:addUnit(unit)
unit = createUnitFromName("iceflower", 267, 393, world.tileWidth, world.tileHeight, world.textureContainer, true)
world:addUnit(unit)
-- Units end

-- Parallax background begin
-- Background begin: 1
world:enableWeather(1, "Clouds", nil, 10)
world:setCameraVelocityParallaxBackground(1, 0)
-- Background end
-- Background begin: 2
world:setCameraVelocityParallaxBackground(2, 0)
-- Background end
-- Background begin: 3
world:setCameraVelocityParallaxBackground(3, 0)
-- Background end
-- Background begin: 4
world:setCameraVelocityParallaxBackground(4, 0)
-- Background end
-- Parallax background end

-- Player spawn position begin
world.playerSpawnX = 390
world.playerSpawnY = 570
-- Player spawn position end

-- Player finish line begin
world.playerFinishLine = 1050
-- Player finish line end

end