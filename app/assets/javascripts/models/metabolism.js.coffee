class Metabolism extends Module

	constructor: ( params = {}, substrate = "s_int", product = "p_int" ) ->
	
		# Step function for lipids
		step = ( t, substrates ) ->
		
			results = {}			
			return results
		
		# Default parameters set here
		defaults = { 
		}
		
		params = _( defaults ).extend( params )
		super params, step

(exports ? this).Metabolism = Metabolism