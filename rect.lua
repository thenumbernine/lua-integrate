local function rect(f, xL, xR, n, ...)
	n = n or 100
	local dx = (xR - xL) / n
	local sum = f(xL + dx * .5, ...)
	for i=2,n do
		sum = sum + f(xL + dx * (i - .5), ...)
	end
	return sum * dx
end

return rect
