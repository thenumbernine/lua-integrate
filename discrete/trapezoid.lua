local function trapezoid(xs, ys)
	local n = #xs
	assert(#ys == n)
	assert(n >= 2)
	local sum = (xs[2] - xs[1]) * .5 * (ys[1] + ys[2])
	for i=2,n-1 do
		sum = sum + (xs[i+1] - xs[i]) * .5 * (ys[i] + ys[i+1])
	end
	return sum
end

return trapezoid
