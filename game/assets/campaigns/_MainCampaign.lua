require "assets/anim_scenes/_CampaignIntro"
require "assets/anim_scenes/_CampaignOutro"

function _MainCampaign(campaign)
	campaign:loadSaveFile("_MainCampaign")
	campaign:addScene(_CampaignIntro, "intro")
	--campaign:addLevel(_MainCampaignLevel1)
	campaign:addScene(_CampaignOutro, "outro")
end