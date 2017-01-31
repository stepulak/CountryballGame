require "TextureContainer"

-- Load all game's textures into container
function loadTextures()
	local textureContainer = TextureContainer:new()
	
	-- Player textures
	textureContainer:newAnimationWithOneTexture("player_idle",
		"assets/player_idle.png")
	
	textureContainer:newAnimation("player_walking", 0.15,
		"assets/player_walking1.png", "assets/player_walking2.png",
		"assets/player_walking3.png")
	
	textureContainer:newAnimationWithOneTexture("player_jumping",
		"assets/player_jumping.png")
	
	textureContainer:newAnimation("player_swimming", 0.25,
		"assets/player_swimming1.png", "assets/player_swimming2.png")
	
	textureContainer:newAnimationWithOneTexture("player_attacking", 
		"assets/player_attacking1.png")
	
	textureContainer:newTexture("player_dead", "assets/player_dead.png")
	textureContainer:newTexture("players_helmet", "assets/helmet.png")
	
	-- Units
	textureContainer:newAnimation("zombie", 0.2,
		"assets/zombie1.png", "assets/zombie2.png")
	
	textureContainer:newAnimation("canonball", 0.3,
		"assets/canonball1.png", "assets/canonball2.png")
	
	textureContainer:newAnimation("turtle", 0.2,
		"assets/turtle_walking1.png", "assets/turtle_walking2.png")
	
	textureContainer:newTexture("turtle_shell", "assets/turtle_shell.png")
	
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
	textureContainer:newTexture("star", "assets/star.png")
	textureContainer:newTexture("fireflower", "assets/fireflower.png")
	textureContainer:newTexture("iceflower", "assets/iceflower.png")
	
	-- Tile assets
	-- Snow
	textureContainer:newAnimationWithOneTexture("snow", "assets/snow.png")
	
	textureContainer:newAnimationWithOneTexture("snow_oblique_left", 
		"assets/snow_oblique_left.png")
		
	textureContainer:newAnimationWithOneTexture("snow_oblique_right", 
		"assets/snow_oblique_right.png")
	
	textureContainer:newAnimationWithOneTexture("brick_snow", 
		"assets/brick_snow.png")
	
	textureContainer:newAnimationWithOneTexture("static_block_snow",
		"assets/static_block_snow.png")
	
	-- Wood
	textureContainer:newAnimationWithOneTexture("wooden_platform", 
		"assets/wooden_platform.png")
	
	textureContainer:newAnimationWithOneTexture("wood", "assets/wood.png")
	
	textureContainer:newAnimationWithOneTexture("wood_oblique_left",
		"assets/wood_oblique_left.png")
	
	textureContainer:newAnimationWithOneTexture("wood_oblique_right",
		"assets/wood_oblique_right.png")
	
	textureContainer:newAnimationWithOneTexture("wooden_background",
		"assets/wooden_background.png")
		
	-- Day
	textureContainer:newAnimationWithOneTexture("brick_bright",
		"assets/brick_bright.png")
	
	textureContainer:newAnimationWithOneTexture("static_block_bright",
		"assets/static_block_bright.png")
		
	-- Night
	textureContainer:newAnimationWithOneTexture("brick_dark",
		"assets/brick_dark.png")
	
	textureContainer:newAnimationWithOneTexture("static_block_dark",
		"assets/static_block_dark.png")
	
	-- Water
	textureContainer:newAnimationWithOneTexture("water_inside",
		"assets/water_inside.png")
	
	textureContainer:newAnimation("water_top", 0.3,
		"assets/water_top1.png", "assets/water_top2.png")
	
	-- Deadly
	textureContainer:newAnimationWithOneTexture("lava_inside",
		"assets/lava_inside.png")
	
	textureContainer:newAnimation("lava_top", 0.3,
		"assets/lava_top1.png", "assets/lava_top2.png")
		
	textureContainer:newAnimationWithOneTexture("spikes", "assets/spikes.png")
	
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
	
	textureContainer:newAnimation("tree_anim_2_3", 1,
		"assets/tree_anim_2_3_1.png", "assets/tree_anim_2_3_2.png")
		
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
	textureContainer:newTexture("cloud", "assets/cloud.png")
	textureContainer:newTexture("snow_flake", "assets/snowflake.png")
	textureContainer:newTexture("rain_drop", "assets/raindrop.png")
	textureContainer:newTexture("bubble", "assets/bubble.png")
	textureContainer:newTexture("smoke", "assets/smoke.png")
	
	textureContainer:newAnimation("explosion", 0.1,
		"assets/explosion1.png", "assets/explosion2.png",
		"assets/explosion3.png")
		
	-- Coin
	textureContainer:newAnimation("coin", 0.3, "assets/coin1.png",
		"assets/coin2.png", "assets/coin3.png", "assets/coin2.png")
	
	-- Projectiles
	textureContainer:newAnimation("fireball", 0.2,
		"assets/fireball1.png", "assets/fireball2.png")
	
	textureContainer:newAnimation("iceball", 0.2,
		"assets/iceball1.png", "assets/iceball2.png")
	
	textureContainer:newAnimationWithOneTexture("hammer", "assets/hammer.png")
		
	-- Others
	textureContainer:newTexture("freezed_unit", "assets/freezed_unit.png")
	textureContainer:newTexture("skull", "assets/skull.png")
	textureContainer:newTexture("gamepad_button", "assets/gamepad_button.png")
	textureContainer:newTexture("game_logo", "assets/game_logo.png")
	
	return textureContainer
end