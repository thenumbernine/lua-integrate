local ivp = {}
setmetatable(ivp, ivp)

-- TODO rewrite the API to have more modular operations so that I can abstract it for GPU use as well
ivp.methods = {
	euler = require 'integrate.ivp.euler',
	midpoint = require 'integrate.ivp.midpoint',
	heun = require 'integrate.ivp.heun',
	rk2alpha = require 'integrate.ivp.rk2alpha',
	rk4 = require 'integrate.ivp.rk4',
	rkf45 = require 'integrate.ivp.rkf45',
}
-- annndd put them in the 'ivp' namespace too.  why not.  why even have 'methods' ?
for k,v in pairs(ivp.methods) do
	ivp[k] = v
end

--[[
arguments:
	t = parameter
	x = initial integral function value, F(t)
	dt = change in parameter to ivp
	f(t,x) = function to ivp
	methodName = name of method to use.  default: euler
		options: euler, midpoint, heun, rk2alpha, rk4, rkf45
	... = (optional) extra arguments used by some integrators

extra arguments:
	rk2alpha: ... = args table with the following fields:
		alpha = alpha parameter
		
	rkf45: ... = args table with the following fields:
		norm(x) = norm of x.  by default this is math.abs
		accuracy = threshold of subdivision.  default is 1e-5
		iterations = maximum iterations.  default is 100
	
operators used: (assuming f() returns an object of metatable x)
	+(x,x) vector-vector addition
	*(x,t) vector-scalar product
	
	-(x,x) vector-vector subtraction is used by rkf45
	
returns:
	F(t+dt)
--]]
function ivp:__call(t, x, dt, f, methodName, ...)
	methodName = methodName or 'euler'
	local method = self.methods[methodName]
	return method(t,x,dt,f,...)

	-- TODO general constraint function for state after integration?
	-- Minkowski: post-integration, re-normalize velocity:
	--x.u[0] = math.sqrt(x.u[1] * x.u[1] + 1)	
end

return ivp
