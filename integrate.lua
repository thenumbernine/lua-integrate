local integrate = {}
setmetatable(integrate, integrate)

-- IVP
integrate.ivp = require 'integrate.ivp'

-- 1D ... not sure if it should go in its own subdir or in the root
-- cuz 1D is basic integration
integrate.rect = require 'integrate.rect'
integrate.trapezoid = require 'integrate.trapezoid'
integrate.simpson = require 'integrate.simpson'
integrate.simpson2 = require 'integrate.simpson2'

-- maybe these belong in their own folder?
-- they are tested different to 1D, and they have a different function signature ...
integrate.adaptsim = require 'integrate.adaptsim'
integrate.adaptlob = require 'integrate.adaptlob'

-- default 1D method:
-- non-adaptive
-- integrate.method = 'simpson'
-- adaptive, just like matlab's default (I think?)
integrate.method = 'adaptlob'

function integrate:__call(...)
	return self[self.method](...)
end

return integrate
