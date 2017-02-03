require "YesNoDialog"

local QuitElementWidth = 400
local QuitElementHeight = 100

--
-- Runnable "interface"
--

Runnable = class:new()

function Runnable:init()
end

-- Insert a quit button, which if is pressed, a quit dialog is invoked
-- and user can end this "runnable session".
-- @invokeAction:
-- Is triggered when quit button is pressed (and quit dialog is shown)
-- @quitAction:
-- When "Yes" is pressed on quit dialog (user want to close this runnable int.)
-- @continueAction:
-- When "No" is pressed on quit dialog (user want to continue)
--
-- Function returns the quit button and the dialog
function Runnable:insertQuitElement(gui, font, quitButtonCenterX,
	virtScrWidth, virtScrHeight, textureContainer, 
	invokeAction, quitAction, continueAction)
	
	local butIdleTex = textureContainer:getTexture("button_idle")
	local butClickedTex = textureContainer:getTexture("button_click")
	
	local dialog = YesNoDialog:new("Do you really want to quit?", font,
		virtScrWidth, virtScrHeight,
		butIdleTex, butClickedTex,
		quitAction, continueAction)
	
	gui:addElement(dialog)
	
	local quitButtonAc = function()
			invokeAction()
			dialog:invoke()
		end
	
	local quitButW = 150
	
	local quitBut = TexturedButton:new("Quit", font,
		quitButtonCenterX - quitButW/2, 50,
		quitButW, 75,
		butIdleTex, butClickedTex,
		quitButtonAc)
		
	gui:addElement(quitBut)
	
	return quitBut, dialog 
end

function Runnable:handleKeyPress(key)
end

function Runnable:handleKeyRelease(key)
end

function Runnable:handleTextInput(text)
end

function Runnable:handleMouseClick(x, y)
end

function Runnable:handleMouseRelease(x, y)
end

function Runnable:handleMouseMove(x, y, dx, dy)
end

function Runnable:handleTouchPress(id, tx, ty)
end

function Runnable:handleTouchRelease(id, tx, ty)
end

function Runnable:handleTouchMove(id, tx, ty, tdx, tdy)
end

function Runnable:shouldQuit()
	return false
end

function Runnable:update(deltaTime)
end

function Runnable:draw()
end