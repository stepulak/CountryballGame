require "TextureContainer"

-- FYI I do not stick with 80 characters columns here...

-- Load all game's textures into container
function loadTextures()
	local textureContainer = TextureContainer:new()
	--
	-- NEW PACK
	--
	
	-- SNOW PACK
	textureContainer:newAnimationWithOneTexture("snow", "assets/textures/snow.png")
	textureContainer:newAnimationWithOneTexture("snow_top", "assets/textures/snow_top.png")
	textureContainer:newAnimationWithOneTexture("snow_mid", "assets/textures/snow_mid.png")
	textureContainer:newAnimationWithOneTexture("snow_bot", "assets/textures/snow_bot.png")
	textureContainer:newAnimationWithOneTexture("snow_mid_left", "assets/textures/snow_mid_left.png")
	textureContainer:newAnimationWithOneTexture("snow_block", "assets/textures/snow_block.png")
	textureContainer:newAnimationWithOneTexture("snow_brick", "assets/textures/snow_brick.png")
	textureContainer:newAnimationWithOneTexture("snow_oblique_left", "assets/textures/snow_oblique_left.png")
	textureContainer:newAnimationWithOneTexture("icicle", "assets/textures/icicle.png")
	textureContainer:newAnimationWithOneTexture("snow_funny_left", "assets/textures/snow_funny_left.png")
	textureContainer:newAnimationWithOneTexture("snow_funny_mid", "assets/textures/snow_funny_mid.png")
	textureContainer:newAnimationWithOneTexture("snow_funny_right", "assets/textures/snow_funny_right.png")
	textureContainer:newAnimationWithOneTexture("snow_wood_oblique_left", "assets/textures/snow_wood_oblique_left.png")
	
	-- DAY PACK
	textureContainer:newAnimationWithOneTexture("block", "assets/textures/block.png")
	textureContainer:newAnimationWithOneTexture("brick", "assets/textures/brick.png")
	textureContainer:newAnimationWithOneTexture("brick_wall", "assets/textures/brick_wall.png")
	textureContainer:newAnimationWithOneTexture("brick_oblique_left", "assets/textures/brick_oblique_left.png")
	textureContainer:newAnimationWithOneTexture("block", "assets/textures/block.png")
	textureContainer:newAnimationWithOneTexture("grass_top", "assets/textures/grass_top.png")
	textureContainer:newAnimationWithOneTexture("grass_top_left", "assets/textures/grass_top_left.png")
	textureContainer:newAnimationWithOneTexture("grass_oblique_left", "assets/textures/grass_oblique_left.png")
	textureContainer:newAnimationWithOneTexture("mud_mid", "assets/textures/mud_mid.png")
	textureContainer:newAnimationWithOneTexture("mud_bot", "assets/textures/mud_bot.png")
	textureContainer:newAnimationWithOneTexture("grass_funny_left", "assets/textures/grass_funny_left.png")
	textureContainer:newAnimationWithOneTexture("grass_funny_mid", "assets/textures/grass_funny_mid.png")
	textureContainer:newAnimationWithOneTexture("grass_funny_right", "assets/textures/grass_funny_right.png")
	
	-- ADDITIONAL TILES
	textureContainer:newAnimationWithOneTexture("wood", "assets/textures/wood.png")
	textureContainer:newAnimationWithOneTexture("wood_hor_mid", "assets/textures/wood_hor_mid.png")
	textureContainer:newAnimationWithOneTexture("wood_left", "assets/textures/wood_left.png")
	textureContainer:newAnimationWithOneTexture("wood_right", "assets/textures/wood_right.png")
	textureContainer:newAnimationWithOneTexture("wood_oblique_left", "assets/textures/wood_oblique_left.png")
	
	textureContainer:newAnimationWithOneTexture("wall", "assets/textures/wall.png")
	textureContainer:newAnimationWithOneTexture("wall_oblique_left", "assets/textures/wall_oblique_left.png")
	textureContainer:newAnimationWithOneTexture("fence", "assets/textures/fence.png")
	textureContainer:newAnimationWithOneTexture("tube", "assets/textures/tube.png")
	
	textureContainer:newAnimation("surprise_anim", 0.1,
		"assets/textures/surprise1.png",
		"assets/textures/surprise2.png",
		"assets/textures/surprise3.png",
		"assets/textures/surprise4.png")
		
	textureContainer:newTexture("surprise_idle", "assets/textures/surprise5.png")
	
	local surpriseAnim = textureContainer:getAnimation("surprise_anim"):deepCopy()
	local surpriseIdle = textureContainer:getTexture("surprise_idle")
	surpriseAnim:addTextureN(surpriseIdle, 10)
	
	textureContainer:addAnimation("surprise", surpriseAnim)

	textureContainer:newAnimationWithOneTexture("wooden_platform", "assets/textures/wooden_platform.png")
	textureContainer:newAnimationWithOneTexture("snow_platform", "assets/textures/snow_platform.png")
	textureContainer:newAnimationWithOneTexture("timber", "assets/textures/timber.png")
	
	-- WATER
	textureContainer:newAnimationWithOneTexture("water_inside", "assets/textures/water_inside.png")
	
	textureContainer:newAnimation("water_top", 0.3,
		"assets/textures/water_top1.png", 
		"assets/textures/water_top2.png")
	
	-- DEADLY TILES
	textureContainer:newAnimationWithOneTexture("lava_inside", "assets/textures/lava_mid.png")
	
	textureContainer:newAnimation("lava_top", 0.8,
		"assets/textures/lava_top1.png",
		"assets/textures/lava_top2.png")
		
	textureContainer:newAnimationWithOneTexture("spikes", "assets/textures/spikes.png")
	
	-- PLAYER
	textureContainer:newAnimationWithOneTexture("player_idle", "assets/textures/polandball_idle.png")
	textureContainer:newAnimationWithOneTexture("player_attacking", "assets/textures/polandball_attacking.png")
	textureContainer:newAnimationWithOneTexture("player_jumping", "assets/textures/polandball_jumping.png")
	
	textureContainer:newAnimation("player_walking", 0.15,
		"assets/textures/polandball_walking1.png", 
		"assets/textures/polandball_walking2.png",
		"assets/textures/polandball_walking3.png",
		"assets/textures/polandball_walking4.png",
		"assets/textures/polandball_walking5.png")
	
	textureContainer:newAnimation("player_swimming", 0.25,
		"assets/textures/polandball_swimming1.png", 
		"assets/textures/polandball_swimming2.png")
		
	textureContainer:newTexture("player_dead", "assets/textures/polandball_dead.png")
	textureContainer:newTexture("players_helmet", "assets/textures/helmet.png")
	
	-- PARTICLES
	textureContainer:newTexture("cloud1", "assets/textures/cloud1.png")
	textureContainer:newTexture("cloud2", "assets/textures/cloud2.png")
	textureContainer:newTexture("cloud3", "assets/textures/cloud3.png")
	textureContainer:newTexture("snowflake", "assets/textures/snowflake.png")
	textureContainer:newTexture("raindrop", "assets/textures/raindrop.png")
	textureContainer:newTexture("bubble", "assets/textures/bubble.png")
	textureContainer:newTexture("smoke", "assets/textures/smoke.png")
	textureContainer:newAnimation("fire", 0.15,
		"assets/textures/fire1.png",
		"assets/textures/fire2.png",
		"assets/textures/fire3.png",
		"assets/textures/fire4.png",
		"assets/textures/fire5.png")
	
	textureContainer:newAnimation("explosion", 0.05,
		"assets/textures/explosion1.png",
		"assets/textures/explosion2.png",
		"assets/textures/explosion3.png",
		"assets/textures/explosion4.png",
		"assets/textures/explosion5.png")
	
	
	textureContainer:newAnimation("fireworks", 0.1,
		"assets/textures/fireworks1.png",
		"assets/textures/fireworks2.png",
		"assets/textures/fireworks3.png",
		"assets/textures/fireworks4.png")
		
	-- PROJECTILES
	textureContainer:newAnimation("fireball", 0.2,
		"assets/textures/fireball1.png",
		"assets/textures/fireball2.png")
	
	textureContainer:newAnimation("iceball", 0.2,
		"assets/textures/iceball1.png",
		"assets/textures/iceball2.png")
	
	textureContainer:newAnimationWithOneTexture("hammer", "assets/textures/hammer.png")
	
	-- COIN
	textureContainer:newAnimation("coin_anim", 0.1,
		"assets/textures/coin1.png",
		"assets/textures/coin2.png",
		"assets/textures/coin3.png",
		"assets/textures/coin4.png")
	
	textureContainer:newTexture("coin_idle", "assets/textures/coin5.png")
	
	-- Do not load the texture more than once
	local coinAnim = textureContainer:getAnimation("coin_anim"):deepCopy()
	local coinIdle = textureContainer:getTexture("coin_idle")
	coinAnim:addTextureN(coinIdle, 10)
	
	textureContainer:addAnimation("coin", coinAnim)
	
	-- BOOST(ERS)
	textureContainer:newTexture("fireflower", "assets/textures/fireflower.png")
	textureContainer:newTexture("iceflower", "assets/textures/iceflower.png")
	textureContainer:newTexture("star", "assets/textures/star.png")
	textureContainer:newTexture("mushroom_grow", "assets/textures/mushroom_grow.png")
	textureContainer:newTexture("mushroom_life", "assets/textures/mushroom_life.png")
	
	-- UNITS
	textureContainer:newAnimation("zombie", 0.2,
		"assets/textures/zombie1.png", 
		"assets/textures/zombie2.png")
		
	textureContainer:newAnimation("turtle", 0.2,
		"assets/textures/turtle1.png",
		"assets/textures/turtle2.png",
		"assets/textures/turtle3.png")
	
	textureContainer:newTexture("turtle_shell", "assets/textures/turtle_shell.png")
	
	textureContainer:newAnimationWithOneTexture("rocket", "assets/textures/rocket.png")
	
	textureContainer:newAnimation("canonball", 0.25,
		"assets/textures/canonball1.png",
		"assets/textures/canonball2.png")
	
	textureContainer:newAnimation("fish", 0.3, 
		"assets/textures/fish1.png",
		"assets/textures/fish2.png")
		
	textureContainer:newAnimationWithOneTexture("jumper_bounce", "assets/textures/jumper_bounce.png")
	textureContainer:newAnimationWithOneTexture("jumper_air", "assets/textures/jumper_air.png")
	textureContainer:newAnimationWithOneTexture("bouncing_zombie", "assets/textures/bouncing_zombie.png")
	
	textureContainer:newAnimation("spiky_anim", 0.15,
		"assets/textures/spiky1.png",
		"assets/textures/spiky2.png",
		"assets/textures/spiky3.png",
		"assets/textures/spiky4.png")
	
	local spikyAnim = textureContainer:getAnimation("spiky_anim")
	local spikyAnimRev = spikyAnim:deepCopy():reverse()
	
	textureContainer:addAnimation("spiky", spikyAnim:deepCopy():concat(spikyAnimRev))
	
	textureContainer:newAnimation("flying_zombie", 0.1,
		"assets/textures/flying_zombie1.png",
		"assets/textures/flying_zombie2.png",
		"assets/textures/flying_zombie3.png",
		"assets/textures/flying_zombie4.png")
	
	textureContainer:newAnimation("bomberman_walking", 0.2,
		"assets/textures/bomberman_walking1.png",
		"assets/textures/bomberman_walking2.png",
		"assets/textures/bomberman_walking3.png")
	
	textureContainer:newAnimation("bomberman_countdown", 0.1,
		"assets/textures/bomberman_countdown1.png", 
		"assets/textures/bomberman_countdown2.png")
	
	textureContainer:newAnimation("rotating_ghost", 0.1,
		"assets/textures/rotating_ghost1.png",
		"assets/textures/rotating_ghost2.png")
	
	textureContainer:newAnimationWithOneTexture("hammerman_idle", "assets/textures/hammerman_idle.png")
	
	textureContainer:newAnimation("hammerman_attacking", 0.1,
		"assets/textures/hammerman_attacking1.png",
		"assets/textures/hammerman_attacking3.png",
		"assets/textures/hammerman_attacking2.png")
	
	-- ACTIVE OBJECTS
	textureContainer:newTexture("trampoline_platform", "assets/textures/trampoline_platform.png")
	textureContainer:newTexture("floating_platform", "assets/textures/floating_platform.png")
	
	textureContainer:newAnimation("canon_idle", 0.5,
		"assets/textures/canon_idle1.png",
		"assets/textures/canon_idle2.png")
	
	textureContainer:newAnimation("canon_shooting", 999,
		"assets/textures/canon_shooting1.png",
		"assets/textures/canon_shooting2.png",
		"assets/textures/canon_shooting3.png",
		"assets/textures/canon_shooting4.png",
		"assets/textures/canon_shooting5.png",
		"assets/textures/canon_shooting6.png")
	
	textureContainer:newAnimation("teleport", 0.05,
		"assets/textures/teleport1.png",
		"assets/textures/teleport2.png")
		
	-- ANIMATION OBJECTS
	textureContainer:newAnimationWithOneTexture("bush_1", "assets/textures/bush_1.png")
	textureContainer:newAnimationWithOneTexture("bush_2", "assets/textures/bush_2.png")
	textureContainer:newAnimationWithOneTexture("tree_1", "assets/textures/tree_1.png")
	textureContainer:newAnimationWithOneTexture("tree_2", "assets/textures/tree_2.png")
	textureContainer:newAnimationWithOneTexture("tree_3", "assets/textures/tree_3.png")
	textureContainer:newAnimationWithOneTexture("tree_4", "assets/textures/tree_4.png")
	textureContainer:newAnimationWithOneTexture("snowman", "assets/textures/snowman.png")
	textureContainer:newAnimationWithOneTexture("rock", "assets/textures/rock.png")
	textureContainer:newAnimationWithOneTexture("snow_rock", "assets/textures/snow_rock.png")
	textureContainer:newAnimationWithOneTexture("finish_line", "assets/textures/finish_line.png")
	
	textureContainer:newAnimation("streetlamp", 0.2,
		"assets/textures/streetlamp1.png",
		"assets/textures/streetlamp2.png")
	
	-- PARALLAX BACKGROUNDS
	textureContainer:newTexture("bg_snow", "assets/textures/bg_snow.png")
	textureContainer:newTexture("bg_snow2", "assets/textures/bg_snow2.png")
	textureContainer:newTexture("bg_snow3", "assets/textures/bg_snow3.png")
	textureContainer:newTexture("bg_blue", "assets/textures/bg_blue.png")
	textureContainer:newTexture("bg_light_blue", "assets/textures/bg_light_blue.png")
	textureContainer:newTexture("bg_mud", "assets/textures/bg_mud.png")
	textureContainer:newTexture("bg_forest", "assets/textures/bg_forest.png")
	
	-- OTHERS
	textureContainer:newTexture("game_logo", "assets/textures/game_logo.png")
	textureContainer:newTexture("button_idle", "assets/textures/button_idle.png")
	textureContainer:newTexture("button_click", "assets/textures/button_click.png")
	textureContainer:newTexture("skull", "assets/textures/skull.png")
	textureContainer:newTexture("frost", "assets/textures/frost.png")
	textureContainer:newTexture("gamepad_button", "assets/textures/gamepad_button.png")
	
	-- ANIMATION SCENES
	
	-- Campaign intro
	for i=1, 12 do
		textureContainer:newTexture("i" .. i, "assets/textures/anim_scenes/i" ..i .. ".png")
	end
	
	-- Capaign outro
	for i=1, 7 do
		textureContainer:newTexture("o" .. i, "assets/textures/anim_scenes/o" .. i .. ".png")
	end
	
	return textureContainer
end