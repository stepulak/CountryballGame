require "TexturedButton"

local BackgroundColor = {
	r = 50,
	g = 50,
	b = 50,
	a = 100,
}

local DialogColor = {
	r = 100,
	g = 100,
	b = 100,
	a = 160,
}

-- Vertical/horizontal offset between elements
local VertOffsetElems = 40
local HorOffsetElems = 70
local ButtonWidth = 150
local ButtonHeight = 80
-- Minimal dialog "window" width
local MinWidth = ButtonWidth * 2 + HorOffsetElems * 3

YesNoDialog = GuiElement:new()

function YesNoDialog:init(label, font,
	virtScrWidth, virtScrHeight,
	butTexIdle, butTexClicked,
	yesAction, noAction)
	
	local labelW = font.font:getWidth(label)
	local labelH = font.font:getHeight()
	local width = labelW + VertOffsetElems * 2
	local height = labelH + ButtonHeight + VertOffsetElems
	
	if width < MinWidth then
		width = MinWidth
	end
	
	self:super("close_dialog", 
		virtScrWidth/2 - width/2,
		virtScrHeight/2 - height/2,
		width, height)
	
	self.virtScrWidth = virtScrWidth
	self.virtScrHeight = virtScrHeight
	self.label = label
	self.font = font
	self.invoked = false
	
	local butOffsetX = width/4
	local butOffsetY = height/6
	
	self.yesButton = TexturedButton:new("Yes", font,
		virtScrWidth/2 - butOffsetX - ButtonWidth/2,
		virtScrHeight/2 + butOffsetY - ButtonHeight/2,
		ButtonWidth, ButtonHeight,
		butTexIdle, butTexClicked, yesAction)
	
	self.noButton = TexturedButton:new("No", font,
		virtScrWidth/2 + butOffsetX - ButtonWidth/2,
		virtScrHeight/2 + butOffsetY - ButtonHeight/2,
		ButtonWidth, ButtonHeight,
		butTexIdle, butTexClicked, noAction)
	
	self.clickedButton = nil
end

function YesNoDialog:mouseInArea(x, y)
	return self.invoked and self:mouseInAreaSuper(x, y)
end

function YesNoDialog:invoke()
	self.invoked = true
end

function YesNoDialog:mouseClick(x, y)
	-- Dialog is 100% invoked
	if self.yesButton:mouseInArea(x, y) then
		self.clickedButton = self.yesButton
	elseif self.noButton:mouseInArea(x, y) then
		self.clickedButton = self.noButton
	end
	
	self.clickedButton:mouseClick(x, y)
end

function YesNoDialog:mouseRelease(x, y)
	if self.clickedButton ~= nil then
		if self.clickedButton:mouseInArea(x, y) then
			self.clickedButton:mouseRelease(x, y)
			-- You can close this dialog
			self.invoked = false
		else
			self.clickedButton:mouseReleaseNotInside(x, y)
		end
		
		self.clickedButton = nil
	end
end

function YesNoDialog:mouseReleaseNotInside(x, y)
	if self.clickedButton ~= nil then
		self.clickedButton:mouseReleaseNotInside(x, y)
		self.clickedButton = nil
	end
end

function YesNoDialog:draw()
	if self.invoked then
		-- Draw background with light dark color with low alpha
		-- So that the background "goes dark" and
		-- the user can still see through it
		drawRectC("fill", 0, 0, self.virtScrWidth,
			self.virtScrHeight, BackgroundColor)
		
		-- Background of the dialog itself
		drawRectC("fill", self.virtScrWidth/2 - self.width/2,
			self.virtScrHeight/2 - self.height/2, 
			self.width, self.height, DialogColor)
			
		-- Dialog label
		self.font:drawLineCentered(self.label, 
			self.virtScrWidth/2,
			self.virtScrHeight/2 - self.height/4)
			
		-- Yes, No buttons
		self.yesButton:draw()
		self.noButton:draw()
	end
end