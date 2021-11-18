local class = require 'ext.class'

local mvec = class()

-- time is the last (2nd) index
function mvec:init(args)
	self[0] = 0
	self[1] = 0
	self[2] = 0
	self[3] = 0
	if args then
		self[0] = args[0] or 0
		self[1] = args[1] or 0
		self[2] = args[2] or 0
		self[3] = args[3] or 0
	end
end

function mvec.__add(a,b)
	return mvec{
		[0] = a[0] + b[0],
		a[1] + b[1],
		a[2] + b[2],
		a[3] + b[3],
	}
end

function mvec.__sub(a,b)
	return mvec{
		[0] = a[0] - b[0],
		a[1] - b[1],
		a[2] - b[2],
		a[3] - b[3],
	}
end

function mvec.__mul(a,b)
	return mvec{
		[0] = a[0] * b,
		a[1] * b,
		a[2] * b,
		a[3] * b,
	}
end

function mvec.__div(a,b)
	return mvec{
		[0] = a[0] / b,
		a[1] / b,
		a[2] / b,
		a[3] / b,
	}
end

function mvec:__tostring()
	return '{'..self[0]..', '..table.concat(self, ', ')..'}'
end

function mvec.__concat(a,b)
	return tostring(a) .. tostring(b)
end

return mvec
