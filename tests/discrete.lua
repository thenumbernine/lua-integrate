#!/usr/bin/env lua128
local table = require 'ext.table'
local discrete = require 'integrate.discrete'
local gnuplot = require 'gnuplot'
local matrix = require 'matrix'

-- [[
local correct = .25 * math.pi
local tL = .5 * math.pi
local tR = 0
local fx = math.cos
local fy = math.sin
--]]

local rows = matrix()
for n=3,1000 do
	local xs = table()
	local ys = table()
	for i=0,n do
		local u = i/n
		local t = tL + (tR - tL) * u
		table.insert(xs, fx(t))
		table.insert(ys, fy(t))
	end

	local row = matrix()
	table.insert(row, n)
	for _,method in ipairs{'rect', 'trapezoid', 'simpson'} do
		table.insert(row, math.abs(correct - discrete[method](xs, ys)))
	end
	table.insert(rows, row)
end

gnuplot{
	terminal = 'svg size 1024,768 background rgb "white"',
	output = 'images/1d-discrete.svg',
	style = 'data lines',
	xlabel = 'number of points',
	ylabel = 'integral error',
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
}
