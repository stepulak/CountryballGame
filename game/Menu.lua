require "GuiElement"

Menu = GuiElement:new()

-- @tree is a data structure which consist of array of buttons
-- and their references to the next menu layer when they are clicked
-- also, each button might have own trigger function (action)
-- 
-- example: @tree = { [1] = { button, action, nextLayer }, [2] = { ... } ... }
function Menu:init(scrVirtWidth, scrVirtHeight,
	buttonWidth, buttonHeight, tree)
	
	self:super("menu", scrVirtWidth/2 - buttonWidth/2, 0, buttonWidth, 0)
	
	self.scrVirtWidth = scrVirtWidth
	self.scrVirtHeight = scrVirtHeight
	self.buttonWidth = buttonWidth
	self.buttonHeight = buttonHeight
	
	self.activeNode = tree
	self.clickedButton = nil
	self.effect = nil
	self.effectSpeed = scrVirtHeight
	
	self:changePropsActiveNode()
end

-- Change menu proportions according to active node and it's buttons
function Menu:changePropsActiveNode()
	if self.activeNode ~= nil then
		self.height = #self.activeNode * self.buttonHeight
		self.y = self.scrVirtHeight/2 - self.height/2
	end
end

-- @dir = "up", "down"
function Menu:createEffect(dir)
	self.effect = {}
	
	if dir == "up" then
		self.effect.direction = 1
		self.effect.topButton = self.clickedButton
		self.effect.botButton = self.clickedButton.nextLayer
		self.effect.offset = 0
	else
		self.effect.direction = -1
		self.effect.topButton = self.clickedButton.prevLayer
		self.effect.botButton = self.clickedButton
		self.effect.offset = self.scrVirtHeight
	end
end

function Menu:proceedEffect(deltaTime)
	local dist = self.effectSpeed * self.effect.direction * deltaTime
	self.effect.offset = self.effect.offset + dist
	
	if (self.effect.direction > 0 and self.effect.offset >= self.scrVirtHeight)
		or (self.effect.direction < 0 and self.effect.offset <= 0) then
		-- stop the effect
		self.effect = nil
	end
end

function Menu:mouseClick(x, y)
	if self.effect == nil and self.activeNode ~= nil then
	
		-- Iterate through buttons in active node and pick one
		for i=1, #self.activeNode do
			local b = self.activeNode[i]
			
			if b.button:mouseInArea(x, y) then
				self.clickedButton = b
				b.button:mouseClick(x, y)
				return
			end
		end
	end
end

function Menu:mouseRelease(x, y)
	if self.clickedButton ~= nil then
		self.clickedButton.button:mouseRelease(x, y)
		
		-- Move to new layer if possible
		if self.clickedButton.nextLayer ~= nil then
			self:createEffect("up")
			self.activeNode = self.clickedButton.nextLayer
		elseif self.clickedButton.prevLayer ~= nil then
			self.createEffect("down")
			self.activeNode = self.clickedButton.prevLayer
		end
		
		self:changePropsActiveNode()
	end
	
	self.clickedButton = nil
end

function Menu:mouseReleaseNotInside(x, y)
	if self.clickedButton ~= nil then
		self.clickedButton:mouseReleaseNotInside(x, y)
	end
	
	self.clickedButton = nil
end

function Menu:update(deltaTime, mouseX, mouseY)
	if self.effect ~= nil then
		self:proceedEffect(deltaTime)
	end
end

function Menu:drawLayer(layer, offset)
	if self.activeNode ~= nil then
		return
	end
	
	love.graphics.push()
	love.graphics.translate(offset + self.x, self.y)
	
	for i = 1, #self.activeNode do
		self.activeNode[i].button:draw()
	end
	
	love.graphics.pop()
end

function Menu:draw(camera)
	
end