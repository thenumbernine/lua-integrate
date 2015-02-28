local class = require 'ext.class'
local integrate = require 'integrate'

--[[
a second-order state-holder
State.mvec denotes the kind of vector it holds (default is "mvec" the minkowski vector)
--]]
local State = class()

State.mvec = require 'physics.mvec'

function State:init(args)
	self.x = self.mvec()		-- global position
	self.u = self.mvec{0,[0]=1}	-- global velocity
	self.tau = 0		-- local / proper time
	if args then
		if args.x then self.x = self.mvec(args.x) end
		if args.u then self.u = self.mvec(args.u) end
		if args.tau then self.tau = args.tau end
	end
end

function State.__add(a,b)
	return State{
		x = a.x + b.x,
		u = a.u + b.u,
		tau = a.tau + b.tau,
	}
end

function State.__sub(a,b)
	return State{
		x = a.x - b.x,
		u = a.u - b.u,
		tau = a.tau - b.tau,
	}
end

function State.__mul(a,b)
	return State{
		x = a.x * b,
		u = a.u * b,
		tau = a.tau * b,
	}
end

-- here's the biggest problem ...
-- what determines the acceleration function? specify by local or global?
function dxds(time, state, accel)
	local a
	if accel then
		a = accel(state, time)
	else
		a = 0
	end
	
	--[[ Newton
	return State{x=state.u, u=state.mvec{[0]=1, a}, tau=1}
	--]]

	-- [[ Minkowski: g_ij u^i a^j = 0
	local v = state.u[1]
	-- u[0] * a[0] - u[1] * a[1] = 0
	-- u[0] * a[0] = u[1] * a[1]
	-- a[0] = a[1] * (u[1] / u[0])
	a = state.mvec{[0]=a*v, a}
	local result = State{x=state.u, u=a, tau=1}
	return result
	--]]
end

function State:integrate(dt, accel)
	local tau = self.tau
	local x = integrate(tau, self, dt, function(tau, state) return dxds(tau, state, accel) end, 'euler')
	x.u[0] = math.sqrt(x.u[1] * x.u[1] + 1)		-- Minkowski: post-integration, re-normalize velocity:
	return x
end

function State.__concat(a,b)
	return tostring(a) .. tostring(b)
end

function State:__tostring()
	return '{x='..self.x..', u='..self.u..', tau='..self.tau..'}'
end

return State
