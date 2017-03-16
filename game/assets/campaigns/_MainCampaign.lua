require "assets/anim_scenes/_CampaignIntro"
require "assets/anim_scenes/_CampaignOutro"
require "assets/maps/lvl1"
require "assets/maps/lvl2"
require "assets/maps/lvl3"
require "assets/maps/lvl4"
require "assets/maps/lvl5"
require "assets/maps/lvl6"
require "assets/maps/lvl7"
require "assets/maps/lvl8"

function _MainCampaign(campaign)
	campaign:loadSaveFile("_MainCampaign")
	campaign:addScene(_CampaignIntro, "intro")
	campaign:addLevel(_lvl1)
	campaign:addLevel(_lvl2)
	campaign:addLevel(_lvl3)
	campaign:addLevel(_lvl4)
	campaign:addLevel(_lvl5)
	campaign:addLevel(_lvl6)
	campaign:addLevel(_lvl7)
	campaign:addLevel(_lvl8)
	campaign:addScene(_CampaignOutro, "outro")
end