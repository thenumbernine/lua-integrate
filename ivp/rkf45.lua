local function rkf45(t,x,dt,f,args)
	local accuracy = args and args.accuracy or 1e-5
	local tEndFinal = t + dt
	local tEnd = tEndFinal
	local norm = args and args.norm or math.abs
	local maxiterations = args and args.iterations or 100
	repeat
		local currentDt = tEnd - t
		for i=1,maxiterations do
			local k1 = f(t, x) * currentDt
			local k2 = f(t + currentDt * .25, x + k1 * .25) * currentDt
			local k3 = f(t + currentDt * (3/8), x + k1 * (3/32) + k2 * (9/32)) * currentDt
			local k4 = f(t + currentDt * (12/13), x + k1 * (1932/2197) - k2 * (7200/2197) + k3 * (7296/2197)) * currentDt
			local k5 = f(t + currentDt, x + k1 * (439/216) - k2 * 8 + k3 * (3680/513) - k4 * (845/4104)) * currentDt
			local k6 = f(t + currentDt * .5, x - k1 * (8/27) + k2 * 2 - k3 * (3544/2565) + k4 * (1859/4104) - k5 * (11/40)) * currentDt
			local xHi = x + k1 * (16/135) + k3 * (6656/12825) + k4 * (28561/56430) - k5 * (9/50) + k6 * (2/55)
			local xLo = x + k1 * (25/216) + k3 * (1408/2565) + k4 * (2197/4104) - k5 * (1/5)
			local xErr = xHi - xLo
			-- here's the test: error threshold
			-- depends on calculating a magnitude of x, which depends on normalizing its values (so all contribute equally)
			xErr = norm(xErr)
			--print('err',xErr,'vs',accuracy)
			if xErr < accuracy then
				x = xHi
				t = tEnd
				tEnd = tEndFinal
				break
			end
			--print('error threshold won!')
			currentDt = currentDt * .5
			tEnd = t + currentDt
		end
	until t == tEndFinal
	return x
end

return rkf45
