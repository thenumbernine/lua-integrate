local function rk2alpha(t,x,dt,f,args)
	local fAtX = f(t, x)
	local k = fAtX * dt
	local alpha = args and args.alpha or .5		-- alpha = .5 <=> midpoint, alpha = 1 <=> Heun
	local frac = 1 / (2 * alpha)
	x = x + (fAtX * (1 - frac) + f(t + alpha * dt, x + k * alpha) * frac) * dt
	return x
end

return rk2alpha
