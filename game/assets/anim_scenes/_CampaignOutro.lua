
function _CampaignOutro(scene, tc)
	scene:setBackgroundColor({ r = 255, g = 255, b = 255 })
	scene:setSlideLastTime(15)
	scene:addBackgroundMusic("outro")
	
	local opts = {lastTime=10}
	local imgQ = 1.2
	local imgW, imgH = scene.virtScrWidth * imgQ, scene.virtScrHeight * imgQ
	
	scene:addTextureSlide(tc:getTexture("o1"), imgW, imgH, "vertical", "fade_in_out")
	scene:addTextureSlide(tc:getTexture("o2"), imgW, imgH, "horizontal", "fade_in_out")
	scene:addTextureSlide(tc:getTexture("o3"), scene.virtScrWidth, scene.virtScrHeight, "static", "fade_in_out")
	scene:addTextureSlide(tc:getTexture("o4"), nil, nil, "static", "fade_in_out", opts)
		
	imgQ = 0.7
	imgW, imgH = scene.virtScrWidth * imgQ, scene.virtScrHeight * imgQ
	
	scene:addTextureSlide(tc:getTexture("o5"), imgW, imgH, "static", "fade_in_out", opts)
	scene:addTextureSlide(tc:getTexture("o6"), imgW, imgH, "static", "fade_in_out", opts)
	scene:addTextureSlide(tc:getTexture("o7"), nil, nil, "static", "fade_in_wait")
end