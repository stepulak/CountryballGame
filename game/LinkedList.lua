require "class"

LinkedList = class:new()

function LinkedList:init()
	self.head = nil
	self.tail = nil
end

function LinkedList:isEmpty()
	return self.head == nil
end

function LinkedList:pushFront(data)
	if self.head == nil then
		-- First node?
		self.head = {
			prev = nil,
			next = nil,
			data = data,
		}
		self.tail = self.head
	else
		self.head = {
			prev = nil,
			next = self.head,
			data = data
		}
		self.head.next.prev = self.head
	end
end
  
function LinkedList:pushBack(data)
	if self.tail == nil then
		-- First node?
		self.tail = {
			prev = nil,
			next = nil,
			data = data,
		}
		self.head = self.tail
	else
		self.tail = {
			prev = self.tail,
			next = nil,
			data = data,
		}
		self.tail.prev.next = self.tail
	end
end

function LinkedList:addBefore(node, data)
	if node == nil then
		self:pushBack(data)
	elseif node == self.head then
		self:pushFront(data)
	else
		-- Within the list
		local n = {
			prev = node.prev,
			next = node,
			data = data,
		}
		node.prev.next = n
		node.prev = n
	end
end

function LinkedList:popBack()
	if self.tail ~= nil then
		-- Don't forget to return the user's data
		local data = self.tail.data
		
		if self.tail.prev == nil then
			self.tail = nil
			self.head = nil
		else
			local prev = self.tail.prev
			prev.next = nil
			self.tail = prev
		end
		return data
	end
	return nil
end

function LinkedList:popFront()
	if self.head ~= nil then
		-- Don't forget to return the user's data
		local data = self.head.data
		
		if self.head.next == nil then
			self.head = nil
			self.tail = nil
		else
			local next = self.head.next
			next.prev = nil
			self.head = next
		end
		return data
	end
	return nil
end

function LinkedList:deleteNode(node)
	if node == self.head then
		self:popFront()
	elseif node == self.tail then
		self:popBack()
	else
		-- Simple references swap
		node.data = nil
		node.prev.next = node.next
		node.next.prev = node.prev
	end
end