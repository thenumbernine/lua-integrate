#!/usr/bin/env luajit
local integrate = require 'integrate'
local class = require 'ext.class'
local plot2d = require 'plot2d'

-- numeric
local norm = math.abs
local ytostring = tostring
local ytotable = function(y) return {y} end

--[[
test api:
tInit			<- initial time
y = f(t)		<- implicit solution, used for initializing the state and for verifying the value
y' = df(t,y)	<- derivative, used for integrating
--]]
local implicit = {}

--[[ exp
local tInit = 0
local f = math.exp
local df = math.exp

-- [=[ backwards euler:
y[n+1] - dt * dy/dt[n+1] = y[n]
y[n+1] - dt * y[n+1] = y[n]		<- substituting dy/dt[n+1]
y[n+1] * (1 - dt) = y[n]
y[n+1] = y[n] / (1 - dt)
--]=]
--function implicit.backwardsEuler(t,y,dt) return y / (1 - dt) end
-- [=[ crank-nicolson
(y[n+1] - y[n]) / dt = 1/2 dy/dt[n] + 1/2 dy/dt[n+1]
y[n+1]/dt - 1/2 dy/dt[n+1] = y[n] / dt + 1/2 dy/dt[n]
y[n+1]/dt - 1/2 y[n+1] = y[n] / dt + 1/2 dy/dt[n]	<- substitute dy/dt[n+1] and dy/dt[n]
y[n+1] = y[n] (1/ dt + 1/2) / (1/dt - 1/2)
y[n+1] = y[n] (2 + dt)/(2 - dt)
--]=]
--function implicit.crankNicolson(t,y,dt) return y * (2 + dt) / (2 - dt) end
--]]

--[[ sin exp
local tInit = 0
local function f(t) return math.sin(t) * math.exp(t) end
local function df(t,y) return math.exp(t) * (math.sin(t) + math.cos(t)) end
--]]

-- [[ 1/sin
local tInit = .001
local function f(t) return math.sin(1/t) end
local function df(t,y) return math.cos(1/t) / (-t*t) end
--]]

--[[ 2nd order 2D circle
local vec4 = require 'vec.vec4'
local tInit = 0
local function f(t) return vec4(math.cos(t), math.sin(t), -math.sin(t), math.cos(t)) end		-- position+velocity concatenation
local function df(t,y) return vec4(y[3], y[4], -y[1], -y[2]) end
local function norm(y) return y:length() end
local function ytostring(y) return table.concat(y, '\t') end
local function ytotable(y) return y end
--]]

--[[ hyperbolic motion / relativistic constant acceleration
-- position = t=sinh(g*tau), x=cosh(g*tau)
-- velocity = t=g*cosh(g*tau), x=g*sinh(g*tau)
-- acceleration = t=g^2*sinh(g*tau) x=g^2*cosh(g*tau)
local State = require 'physics.state'
local mvec = require 'physics.mvec'
local tInit = 0
local g = .5
local function f(t)
	local sh = math.sinh(g*t)
	local ch = math.cosh(g*t)
	return State{
		x={[0]=sh/g, ch/g},
		u={[0]=ch, sh},
	}
end
local function df(t,state)
	-- state derivative is computed by the position:
	-- for constant acceleration it is g^2 times the position, coinciding with constant acceleration in a relativistic system		
	local accel = state.x * (g * g)
	
	-- TODO fix me -- this is giving bad #s
	--[=[ for M2 orthogonal it is
	-- u_0 * a_0 - u_i * a_i = 0
	-- u_0 * a_0 = u_i * a_i
	-- a_0 = (a_i * u_i) / u_0
	-- where a_i is the R3 acceleration vector
	local accel = mvec{
		[0] = (state.u[1] * g) / state.u[0],	-- this should 
		g,
	}
	--]=]
	
	return State{x=state.u, u=accel}
end
local function norm(state)
	return state.x[0]*state.x[0] + state.x[1]*state.x[1]
		+ state.u[0]*state.u[0] + state.u[1]*state.u[1]
		
end
local function ytostring(state) 
	--return state.x[0]..'\t'..table.concat(state.x, '\t')..'\t'..state.u[0]..'\t'..table.concat(state.u, '\t')
	return state.x[0]..'\t'..state.x[1]
end
local function ytotable(state)
	local t = {}
	for i=0,3 do
		table.insert(t, state.x[i])
	end
	for i=0,3 do
		table.insert(t, state.u[i])
	end
	return t
end
--]]






local integrateArgs = {
	norm = norm
}

local numIter = 100
local dt = .1

local graphT = table()
local graphs = table()
local numYs = #ytotable(f(0))

-- desired values
do
	for i=1,numYs do
		graphs['des '..i] = { graphT, {} }
	end
	local t = tInit
	for i=1,numIter do
		local y = f(t)
		graphT[i] = t
		
		local ys = ytotable(y)
		for j=1,numYs do
			graphs['des '..j][2][i] = ys[j]
		end
		
		t = t + dt
	end
end

-- explicit integration methods (require 'integrate')
local scores = {}
for name,method in pairs(integrate.methods) do

	for i=1,numYs do
		--graphs[name..' diff '..i] = table()
		graphs[name..' '..i] = { graphT, {} }
	end

	local err = 0
	local t = tInit
	local y = f(t)
	for i=1,numIter do
		local implicitY = f(t)
		local diffY = y - implicitY
		local normDiff = norm(diffY)
		err = err + normDiff

		local ys = ytotable(y)
		for j=1,#ys do
			graphs[name..' '..j][2][i] = ys[j]
		end
		
		-- t should always become t + dt, so how about removing it?
		y = method(t, y, dt, df, integrateArgs)
		t = t + dt
	end
	table.insert(scores, {name=name, err=err})
end

-- implicit integration methods
for name,method in pairs(implicit) do

	for i=1,numYs do
		--graphs[name..' diff '..i] = table()
		graphs[name..' '..i] = { graphT, {} }
	end

	local err = 0
	local t = tInit
	local y = f(t)
	for i=1,numIter do
		local implicitY = f(t)
		local diffY = y - implicitY
		local normDiff = norm(diffY)
		err = err + normDiff

		local ys = ytotable(y)
		for j=1,#ys do
			graphs[name..' '..j][2][i] = ys[j]
		end
		
		y = method(t,y,dt)
		t = t + dt
	end
	table.insert(scores, {name=name, err=err})
end

table.sort(scores, function(a,b) return a.err < b.err end)

for i=1,#scores do
	local score = scores[i]
	print(score.name, score.err)
end

plot2d(graphs, 100, '../font.png')
