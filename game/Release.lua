-- Important constants for current release
TITLE = love.window.getTitle()
GAME_VERSION = "0.1dev"
IS_OFFICIAL_RELEASE = false
MOBILE_VERSION = love.system.getOS() == "Android" or love.system.getOS() == "iOS"
SAVE_DIR = "save/"
MIN_FPS = 1/15