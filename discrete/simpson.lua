-- https://en.wikipedia.org/wiki/Simpson%27s_rule#Composite_Simpson's_rule_for_irregularly_spaced_data
local function simpson(xs, ys)
	n = #xs
	assert(#ys == n)
	assert(n >= 3)
	local sum = 0
	for i=2,n-1,2 do
        local h0 = xs[i] - xs[i-1]
		local h1 = xs[i+1] - xs[i]
        local hph = h1 + h0
		local hdh = h1 / h0
        sum = sum + hph * (
              ys[i-1] * (2 - hdh)
			+ ys[i] * (hph * hph / (h1 * h0))
			+ ys[i+1] * (2 - 1 / hdh)
        )
	end
	if n % 2 == 0 then
		local h0 = xs[n-1] - xs[n-2]
     	local h1 = xs[n] - xs[n-1]
        
		sum = sum + h1 * (
			  ys[n] * (2 * h1 + 3 * h0) / (h0 + h1)
			+ ys[n-1] * (h1 + 3 * h0) / h0
			- ys[n-2] * h1 * h1 / (h0 * (h0 + h1))
		)
	end
	return sum / 6
end

return simpson
