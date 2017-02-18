require "assets/maps/_MainCampaignLevel1"
require "assets/anim_scenes/_MainCampaignLevel1Intro"
require "assets/anim_scenes/_MainCampaignLevel1Outro"

function _MainCampaign(campaign)
	campaign:loadSaveFile("_MainCampaign")
	campaign:addScene(_MainCampaignLevel1Intro, "intro")
	campaign:addLevel(_MainCampaignLevel1)
	campaign:addLevel(_MainCampaignLevel1)
	campaign:addScene(_MainCampaignLevel1Outro, "outro")
end