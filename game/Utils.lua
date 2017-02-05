function drawTex(tex, x, y, w, h)
	local texW, texH = tex:getDimensions()
	texW, texH = w/texW, h/texH
	
	love.graphics.draw(tex, x, y, 0, texW, texH)
end

function drawTexFlipped(tex, x, y, w, h)
	local texW, texH = tex:getDimensions()
	texW, texH = w/texW, h/texH
	
	love.graphics.draw(tex, x+w, y, 0, -texW, texH)
end

-- @mode = "fill", "line"
function drawRect(mode, x, y, w, h, r, g, b, a)
	love.graphics.setColor(r, g, b, a)
	love.graphics.rectangle(mode, x, y, w, h)
	-- Set back to default color
	love.graphics.setColor(255, 255, 255, 255)
end

-- see @drawRect function
function drawRectC(mode, x, y, w, h, col)
	drawRect(mode, x, y, w, h, col.r, col.g, col.b, col.a)
end

function lineIntersect(p1, len1, p2, len2)
	return (p1 >= p2 and p1 <= p2 + len2) or (p2 >= p1 and p2 <= p1 + len1)
end

function pointInCircle(x, y, circleX, circleY, radius)
	local dx = x-circleX
	local dy = y-circleY
	return math.sqrt(dx*dx + dy*dy) <= radius
end

function pointInRect(x, y, rectX, rectY, rectW, rectH)
	return x >= rectX and y >= rectY 
		and x <= rectX+rectW and y <= rectY+rectH
end

function rectRectCollision(x1, y1, w1, h1, x2, y2, w2, h2)
	return pointInRect(x1, y1, x2, y2, w2, h2) or
		pointInRect(x1+w1, y1, x2, y2, w2, h2) or
		pointInRect(x1+w1, y1+h1, x2, y2, w2, h2) or
		pointInRect(x1, y1+h1, x2, y2, w2, h2) or
		pointInRect(x2, y2, x1, y1, w1, h1)
end

local maxDist = 2^20

-- Return shortest distance between the first rectangle
-- and the second rectangle, either horizontal or vertical,
-- so that if you move the first rectangle back with the given distance,
-- there won't be any collision between them...

-- @vx, vy is direction vector of the first rectangle
-- @cx, cy... center point of the specific rectangle

-- Remember, the two rectangles must be in collision! 
function getShortestDistanceRectRectCollision(vx, vy, 
	cx1, cy1, w1, h1, cx2, cy2, w2, h2)
	
	local distX, distY = maxDist, maxDist
	
	if vx < 0 and cx1 - w1/2 < cx2 + w2/2 then
		distX = cx2 + w2/2 - (cx1 - w1/2)
	elseif vx > 0 and cx1 + w1/2 > cx2 - w2/2 then
		distX = cx2 - w2/2 - (cx1 + w1/2)
	end
	
	-- Get the vertical distance to the object
	if vy > 0 and cy1 + h1/2 > cy2 - h2/2 then
		distY = cy2 - h2/2 - (cy1 + h1/2)
	elseif vy < 0 and cy1 - h1/2 < cy2 + h2/2 then
		distY = cy2 + h2/2 - (cy1 - h1/2)
	end
	
	return distX, distY
end

-- Get distance between two rectangles
-- @cx, cy = center point of specific rectangle
function getDistanceRectRect(cx1, cy1, w1, h1, cx2, cy2, w2, h2)
	return math.abs(cx1 - cx2) - w1/2 - w2/2, 
		math.abs(cy1 - cy2) - h1/2 - h2/2
end

function getUnitValue(v)
	if v < 0 then
		v = -1
	elseif v > 0 then
		v = 1
	end
	
	return v
end

function getUnitVector(vx, vy)
	return getUnitValue(vx), getUnitValue(vy)
end

function setWithinRange(value, minValue, maxValue)
	if value < minValue then
		value = minValue
	elseif value > maxValue then
		value = maxValue
	end
	return value
end

local MutMax = 20

-- Mutate given color. In other words, slightly change given color value
-- except the alpha channel.
function mutateColor(col)
	col.r = setWithinRange(col.r + math.random(-MutMax, MutMax), 0, 255)
	col.g = setWithinRange(col.g + math.random(-MutMax, MutMax), 0, 255)
	col.b = setWithinRange(col.b + math.random(-MutMax, MutMax), 0, 255)
end

function colorToString(col)
	return col.r .. " " .. col.g .. " " .. col.b .. " " .. col.a
end

function getScaleVirtualToReal(realWidth, virtualWidth,
	realHeight, virtualHeight)
	
	return realWidth/virtualWidth, realHeight/virtualHeight
end

function getScaleRealToVirtual(realWidth, virtualWidth,
	realHeight, virtualHeight)
	
	return virtualWidth/realWidth, virtualHeight/realHeight
end

-- if @applyCamTranslate is true, then the mouse position will
-- be translated according to the camera position
function getScaledMousePosition(camera, applyCamTranslate)
	local sx, sy = getScaleRealToVirtual(
		camera.screenWidth, camera.virtualWidth,
		camera.screenHeight, camera.virtualHeight)
	local mx, my = love.mouse.getPosition()
	
	if applyCamTranslate then
		return mx * sx + camera.x, my * sy + camera.y
	else
		return mx * sx, my * sy
	end
end

function max(v1, v2)
	return v1 < v2 and v2 or v1
end

-- @angle must be somewhere between [-360,720)
function normalizeAngle(angle)
	if angle < 0 then
		return angle + 360
	elseif angle >= 360 then
		return angle - 360
	end
	return angle
end

-- Return keys from table t, result is indexed from 1
function getKeysFromTable(t)
	local keys = {}
	
	for key, value in pairs(t) do
		keys[#keys + 1] = key
	end
	
	return keys
end

function splitStringBySpace(s)
	local words = {}
	
	for w in string.gmatch(s, "%S+") do
		words[#words + 1] = w
	end
	
	return words
end

-- Try to write string into file
-- If error occurs, write 
function checkWriteLn(file, str)
	local suc, err =  file:write(str .. "\n")
	
	if suc == false then
		print("Error while writing string: " .. str ..
			" into file: " .. file:getFilename() ..
			" error: " .. err)
	end
end

-- Based on https://gist.github.com/MihailJP/3931841
-- Clone the table, it's also possible to clone the table's elements
-- via recursion if deepClone is enabled.
function clone(t, deepClone)
    if type(t) ~= "table" then 
		return t
	end
	
    local meta = getmetatable(t)
    local target = {}
	
    for k, v in pairs(t) do
        if type(v) == "table" and deepClone then
            target[k] = clone(v, true)
        else
            target[k] = v
        end
    end
	
    setmetatable(target, meta)
    
    return target
end