# CountryballGame
2D sidescroller platform game similar to original Super Mario series. The whole engine and game is written in Lua using Love2D framework.

There are two versions of this game, one for desktop and the other for mobile phones (Android).

TODO: link to Android version

There is a main campaign available, entirely made via in-game editor. The campaign consists of animation scenes and separate playable levels.
It's about Polandball's adventure to his imaginary world, where, after he finishes the campaign's levels, he became an astronaut.

The game editor can be launched via menu button (desktop version only). It's controlled via mouse, keyboard shortcuts and console commands.

I believe that mouse control/editor's gui options are pretty straightforward, I just need to explain shortcuts and commands a little bit... 

# Editor's keyboard shorcuts:

	'~' - Editor mode/gameplay mode switch (unavailable in mobile version or when campaign is on)
	
	tab - Show objects grid and available options
	
	't' - Enable console
	
	'1' - Show on/off grid
	
	escape - Disable console
	
	F5 - Quicksave (may overwrite old quicksavefile!)
	
	F6 - Quickload (if exists)
	
	WASD - Camera control 
	
# Global shorcuts:
	
	F1 - Quit the program immediately
	
	F12 - Take a screenshot (saved in love.filesystem.getSaveDirectory())
	
# Console commands:
	
	"camera_velocity" or "cv":
		format: camera_velocity @backgroundLvl @movementDirection @velocity
			@backgroundLvl - level of parallax background (1-4)
			@movementDirection - "horizontal" (X axis), "vertical" (Y axis)
			@velocity - velocity quotient according to real camera's speed (0-1)
	
	"background_texture" or "bt":
		format: background_texture @backgroundLvl @textureName
			@backgroundLvl - level of parallax background (1-4)
			@textureName - name (id) of loaded texture (see TexturesLoad.lua)
	
	"background_color" or "bc":
		format: background_color @backgroundLvl @r @g @b @a
			@backgroundLvl - level of parallax background (1-4)
			@r, @g, @b, @a - RGBA values (0-255)
	
	"clouds" or "c":
		format: 1) clouds enable @backgroundLvl @bigClouds @numCloudsMax
		format: 2) clouds disable @backgroundLvl
			@backgroundLvl - level of parallax background (1-4)
			@bigClouds - true for spawning big clouds, false otherwise
			@numCloudsMax - maximum number of spawned clouds
			
			Note that you can enable clouds in multiple background layers
	
	"snow" or "s" | "rain" or "r":
		format: 1) snow/rain enable @backgroundLvl @heavyWeather
		format: 2) snow/rain disable @backgroundLvl
			@backgroundLvl - level of parallax background (1-4)
			@heavyWeather - true for heavy snow/rain, false otherwise
			
			Note that you can enable snow/rain in multiple background layers
			
	"spawn_pos" or "sp": (player's spawn position)
		format: 1) spawn_pos default
		format: 2) spawn_pos @tileX @tileY
			@tileX - tile X position (0-world's width)
			@tileY - tile Y position (0-world's height)
	
	"connect_teleports" or "ct":
		format: connect_teleports @tel1X @tel1Y @tel2X @tel2Y
			@tel1X - X position of teleport 1
			@tel1Y - Y position of teleport 1
			@tel2X - X position of teleport 2
			@tel2Y - Y position of teleport 2
			
	"finish_line" or "fl":
		format: 1) finish_line default
		format: 2) finish_line @tileX
			@tileX - X position of finish line
			
			No need for Y position, because the finish line goes vertically through whole map
	
	"save":
		format: save @filename
			@filename - name of the save filename (should end with .lua suffix!)
		
		The savefile can be found somewhere in love.filesystem.getSaveDirectory() + "\save\" folder
		
	"load":
		format: load @filename
			@filename - name of the load filename (add .lua suffix to load lua files!)
		
		The file has to be located somewhere in love.filesystem.getSaveDirectory() + "\save\" folder

	"set_music" or "sm":
		format: set_music @musicName
			@musicName - name (id) of loaded music (not effect!) - see SoundsLoad.lua
		
	"new_world" or "nw":
		format: new_world @numTilesWidth @numTilesHeight
			@numTilesWidth - number of tiles per width
			@numTilesHeight - number of tiles per height
	
	"fill_tiles" or "ft":
		format: fill_tiles @tilePosition @tileHeader @fromX @fromY @toX @toY
			@tilePosition - "collidable", "background", "water"
			@tileHeader - name of the tile's header to place
			@fromX - X position of start
			@fromY - Y position of start
			@toX - X position of end (including)
			@toY - Y position of end (including)

Beware of bad input formats! Each command should be foolproof (either nothing happens or error message appears), but keep in mind unexpected behaviour of the program...
I really recommend you to save your map often, so you can undo your operations if unpleasant things occurs...


The source code and most of the graphics are product of mine. I've also used various sound effects and music from other autors.
I recommend you to look at the in-game credits. If you find something that is against the licensing etc., please contact me as soon as possible and I will try to repair them.
You can redistribute this game, source code, graphics etc., according to it's license.