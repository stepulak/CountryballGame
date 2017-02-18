require "class"

SinCosTable = class:new()

function SinCosTable:init()
	self.cosTable = {}
	self.sinTable = {}
	for i = 0, 359 do
		self.cosTable[i] = math.cos(math.rad(i))
		self.sinTable[i] = math.sin(math.rad(i))
	end
end

-- Return positive integer angle (in degrees)
function SinCosTable:positiveIntegerAngle(angle)
	angle = math.fmod(math.floor(angle), 360)
	if angle < 0 then
		angle = angle + 360
	end
	return angle
end

-- Return approximated value of cos(angle)
function SinCosTable:cos(angle)
	return self.cosTable[self:positiveIntegerAngle(angle)]
end

-- Return approximated value of sin(angle)
function SinCosTable:sin(angle)
	return self.sinTable[self:positiveIntegerAngle(angle)]
end