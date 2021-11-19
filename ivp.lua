local ivp = {}
setmetatable(ivp, ivp)	-- for __call, so you can "xn = require 'integrate.ivp'(t, x, dt, f)"

-- TODO rewrite the API to have more modular operations so that I can abstract it for GPU use as well
ivp.euler = require 'integrate.ivp.euler'
ivp.midpoint = require 'integrate.ivp.midpoint'
ivp.heun = require 'integrate.ivp.heun'
ivp.rk2alpha = require 'integrate.ivp.rk2alpha'
ivp.rk4 = require 'integrate.ivp.rk4'
ivp.rkf45 = require 'integrate.ivp.rkf45'

ivp.method = 'euler'

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
	return self[self.method](t,x,dt,f,...)
end

return ivp
