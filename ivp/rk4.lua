local function rk4(t,x,dt,f)
	local k1 = f(t, x) * dt
	local k2 = f(t + dt * .5, x + k1 * .5) * dt
	local k3 = f(t + dt * .5, x + k2 * .5) * dt
	local k4 = f(t + dt, x + k3) * dt
	x = x + (k1 + k2 * 2 + k3 * 2 + k4) * (1 / 6)
	return x
end

return rk4
