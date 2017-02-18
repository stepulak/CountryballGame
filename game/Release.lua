-- Important constants for current release
TITLE = love.window.getTitle()
GAME_VERSION = "0.1dev"
IS_MOBILE_RELEASE = love.system.getOS() == "Android"
SAVE_DIR = "save/"
MIN_FPS = 1/15