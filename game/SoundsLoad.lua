require "SoundContainer"

-- Load all in-game sounds into SoundContainer
function loadSounds(screen)
	local soundContainer = SoundContainer:new(screen.virtualWidth * 1.5)
	
	-- Player
	soundContainer:loadEffect("player_jump", "assets/csound/fart.mp3")
	soundContainer:loadEffect("player_shooting", "assets/csound/player_shooting.wav")
	
	soundContainer:loadEffect("player_drop_helmet", "assets/csound/player_death.wav")
		
	soundContainer:newEffect("player_death", soundContainer:getEffect("player_drop_helmet"))

	soundContainer:loadEffect("boost_pick", "assets/csound/boost_pick.mp3")
	soundContainer:loadEffect("boost_spawn", "assets/csound/boost_spawn.mp3")
	soundContainer:loadEffect("lifeup", "assets/csound/lifeup.wav")
	
	-- Mist
	soundContainer:loadEffect("rain", "assets/csound/forest_rain.mp3")
	soundContainer:loadEffect("splash", "assets/csound/splash.mp3")
	soundContainer:loadEffect("canon_shot", "assets/csound/canon_shot.ogg")
	soundContainer:loadEffect("firecracker", "assets/csound/firecracker.mp3")
	soundContainer:loadEffect("freeze", "assets/csound/freeze.mp3")
	soundContainer:loadEffect("coin_pick", "assets/csound/coin_pick.wav")
	soundContainer:loadEffect("fireworks", "assets/csound/fireworks.mp3")
	
	-- Block
	soundContainer:loadEffect("block_bounce", "assets/csound/block_bounce.mp3")
	soundContainer:loadEffect("block_break", "assets/csound/block_break.mp3")
	soundContainer:loadEffect("block_unable", "assets/csound/block_unable.wav")
	
	-- Unit
	soundContainer:loadEffect("smash", "assets/csound/smash.mp3")
	soundContainer:loadEffect("smash2", "assets/csound/smash_duck.mp3")
	soundContainer:loadEffect("explosion", "assets/csound/explosion.mp3")
	soundContainer:loadEffect("unit_death", "assets/csound/unit_death.wav")
	soundContainer:loadEffect("turtle_touch", "assets/csound/turtle_touch.wav")
	soundContainer:loadEffect("turtle_bump", "assets/csound/turtle_bump.wav")
	
	soundContainer:loadEffect("rocket_engine", "assets/csound/rocket_engine.mp3")
		
	soundContainer:loadEffect("canonball_smash", "assets/csound/canonball_smash.mp3")
	
	-- Music
	soundContainer:loadMusic("game_menu", "assets/cmusic/Game-Menu.mp3")
	soundContainer:loadMusic("credits", "assets/cmusic/Sculpture-Garden.mp3")
	soundContainer:loadMusic("star", "assets/cmusic/Dancing-on-Clouds.mp3")
	soundContainer:loadMusic("day", "assets/cmusic/Mountainside_Looping.mp3")
	soundContainer:loadMusic("night1", "assets/cmusic/Still-of-Night_Looping.mp3")
	soundContainer:loadMusic("winter1", "assets/cmusic/Foglands_Looping.mp3")
	soundContainer:loadMusic("winter2", "assets/cmusic/Unforgiving-Himalayas_Looping.mp3")
	soundContainer:loadMusic("intro_outro", "assets/cmusic/Pond-at-Twilight.mp3")
	soundContainer:loadMusic("cave", "assets/cmusic/Theyre-Closing-In_Looping.mp3")
	
	soundContainer:loadMusic("finish_fanfare", 
		"assets/cmusic/3 Open Surge score jingle - C.mp3")
	
	return soundContainer
end