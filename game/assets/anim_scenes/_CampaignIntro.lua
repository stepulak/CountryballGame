
function _CampaignIntro(scene, tc)
	scene:setBackgroundColor({ r = 255, g = 255, b = 255 })
	scene:addBackgroundMusic("intro_outro")
	
	local imgQ = 0.7
	local imgW, imgH = scene.virtScrWidth * imgQ, scene.virtScrHeight * imgQ
	
	scene:addTextureSlide(tc:getTexture("i1"), nil, nil, "static", "fade_in_out")
	scene:addTextureSlide(tc:getTexture("i2"), imgW, imgH, "horizontal", "fade_in_out")
	scene:addTextureSlide(tc:getTexture("i3"), nil, nil, "static", "fade_in_out")
	scene:addTextureSlide(tc:getTexture("i4"), imgW, imgh, "vertical", "fade_in_out")
	scene:addTextureSlide(tc:getTexture("i5"), nil, nil, "static", "fade_in_out")
	scene:addTextureSlide(tc:getTexture("i6"), imgW, imgh, "diagonal", "fade_in_out")
	scene:addTextureSlide(tc:getTexture("i7"), nil, nil, "static", "fade_in_out")
	
	for i=8, 11 do
		scene:addTextureSlide(tc:getTexture("i" .. i), imgW, imgH, "static", "fade_in_out")
	end
	
	scene:addTextureSlide(tc:getTexture("i12"), nil, nil, "zoom_in", "fade_in_out",
		{backgroundColor = {r=0, g=0, b=0}, zoomVel = 0.35})
	
	-- TODO music
end