local function trapezoid(xs, ys)
	local n = #xs
	assert(#ys == n)
	assert(n >= 2)
	local sum = 0
	for i=1,n-1 do
		sum = sum + (xs[i+1] - xs[i]) * .5 * (ys[i] + ys[i+1])
	end
	return sum
end

return trapezoid
