
function _MainCampaignLevel1Outro(scene, textureContainer)
	scene:addSlide(
		textureContainer:getTexture("background1_night"),
		700, 700, "zoom_out", "fade_in_wait", { lastTime = 10 })
end