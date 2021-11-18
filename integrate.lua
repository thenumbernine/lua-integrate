local integrate = {}

-- IVP
integrate.ivp = require 'integrate.ivp'

-- 1D ... not sure if it should go in its own subdir or in the root
-- cuz 1D is basic integration
integrate.rect = require 'integrate.rect'
integrate.trapezoid = require 'integrate.trapezoid'
integrate.simpson = require 'integrate.simpson'
integrate.simpson2 = require 'integrate.simpson2'

return integrate
