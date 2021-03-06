# Mixin for event enabled classes
#
EventBindings =
	 
	ClassMethods: {}
		
	InstanceMethods:
	
		# Enables bindings
		#
		# @return [self] chainable self
		#
		_allowEventBindings: () ->
			@_bindings = {} unless @_bindings?
			return this 
				 
		# Unbinds all events
		#
		# @return [self] chainable self
		# 
		_unbindAll: () ->
			for event, bindings of @_bindings
				for binding in bindings
					@_unbind( event, binding[ 0 ], binding[ 1] )
			return this
			
		# Binds an event
		# 
		# @param event [String] the event to bind to
		# @param context [Context] the context to bind with
		# @param method [Function] the method to bind
		# @return [self] chainable self
		#
		_bind: ( event, context, method ) ->
			Model.EventManager.on( event, context, method )
			unless @_bindings[ event ]? 
				 @_bindings[ event ] = []
			@_bindings[ event ].push [ context, method ]
			return this
		
		# Unbinds an event
		# 
		# @param event [String] the event to unbind from
		# @param context [Context] the context to unbind for
		# @param method [Function] the method to unbind
		# @return [self] chainable self
		#
		_unbind: ( event, context, func ) ->
			Model.EventManager.off( event, context, func )
			if @_bindings[ event ]?
				for binding in @_bindings[ event ] when binding[ 0 ] is context and binding[ 1 ] is func
					@_bindings[ event ] = _( @_bindings[ event ] ).without binding
			return this
			
		# Triggers an event
		# 
		# @param event [String] the event to trigger from
		# @param context [Context] the context to trigger for
		# @param args [Array] the arguments to send
		# @return [self] chainable self
		#
		_trigger: ( event, context, args ) ->
			Model.EventManager.trigger( event, context, args )
			return this
			
( exports ? this ).Mixin.EventBindings = EventBindings