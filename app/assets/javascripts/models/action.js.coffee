# A model for the action object used for (un)doing
#
class Model.Action
	
	# Creates a new action object
	#
	# @param context [Object] The context to execute the action is
	# @param do [Function] The function to execute in the context on (re)do
	# @param undo [Function] The function to execute in the context on undo
	# @param description [String] A description of the action
	#
	constructor: ( context, todo, undo, description = "Action" ) ->
		@_context = context
		@_todo = todo
		@_undo = undo
		@_description = description
		
	# Sets the up and down functions for this action
	#
	# @param todo [Function] The function to execute in the context on (re)do
	# @param undo [Function] The function to execute in the context on undo
	#
	set: ( todo, undo ) ->
		@_todo = todo
		@_undo = undo
		return this
	
	# Apply the do function on context
	# 
	do: ( ) ->
		@_todo?.apply( @_context )
		return this
	
	# Apply the undo function on context
	#
	undo: ( ) ->
		@_undo?.apply( @_context )
		return this
	
	# Wrapper for do for convenience
	# 
	redo: ( ) ->
		return @do()

		
	
(exports ? this).Model.Action = Model.Action
