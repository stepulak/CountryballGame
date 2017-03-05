
function _CampaignOutro(scene, tc)
	scene:setBackgroundColor({ r = 255, g = 255, b = 255 })
	scene:setSlideLastTime(10)
	
	local imgQ = 1.2
	local imgW, imgH = scene.virtScrWidth * imgQ, scene.virtScrHeight * imgQ
	
	scene:addTextureSlide(tc:getTexture("o1"), imgW, imgH, "vertical", "fade_in_out")
	scene:addTextureSlide(tc:getTexture("o2"), imgW, imgH, "horizontal", "fade_in_out")
	scene:addTextureSlide(tc:getTexture("o3"), scene.virtScrWidth, scene.virtScrHeight, "static", "fade_in_out")
	
	scene:addTextureSlide(tc:getTexture("i12"), 1000, 1000, "zoom_out", "fade_in_out",
		{backgroundColor = {r=0, g=0, b=0}, zoomVel = 0.35})
		
	imgQ = 0.7
	imgW, imgH = scene.virtScrWidth * imgQ, scene.virtScrHeight * imgQ
	
	scene:addTextureSlide(tc:getTexture("o4"), imgW, imgH, "static", "fade_in_out")
	scene:addTextureSlide(tc:getTexture("o5"), imgW, imgH, "static", "fade_in_out")
	
	scene:addTextureSlide(tc:getTexture("o6"), nil, nil, "static", "fade_in_wait")
	
	-- TODO music
end