require "SoundContainer"

-- Load all in-game sounds into SoundContainer
function loadSounds()
	local soundContainer = SoundContainer:new()
	
	soundContainer:loadEffect("player_jump", "assets/csound/fart.mp3")
	soundContainer:loadEffect("player_shoot", "assets/csound/belch.wav")
	-- TODO player_drop_helmet, player_death
	soundContainer:loadEffect("splash", "assets/csound/splash.mp3")
	soundContainer:loadEffect("canon_shot", "assets/csound/canon_shot.ogg")
	soundContainer:loadEffect("freeze", "assets/csound/freeze.mp3")
	soundContainer:loadEffect("boost_pick", "assets/csound/boost_pick.mp3")
	soundContainer:loadEffect("boost_spawn", "assets/csound/boost_spawn.mp3")
	soundContainer:loadEffect("coin_pick", "assets/csound/coin_pick.wav")
	soundContainer:loadEffect("block_bounce", "assets/csound/block_bounce.mp3")
	soundContainer:loadEffect("block_break", "assets/csound/block_break.mp3")
	soundContainer:loadEffect("smash", "assets/csound/smash.mp3")
	soundContainer:loadEffect("smash2", "assets/csound/smash_duck.mp3")
	soundContainer:loadEffect("explosion", "assets/csound/explosion.mp3")
	
	soundContainer:loadEffect("canonball_smash", 
		"assets/csound/canonball_smash.mp3")
	
	return soundContainer
end