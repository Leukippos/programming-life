class Model.Substrate extends Model.Module

	# Constructor for Substrate
	#
	# @param params [Object] parameters for this module
	# @param start [Integer] the initial value of substrate, defaults to 1
	# @param name [String] the name to use
	# @param inside_cell [Boolean] wether this substrate is inside the cell, defaults to true
	# @option params [Integer] start the start amount of this substrate
	# @option params [String] name the name of this substrate
	# @option params [Integer] placement placement in cell = 1, out cell = -1
	constructor: ( params = {}, start = 1, name, inside_cell = on) ->
			
		# Step function for substrates
		step = ( t, substrates, mu ) ->			
			return { }

		# Default parameters set here
		defaults = { 
			substrates : { name: start }
			name : name
			placement: if inside_cell then 1 else -1
		}
				
		params = _( defaults ).extend( params )
		super params, step

(exports ? this).Model.Substrate = Model.Substrate