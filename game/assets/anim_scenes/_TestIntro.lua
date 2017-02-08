-- Testing intro
function _TestIntro(scene, textureContainer)
	
	scene:addTextureSlide(
		textureContainer:getTexture("background1_night"),
		1600, 900, "horizontal", "fade_in_wait")
	
	scene:addBackgroundMusic("credits")
	--scene:setBackgroundColor({r=255, g=0,b=0})
end