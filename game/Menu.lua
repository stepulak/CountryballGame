require "TexturedButton"

Menu = GuiElement:new()

-- @tree is a data structure which consist of array of buttons
-- and their references to the next menu "node" when they are clicked
-- also, each button might have own trigger function (action)
-- 
-- example: @tree = { [1] = { label, action, nextNode }, [2] = { ... } ... }
-- if @tree.label is equal to "~back", it will be considered as "back" button,
-- to switch to the previous node
function Menu:init(scrVirtWidth, scrVirtHeight,
	buttonWidth, buttonHeight, buttonOffset,
	buttonTexIdle, buttonTexClick, font, tree)
	
	self:super("menu", scrVirtWidth/2 - buttonWidth/2, 0, buttonWidth, 0)
	
	self.scrVirtWidth = scrVirtWidth
	self.scrVirtHeight = scrVirtHeight
	
	self.buttonTexIdle = buttonTexIdle
	self.buttonTexClick = buttonTexClick
	self.buttonWidth = buttonWidth
	self.buttonHeight = buttonHeight
	self.buttonOffset = buttonOffset
	
	self.font = font
	
	self.activeNode = tree
	self.clickedButton = nil
	self.effect = nil
	self.effectSpeed = scrVirtHeight*2
	
	self:setupButtonsInTree()
	self:changePropsActiveNode()
end

function Menu:getNodeHeight(node)
	return #node * self.buttonHeight + (#node-1) * self.buttonOffset
end

function Menu:createButton(node, parentNode)
	local y = self.scrVirtHeight/2 - self:getNodeHeight(node)/2
	
	for i=1, #node do
		local label = node[i].label
		
		if label == "~back" then
			label = "Back"
			node[i].nextNode = parentNode
		end
		
		local action = node[i].action ~= nil and node[i].action or function() end
		
		node[i].button = TexturedButton:new(label, self.font, self.x, y,
			self.buttonWidth, self.buttonHeight - 2,
			self.buttonTexIdle, self.buttonTexClick, action)
		
		y = y + self.buttonHeight + self.buttonOffset
		
		if node[i].nextNode ~= nil and label ~= "Back" then
			self:createButton(node[i].nextNode, node)
		end
		
		-- We do not need them anymore
		node[i].label = nil
		node[i].action = nil
	end
end

-- Create buttons in tree from labels and actions
function Menu:setupButtonsInTree()
	if self.activeNode ~= nil then
		self:createButton(self.activeNode, nil)
	end
end

-- Change menu proportions according to active node and it's buttons
function Menu:changePropsActiveNode()
	if self.activeNode ~= nil then
		self.height = self:getNodeHeight(self.activeNode)
		self.y = self.scrVirtHeight/2 - self.height/2
	end
end

-- @dir = "up", "down"
function Menu:createEffect(dir)
	self.effect = {}
	
	if dir == "up" then
		self.effect.dir = -1
		self.effect.topNode = self.activeNode
		self.effect.botNode = self.clickedButton.nextNode
		self.effect.offset = 0
	else
		self.effect.dir = 1
		self.effect.topNode = self.clickedButton.nextNode
		self.effect.botNode = self.activeNode
		self.effect.offset = -self.scrVirtHeight
	end
end

function Menu:proceedEffect(deltaTime)
	local dist = self.effectSpeed * self.effect.dir * deltaTime
	self.effect.offset = self.effect.offset + dist
	
	if (self.effect.dir < 0 and self.effect.offset <= -self.scrVirtHeight)
		or (self.effect.dir > 0 and self.effect.offset >= 0) then
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
		
		local butLabel = self.clickedButton.button.label
		local changeNode = false
		
		-- Move to new node if possible
		if butLabel ~= "Back" and self.clickedButton.nextNode ~= nil then
			self:createEffect("up")
			changeNode = true
		elseif butLabel == "Back" then
			self:createEffect("down")
			changeNode = true
		end
		
		if changeNode then
			self.activeNode = self.clickedButton.nextNode
			self:changePropsActiveNode()
		end
	end
	
	self.clickedButton = nil
end

function Menu:mouseReleaseNotInside(x, y)
	if self.clickedButton ~= nil then
		self.clickedButton.button:mouseReleaseNotInside(x, y)
	end
	
	self.clickedButton = nil
end

function Menu:update(deltaTime, mouseX, mouseY)
	if self.effect ~= nil then
		self:proceedEffect(deltaTime)
	end
end

function Menu:drawNode(node, offset)	
	love.graphics.push()
	love.graphics.translate(0, offset)
	
	for i = 1, #node do
		node[i].button:draw()
	end
	
	love.graphics.pop()
end

function Menu:draw(camera)
	if self.effect == nil then
		if self.activeNode ~= nil then
			self:drawNode(self.activeNode, 0)
		end
	else
		self:drawNode(self.effect.topNode, self.effect.offset)
		self:drawNode(self.effect.botNode, self.effect.offset 
			+ self.scrVirtHeight)
	end
end