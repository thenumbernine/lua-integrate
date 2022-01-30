local discrete = {}

-- discrete versions.  requires a distinct api to the continuous versions.
-- maybe I should put in its own folder
discrete.rect = require 'integrate.discrete.rect'
discrete.trapezoid = require 'integrate.discrete.trapezoid'
discrete.simpson = require 'integrate.discrete.simpson'

return discrete
