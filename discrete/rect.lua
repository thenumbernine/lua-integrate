local function rect(xs, ys)
	n = #xs
	assert(#ys == n)
	assert(n >= 2)
	local sum = 
		-- dx of first and last is half the distance to the next 
		.5 * (
			(xs[2] - xs[1]) * ys[1]
			+ (xs[n] - xs[n-1]) * ys[n]
		)
	for i=2,n-1 do
		sum = sum + .5 * (xs[i+1] - xs[i-1]) * ys[i]
	end
	return sum
end

return rect
