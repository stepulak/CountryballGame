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
	soundContainer:loadEffect("booster_pick", "assets/csound/booster_pick.mp3")
	soundContainer:loadEffect("booster_spawn", "assets/csound/booster_spawn.mp3")
	soundContainer:loadEffect("coin_pick", "assets/csound/coin_pick.wav")
	
	soundContainer:loadEffect("canonball_smash", 
		"assets/csound/canonball_smash.mp3")
	
	return soundContainer
end