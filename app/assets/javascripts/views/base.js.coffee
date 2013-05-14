# Base class for views
# 
class View.Base extends Helper.Mixable
	
	@include Mixin.EventBindings

	# Constructs a new Base view
	# 
	# @param paper [Object] The paper to draw on
	constructor: ( @_paper ) ->
		@_contents = @_paper.set()
		@_views = []

		@_allowBindings()
	
	# Clear the contents of this view and it's children
	# 
	clear: ( ) ->
		@_contents?.remove()

		for view in @_views
			view.clear()

	# Draw this view and it's children
	# 
	# @param x [Integer] The x position
	# @param y [Integer] The y position
	#
	draw: ( @_x, @_y) ->
		@clear()

		for view in @_views
			view.draw()
	
	# Redraw this view and it's children with their current parameters
	# 
	redraw: ( ) ->
		@draw(@_x, @_y)

		for view in @_views
			view.redraw()

	# Resize this view and it's children
	# 
	# @param scale [Float] The scale of the view
	#
	resize: ( scale = @_scale ) ->
		@_contents.transform("S"+scale)

		for view in @_views
			view.resize( scale )

	# Kill this view and it's children, removing and unsetting all references from this view and it's children
	# 
	kill: ( ) ->
		@clear()
		@_contents = null

		for view in @_views
			view.kill()

(exports ? this).View.Base = View.Base