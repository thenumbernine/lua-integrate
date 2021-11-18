#!/usr/bin/env lua128

local integrate = require 'integrate'
local matrix = require 'matrix'
local gnuplot = require 'gnuplot'

local function time(f, ...)
	local start = os.clock()
	local result = f(...)
	-- evaluation order ... if it's right-to-left then i can put this all on one line ...
	return os.clock() - start, result
end

--[[
local function f(x) return 2*x end
local correct = 1
--]]
--[[
local function f(x) return x*x end
local correct = 1/3
--]]
--[[
local function f(x) return math.sqrt(1 - x*x) end
local correct = .25 * math.pi
--]]
-- [[
local function f(x) return math.sqrt(x) end
local correct = 2/3
--]]

local intadapt = {
	integrate.adaptsim,
	integrate.adaptlob,
}

local xL = 0
local xR = 1
local rows = matrix()
for i=1,10 do
	local eps = 10^-i

	local row = matrix()
	table.insert(row, eps)
	for _,int in ipairs(intadapt) do
		local time, result = time(int, f, xL, xR, eps)
		table.insert(row, time)
		table.insert(row, math.abs(correct - result))
	end

	table.insert(rows, row)
end

gnuplot{
	terminal = 'svg size 1024,768 background rgb "white"',
	output = 'images/1d-adaptive-time.svg',
	style = 'data linespoints',
	title = 'time',
	data = rows:T(),
	log = 'xy',
	xrange = {[3] = 'reverse'},
	tostring = function(x)
		if type(x) == 'number' then
			return ('%.35f'):format(x)
		else
			return tostring(x)
		end
	end,
	{using='1:2', title='adaptsim'},
	{using='1:4', title='adaptlob'},
}

gnuplot{
	terminal = 'svg size 1024,768 background rgb "white"',
	output = 'images/1d-adaptive-error.svg',
	style = 'data linespoints',
	title = 'error',
	data = rows:T(),
	log = 'xy',
	xrange = {[3] = 'reverse'},
	tostring = function(x)
		if type(x) == 'number' then
			return ('%.35f'):format(x)
		else
			return tostring(x)
		end
	end,
	{using='1:3', title='adaptsim'},
	{using='1:5', title='adaptlob'},
}
