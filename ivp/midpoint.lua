local function midpoint(t,x,dt,f)
	local k = f(t, x) * dt
	x = x + f(t + dt * .5, x + k * .5) * dt
	return x
end

return midpoint
