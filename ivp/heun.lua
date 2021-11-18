local function heun(t,x,dt,f)
	local fAtX = f(t, x)
	local xTilde = x + fAtX * dt
	x = x + (fAtX + f(t + dt, xTilde)) * (dt * .5)
	return x
end

return heun
