local function euler(t,x,dt,f)
	x = x + f(t, x) * dt
	return x
end

return euler
