
-- Automatically generated world load file
-- Can be edited manually

function _MainMenuWorldLoad(...)

local world = ...
world:createEmptyWorld(20, 12)

-- Grid begin
world.tileWidth = 60
world.tileHeight = 60
local h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("grass_top")
world.tiles[0][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[0][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[0][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("grass_top")
world.tiles[1][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[1][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[1][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("grass_top")
world.tiles[2][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[2][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[2][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h2 = world.headerContainer:getHeader("timber")
world.tiles[3][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("grass_top")
world.tiles[3][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[3][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[3][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("grass_top")
world.tiles[4][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[4][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[4][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("grass_top")
world.tiles[5][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[5][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[5][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("surprise_mushroom_grow")
world.tiles[4][6] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("grass_top")
world.tiles[6][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[6][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[6][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("surprise_mushroom_grow")
world.tiles[5][6] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("grass_top")
world.tiles[7][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[7][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[7][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("surprise_mushroom_grow")
world.tiles[6][6] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("grass_top")
world.tiles[8][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[8][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[8][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("grass_top")
world.tiles[9][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[9][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[9][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("grass_oblique_left")
world.tiles[10][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("grass_top_left")
world.tiles[10][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[10][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[10][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("grass_oblique_left")
world.tiles[11][7] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[11][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[11][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[11][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[11][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_top")
world.tiles[12][7] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[12][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[12][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[12][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[12][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_top")
world.tiles[13][7] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[13][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[13][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[13][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[13][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_top")
world.tiles[14][7] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[14][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[14][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[14][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[14][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_top")
world.tiles[15][7] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[15][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[15][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[15][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[15][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_top")
world.tiles[16][7] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[16][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[16][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[16][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[16][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_top")
world.tiles[17][7] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[17][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[17][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[17][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[17][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_top")
world.tiles[18][7] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[18][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h3 = world.headerContainer:getHeader("water_inside")
world.tiles[18][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[18][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[18][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("grass_oblique_right")
world.tiles[19][7] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[19][8] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[19][9] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[19][10] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
h1 = world.headerContainer:getHeader("mud_mid")
world.tiles[19][11] = Tile:new(h1, h2, h3)
h1, h2, h3 = nil, nil, nil
-- Grid end

-- Animation objects begin
world:fillObjectIntoGrid(createAnimationObjectFromName("tree_3", 0, 5, world.tileWidth,  world.tileHeight, world.textureContainer, world.animObjContainer), "backgroundObj")
world:fillObjectIntoGrid(createAnimationObjectFromName("fire", 3, 8, world.tileWidth,  world.tileHeight, world.textureContainer, world.animObjContainer), "backgroundObj")
world:fillObjectIntoGrid(createAnimationObjectFromName("tree_3", 4, 5, world.tileWidth,  world.tileHeight, world.textureContainer, world.animObjContainer), "backgroundObj")
world:fillObjectIntoGrid(createAnimationObjectFromName("tree_3", 8, 5, world.tileWidth,  world.tileHeight, world.textureContainer, world.animObjContainer), "backgroundObj")
world:fillObjectIntoGrid(createAnimationObjectFromName("rock", 12, 9, world.tileWidth,  world.tileHeight, world.textureContainer, world.animObjContainer), "backgroundObj")
world:fillObjectIntoGrid(createAnimationObjectFromName("water_grass", 13, 9, world.tileWidth,  world.tileHeight, world.textureContainer, world.animObjContainer), "foregroundObj")
world:fillObjectIntoGrid(createAnimationObjectFromName("water_grass", 15, 9, world.tileWidth,  world.tileHeight, world.textureContainer, world.animObjContainer), "backgroundObj")
world:fillObjectIntoGrid(createAnimationObjectFromName("water_grass", 17, 9, world.tileWidth,  world.tileHeight, world.textureContainer, world.animObjContainer), "foregroundObj")
-- Animation objects end

-- Active objects begin
local acObj
acObj = createActiveObjectFromName("smoke_source", 3, 7, world.tileWidth, world.tileHeight, world.textureContainer, false, nil)
world:addActiveObject(acObj)
-- Active objects end

-- Units begin
local unit
unit = createUnitFromName("coin", 927, 327, world.tileWidth, world.tileHeight, world.textureContainer, false)
world:addUnit(unit)
unit = createUnitFromName("fish", 968.53803636646, 493.38995059472, world.tileWidth, world.tileHeight, world.textureContainer, false)
world:addUnit(unit)
unit = createUnitFromName("jumper", 350, 174.77452055963, world.tileWidth, world.tileHeight, world.textureContainer, true)
world:addUnit(unit)
-- Units end

-- Parallax background begin
-- Background begin: 1
world:setBackgroundTexture(1, "bg_blue")
world:enableWeather(1, "Clouds", nil, 20)
world:setCameraVelocityParallaxBackground(1, "vertical", 0)
world:setCameraVelocityParallaxBackground(1, "horizontal", 0)
-- Background end
-- Background begin: 2
world:setCameraVelocityParallaxBackground(2, "vertical", 0)
world:setCameraVelocityParallaxBackground(2, "horizontal", 0)
-- Background end
-- Background begin: 3
world:setCameraVelocityParallaxBackground(3, "vertical", 0)
world:setCameraVelocityParallaxBackground(3, "horizontal", 0)
-- Background end
-- Background begin: 4
world:setCameraVelocityParallaxBackground(4, "vertical", 0)
world:setCameraVelocityParallaxBackground(4, "horizontal", 0)
-- Background end
-- Parallax background end

-- Player spawn position begin
world.playerSpawnX = 90
world.playerSpawnY = 510
-- Player spawn position end

-- Player finish line begin
world.playerFinishLine = 1170
-- Player finish line end

-- Background music begin
-- Background music end

end