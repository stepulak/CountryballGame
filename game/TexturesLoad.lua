require "TextureContainer"

-- FYI I do not stick with 80 characters columns here...

-- Load all game's textures into container
function loadTextures()
	local textureContainer = TextureContainer:new()
	
	textureContainer:newAnimation("canonball", 0.3,
		"assets/canonball1.png", "assets/canonball2.png")
	
	textureContainer:newAnimationWithOneTexture("jumper_idle",
		"assets/jumper_idle.png")
	
	textureContainer:newAnimationWithOneTexture("jumper_jumping",
		"assets/jumper_jumping.png")
	
	textureContainer:newAnimation("rotating_ghost", 0.1,
		"assets/rotating_ghost1.png", "assets/rotating_ghost2.png")
	
	textureContainer:newAnimation("flying_zombie", 0.3,
		"assets/flying_zombie1.png", "assets/flying_zombie2.png")
	
	textureContainer:newAnimationWithOneTexture("bouncing_zombie", 
		"assets/bouncing_zombie.png")
	
	textureContainer:newAnimation("spiky", 0.2,
		"assets/spiky_walking1.png", "assets/spiky_walking2.png",
		"assets/spiky_walking3.png")
	
	textureContainer:newAnimation("bomberman_walking", 0.2,
		"assets/bomberman_walking1.png", "assets/bomberman_walking2.png")
	
	textureContainer:newAnimation("bomberman_countdown", 0.05,
		"assets/bomberman_countdown1.png", "assets/bomberman_countdown2.png")
		
	textureContainer:newAnimationWithOneTexture("hammerman_idle",
		"assets/hammerman_idle.png")
	
	textureContainer:newAnimationWithOneTexture("hammerman_jumping",
		"assets/hammerman_jumping.png")
	
	textureContainer:newAnimationWithOneTexture("hammerman_attacking",
		"assets/hammerman_attacking.png")
	
	textureContainer:newAnimation("fish", 0.3, 
		"assets/fish1.png", "assets/fish2.png")
	
	textureContainer:newAnimationWithOneTexture("rocket", "assets/rocket.png")
	
	-- Boost (ers)
	textureContainer:newTexture("mushroom_grow", "assets/mushroom_grow.png")
	textureContainer:newTexture("mushroom_life", "assets/mushroom_life.png")
	
	-- Tile assets
	-- Snow
	textureContainer:newAnimationWithOneTexture("snow", "assets/snow.png")
	
	textureContainer:newAnimationWithOneTexture("brick_snow", 
		"assets/brick_snow.png")
	
	textureContainer:newAnimationWithOneTexture("static_block_snow",
		"assets/static_block_snow.png")
	
	-- Wood
	textureContainer:newAnimationWithOneTexture("wooden_platform", 
		"assets/wooden_platform.png")
	
	-- Animation objects
	textureContainer:newAnimation("grass_1_1", 0.3,
		"assets/grass_1_1_1.png", "assets/grass_1_1_2.png")
	
	textureContainer:newAnimationWithOneTexture("tree_light_1_3",
		"assets/tree_light_1_3.png")
	
	textureContainer:newAnimationWithOneTexture("tree_dark_1_3",
		"assets/tree_dark_1_3.png")
	
	textureContainer:newAnimationWithOneTexture("tree_light_1_2",
		"assets/tree_light_1_2.png")
	
	textureContainer:newAnimationWithOneTexture("tree_dark_1_2",
		"assets/tree_dark_1_2.png")
	
	textureContainer:newAnimationWithOneTexture("tree_naked_2_3",
		"assets/tree_naked_2_3.png")
		
	textureContainer:newAnimationWithOneTexture("snow_blanket",
		"assets/snow_blanket.png")
	
	textureContainer:newAnimation("torch", 0.1,
		"assets/torch1.png", "assets/torch2.png", "assets/torch3.png")
		
	-- Active objects
	textureContainer:newTexture("trampoline_platform",
		"assets/trampoline_platform.png")
	
	textureContainer:newAnimation("teleport", 0.05,
		"assets/teleport1.png", "assets/teleport2.png")
	
	textureContainer:newTexture("floating_platform",
		"assets/floating_platform.png")
		
	-- Canon's animation frame rate is modified for each canon table
	textureContainer:newAnimation("canon", 999,
		"assets/canon_idle.png", "assets/canon_shooting1.png",
		"assets/canon_shooting2.png")
		
	-- Parallax background
	textureContainer:newTexture("background1_day", "assets/background1_day.png")
	
	textureContainer:newTexture("background1_night", 
		"assets/background1_night.png")
	
	textureContainer:newTexture("background2_snow_mountains",
		"assets/background2_snow_mountains.png")
	
	textureContainer:newTexture("background2_spring_mountains",
		"assets/background2_spring_mountains.png")
		
	textureContainer:newTexture("background3_snow_mountains",
		"assets/background3_snow_mountains.png")
	
	textureContainer:newTexture("background3_spring_mountains",
		"assets/background3_spring_mountains.png")
	
	textureContainer:newTexture("background3_spring_forest",
		"assets/background3_spring_forest.png")
	
	-- Particles
	textureContainer:newAnimation("explosion", 0.1,
		"assets/explosion1.png", "assets/explosion2.png",
		"assets/explosion3.png")
	
	textureContainer:newAnimation("fireworks", 0.1,
		"assets/fireworks1.png", "assets/fireworks2.png",
		"assets/fireworks3.png", "assets/fireworks4.png")
	
	textureContainer:newAnimationWithOneTexture("hammer", "assets/hammer.png")
		
	-- Others
	textureContainer:newTexture("freezed_unit", "assets/freezed_unit.png")
	textureContainer:newTexture("skull", "assets/skull.png")
	textureContainer:newTexture("gamepad_button", "assets/gamepad_button.png")
	textureContainer:newTexture("game_logo", "assets/game_logo.png")
	textureContainer:newTexture("button_idle", "assets/button_idle.png")
	textureContainer:newTexture("button_click", "assets/button_click.png")
	
	--
	-- NEW PACK
	--
	
	-- SNOW PACK
	textureContainer:newAnimationWithOneTexture("snow", "assets/textures/snow.png")
	textureContainer:newAnimationWithOneTexture("snow_top", "assets/textures/snow_top.png")
	textureContainer:newAnimationWithOneTexture("snow_mid", "assets/textures/snow_mid.png")
	textureContainer:newAnimationWithOneTexture("snow_bot", "assets/textures/snow_bot.png")
	textureContainer:newAnimationWithOneTexture("snow_block", "assets/textures/snow_block.png")
	textureContainer:newAnimationWithOneTexture("snow_brick", "assets/textures/snow_brick.png")
	textureContainer:newAnimationWithOneTexture("snow_oblique_left", "assets/textures/snow_oblique_left.png")
	textureContainer:newAnimationWithOneTexture("snow_oblique_right", "assets/textures/snow_oblique_right.png")
	textureContainer:newAnimationWithOneTexture("icicle", "assets/textures/icicle.png")
	
	textureContainer:newAnimation("surprise", 1,
		"assets/textures/surprise1.png",
		"assets/textures/surprise2.png",
		"assets/textures/surprise3.png",
		"assets/textures/surprise4.png")
	
	-- DAY PACK
	textureContainer:newAnimationWithOneTexture("brick", "assets/textures/brick.png")
	textureContainer:newAnimationWithOneTexture("block", "assets/textures/block.png")
	
	-- WATER
	
	textureContainer:newAnimationWithOneTexture("water_inside", "assets/textures/water_inside.png")
	
	textureContainer:newAnimation("water_top", 0.3,
		"assets/textures/water_top1.png", 
		"assets/textures/water_top2.png")
		
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
	
	-- DEADLY TILES
	textureContainer:newAnimationWithOneTexture("spikes", "assets/textures/spikes.png")
	
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
	
	-- PROJECTILES
	textureContainer:newAnimation("fireball", 0.2,
		"assets/textures/fireball1.png",
		"assets/textures/fireball2.png")
	
	textureContainer:newAnimation("iceball", 0.2,
		"assets/textures/iceball1.png",
		"assets/textures/iceball2.png")
		
	-- COIN
	textureContainer:newAnimation("coin_anim", 0.05,
		"assets/textures/coin1.png",
		"assets/textures/coin2.png",
		"assets/textures/coin3.png",
		"assets/textures/coin4.png",
		"assets/textures/coin5.png")
	
	textureContainer:newTexture("coin_idle", "assets/textures/coin6.png")
	
	-- Do not load the texture more than once
	local coinAnim = textureContainer:getAnimation("coin_anim"):deepCopy()
	local coinIdle = textureContainer:getTexture("coin_idle")
	coinAnim:addTextureN(coinIdle, 10)
	
	textureContainer:addAnimation("coin", coinAnim)
	
	-- BOOST(ERS)
	textureContainer:newTexture("fireflower", "assets/textures/fireflower.png")
	textureContainer:newTexture("iceflower", "assets/textures/iceflower.png")
	textureContainer:newTexture("star", "assets/textures/star.png")
	
	
	-- UNITS
	textureContainer:newAnimation("zombie", 0.2,
		"assets/textures/zombie1.png", 
		"assets/textures/zombie2.png")
		
	textureContainer:newAnimation("turtle", 0.2,
		"assets/textures/turtle1.png",
		"assets/textures/turtle2.png",
		"assets/textures/turtle3.png")
	
	textureContainer:newTexture("turtle_shell", "assets/textures/turtle_shell.png")
	
	return textureContainer
end