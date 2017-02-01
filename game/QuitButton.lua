require "TexturedButton"

local AskTimeCountdown = 3
local Label = "QUIT"
local LabelAsk = "u sure?"

-- Quit button which is placed in the top-middle position
-- Possible usage: only on mobile phones with no "escape" button
QuitButton = TexturedButton:new()

function QuitButton:init(font, virtScrWidth, width, height,
	texIdle, texClick, action)
	
	self:texturedButtonSuper(Label, font, virtScrWidth/2 - width/2, 0,
		width, height, texIdle, texClick, action)
		
	self.timer = 0
	self.clicked = false
	self.action = action
end

function QuitButton:mouseClick(x, y)
	if self.clicked == false then
		self.label = LabelAsk
		self.clicked = true
		self.timer = AskTimeCountdown
	else
		self.action()
	end
end

function QuitButton:mouseRelease(x, y)
end

function QuitButton:mouseReleaseNotInside(x, y)
end

function QuitButton:update(deltaTime)
	if self.clicked then
		self.timer = self.timer - deltaTime
		
		if self.timer <= 0 then
			self.clicked = false
			self.label = Label
		end
	end
end