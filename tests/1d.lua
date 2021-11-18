#!/usr/bin/env lua128

-- integration format: integrate(f, xL, xR, n)
local integrate = require 'integrate'
local matrix = require 'matrix'
local gnuplot = require 'gnuplot'

--[[ linear ... everything always machine precision
local function f(x) return 2*x end
local correct = 1
--]]
--[[ quadratic:
-- simpson and simpson2 do machine-precision always
-- then trapezoid
-- then rect
local function f(x) return x*x end
local correct = 1/3
--]]
--[[ circle
-- rect is best, then simpson, then simpson2, then trapezoid
local function f(x) return math.sqrt(1 - x*x) end
local correct = .25 * math.pi
--]]
-- [[ sqrt
-- rect is best, then simpson, then simpson2, then trapezoid
local function f(x) return math.sqrt(x) end
local correct = 2/3
--]]

local xL = 0
local xR = 1

local rows = matrix()
for n=1,1000 do
	table.insert(rows, matrix{
		n,
		math.abs(correct - integrate.rect(f, xL, xR, n)),
		math.abs(correct - integrate.trapezoid(f, xL, xR, n)),
		math.abs(correct - integrate.simpson(f, xL, xR, n)),
		math.abs(correct - integrate.simpson2(f, xL, xR, n)),
	})
end

gnuplot{
	terminal = 'svg size 1024,768 background rgb "white"',
	output = 'images/1d.svg',
	style = 'data lines',
	data = rows:T(),
	log = 'xy',
	tostring = function(x)
		if type(x) == 'number' then
			return ('%.35f'):format(x)
		else
			return tostring(x)
		end
	end,
	{using='1:2', title='rect'},
	{using='1:3', title='trapezoid'},
	{using='1:4', title='simpson'},
	{using='1:5', title='simpson2'},
}
