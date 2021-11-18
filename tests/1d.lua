#!/usr/bin/env lua128

-- integration format: integrate(f, xL, xR, n)
local integrate = require 'integrate'
local matrix = require 'matrix'
local gnuplot = require 'gnuplot'

--[[
local function f(x) return math.sqrt(1 - x*x) end
local correct = .25 * math.pi
--]]
-- [[
local function f(x) return math.sqrt(x) end
local correct = 2/3
--]]
local xL = 0
local xR = 1
local rows = matrix()
for n=1,1000 do
	table.insert(rows, matrix{
		n,
		(correct - integrate.rect(f, xL, xR, n)),
		(correct - integrate.trapezoid(f, xL, xR, n)),
		(correct - integrate.simpson(f, xL, xR, n)),
		(correct - integrate.simpson2(f, xL, xR, n)),
	})
end

gnuplot{
	persist = true,
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
