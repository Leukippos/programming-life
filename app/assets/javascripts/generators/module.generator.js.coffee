class ModuleGenerator
	
	# Creates a infrastructure
	#
	# @param [String] name the dna name
	# @param [Object] params the options
	# @returns [Array] the modules
	#
	infrastructure : ( params = {}, lipid_food = "s_in", protein_food = "p_in", own_dna_food = false ) -> 
		results = []
		
		if ( !own_dna_food )
			results = results.concat @dna( false, own_dna_food, params )
			
		results = results.concat(
			@lipid( params, lipid_food, own_dna_food )
			@protein( params, protein_food, own_dna_food )
		)
			
		return results
		
	# Creates a DNA module
	#
	# @param [String] name the dna name
	# @param [Object] params the options
	# @returns [Array] the modules
	#
	dna : ( name, food = "p_in", params = {} ) ->
		return [ 
			new Module(
				{ 
					k : params.k_dna ? 1
					name: if name then name + "_dna" else "dna"
					product: food
				}, 
				
				( t, substrates ) ->
					vdnasynth = this.k * substrates[this.name] * substrates[this.product]
					results = {}
					results[this.name] = vdnasynth
					results[this.product] = -vdnasynth
					return results
			)
		]
		
	# Creates Lipid modules
	#
	# @param [Object] params the options
	# @param [Boolean] own_dna_food creates own dna for module
	# @returns [Array] the modules
	#
	lipid : ( params = {}, food = "s_in", own_dna_food = false ) ->
		modules = []
		dna = "dna"
		
		if ( own_dna_food )
			modules = modules.concat @dna( 'lipid', own_dna_food, params )
			dna = "lipid_dna"
		
		modules.push new Module( 
			{ 
				k: params.k_l ? 1 
				dna: dna
				substrate: food
			},
			( t, substrates ) ->
				vlipid = this.k * substrates[this.dna] * substrates[this.substrate]
				
				results = {}
				results["lipid"] = vlipid # todo mu
				results[this.substrate] = -vlipid	
				
				return results
		)
		
		return modules
		
	# Creates Transporter into the cell
	#
	# @param [Object] params the options
	# @param [String] substrate the substrate name
	# @param [Boolean] own_dna_food creates own dna for module
	# @returns [Array] the modules
	#
	transporter_in : ( params = {}, substrate = "s", own_dna_food = false ) ->
		return @transporter( params, "transport_#{substrate}_in", "#{substrate}_ext", "#{substrate}_in", own_dna_food )
		
	# Creates Transporter out of the cell
	#
	# @param [Object] params the options
	# @param [String] product the product name
	# @param [Boolean] own_dna_food creates own dna for module
	# @returns [Array] the modules
	#
	transporter_out : ( params = {}, product = "p", own_dna_food = false ) ->
		return @transporter( params, "transport_#{product}_out", "#{product}_in", "#{product}_ext", own_dna_food )
		
	# Creates Transporter
	#
	# @param [Object] params the options
	# @param [String] origin the origin name
	# @param [String] destination the destination name
	# @param [Boolean] own_dna_food creates own dna for module
	# @returns [Array] the modules
	#
	transporter : ( params = {}, name, origin, destination, own_dna_food = false ) ->
		modules = []
		dna = "dna"
		
		if ( own_dna_food )
			modules = modules.concat @dna( name, own_dna_food, params )
			dna = "#{name}_dna"
			
		modules.push new Module( 
			{ 
				k: params.k_tr ? 1
				v_max : params.v_max ? 1 
				k_rate: params.k_rate ? 1
				orig: origin
				dest: destination
				name: name
				dna: dna
			},
			( t, substrates ) -> 
				vtransport = this.v_max * substrates[this.name] * 
					( substrates[this.orig] / ( substrates[this.orig] + this.k_rate ) )
				
				results = {}
				results[this.name] = this.k * substrates[this.dna]
				results[this.dest] = vtransport
				results[this.orig] = -vtransport
				return results
		)
		
		return modules
		
	# Creates Metabolism
	#
	# @param [Object] params the options
	# @param [String] substrate the substrate name
	# @param [String] product the product name
	# @param [Boolean] own_dna_food creates own dna for module
	# @returns [Array] the modules
	#
	metabolism : ( params = {}, substrate, product, own_dna_food = false ) ->
		modules = []
		dna = "dna"
		
		if ( own_dna_food )
			modules = modules.concat @dna( 'metabolism', own_dna_food, params )
			dna = "metabolism_dna"
			
		modules.push new Module(
			{ 
				k: params.k_ei ? 1
				k_met: params.k_met ? 1 
				v_max: params.v_max ? 1
				substrate: substrate ? "s_in"
				product: product ? "p_in"
				dna: dna
			},
			( t, substrates ) -> 
				vmetabolism = this.v_max * substrates.enzym * 
					( substrates[this.substrate] / ( substrates[this.substrate] + this.k_met ) )

				result = {}
				result["enzym"] = this.k * substrates[this.dna]
				result[this.substrate] = -vmetabolism
				result[this.product] = vmetabolism
				return result
		)
		
		return modules
		
    # Creates Protein
	#
	# @param [Object] params the options
	# @param [Boolean] own_dna_food creates own dna for module
	# @returns [Array] the modules
	#		
	protein : ( params = {}, food = "p_in", own_dna_food = false ) ->
		modules = []
		dna = "dna"
		
		if ( own_dna_food )
			modules = modules.concat @dna( 'protein', own_dna_food, params )
			dna = "protein_dna"
		
		modules.push new Module( 
			{ 
				k: params.k_p ? 1
				dna: dna
				product: food
			},
			( t, substrates ) -> 
				
				vprotsynth = this.k * substrates[this.dna] * substrates[this.product];
				result = {}
				result["protein"] = vprotsynth
				result[this.product] = -vprotsynth
				return result
		)
		
		return modules
		
(exports ? this).ModuleGenerator = new ModuleGenerator