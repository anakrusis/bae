-- Each Action can have an infinite number of PixelChanges attributed to it
-- What holds the PixelChanges together is usually that they were all done in a single mouse stroke, so it takes a single "Undo" to reverse them all.

Action = {
	name = "",
	pixelChanges = {}
}

function Action:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o
end

PixelChange = {
	startColor = 0,
	endColor   = 0,
	xPos = 0,
	yPos = 0
}

function PixelChange:new(o)
	o = o or {}
	setmetatable(o, self)
	self.__index = self
	return o	
end