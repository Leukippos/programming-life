# Simulates a cell border of lipids
#
# Parameters
# --------------------------------------------------------
#
# - k
#    - Synthesize rate
# - consume
#    - All the metabolites required for Lipid creation
# 
# Properties
# --------------------------------------------------------
#
# - vLipidProd
#    - k * this * consume
# - dilution
#    - mu * this
#
# Equations
# --------------------------------------------------------
# 
# - this / dt
#    - vLipidProd - dilution
# - consume / dt
#    - vLipidProd
#
class Model.Lipid extends Model.Module

	# Constructor for lipids
	#
	# @param params [Object] parameters for this module
	# @param start [Integer] the initial value of lipid, defaults to 1
	# @param consume [String] the substrate converted to lipid, defaults to "s#int"
	# @option params [Integer] k the subscription rate, defaults to 1
	# @option params [String] dna the dna to use, defaults to "dna"
	# @option params [String] consume the consume substrate, overides the consume parameter, defaults to "s#int"
	# @option params [String] name the name, defaults to "lipid"
	#
	constructor: ( params = {}, start = 1, consume = "s#int" ) ->
	
		# Define differential equations here
		step = ( t, compounds, mu ) ->
		
			results = {}
			
			# Only if the components are available
			if ( @_test( compounds, @dna, @name, @consume ) )
			
				# Rate of synthesization 
				# - The DNA constant k_lipid called k
				# - The DNA itself called dna
				# - The required products 
				#
				vlipidprod = @k * compounds[ @dna ]
				for c in @consume
					vlipidprod *= compounds[ c ]
					
				# Rate of dilution because of cell division
				# 
				dilution = mu * compounds[ @name ]
			
			# If all components are available 
			if ( vlipidprod? )
			
				# The Lipid increase is the rate minus dilution
				#
				results[ @name ] = vlipidprod - dilution
				
				# All the substrates required for synthesisation
				# are hereby subtracted by the increase in DNA
				#
				for c in @consume
					results[ c ] = -vlipidprod	
			
			return results
		
		defaults = @_getParameterDefaults( start, consume )
		params = _( params ).defaults( defaults )
		metadata = @_getParameterMetaData()
		
		super params, step, metadata
		
	# Get parameter defaults array
	#
	# @param start [Integer] the start value
	# @return [Object] default values
	#
	_getParameterDefaults: ( start, consume ) ->
		return { 
		
			# Parameters
			k : 1
			consume: if _( consume ).isArray() then consume else [ consume ] 
			
			# Meta-Parameters 
			dna : 'dna'
			
			# Start values
			starts: { name : start }
			
			# The name
			name : "lipid"
		}
		
	# Get parameter metadata
	#
	# @return [Object] metadata values
	#
	_getParameterMetaData: () ->
		return {
			properties:
				metabolites: [ 'consume' ]
				parameters: [ 'k' ]
		}

(exports ? this).Model.Lipid = Model.Lipid