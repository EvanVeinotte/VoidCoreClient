extends WorldObject

func _ready():
	floorlike = true
	canrotate = false
	super()
	

func setSouthCol(whattosetto):
	get_node("Body/StaticBody2D/southcol").disabled = !whattosetto

func setNorthCol(whattosetto):
	get_node("Body/StaticBody2D/northcol").disabled = !whattosetto

func setEastCol(whattosetto):
	get_node("Body/StaticBody2D/eastcol").disabled = !whattosetto

func setWestCol(whattosetto):
	get_node("Body/StaticBody2D/westcol").disabled = !whattosetto

func setCollidersBottom(settobottom):
	if(settobottom):
		get_node("Body/StaticBody2D").position = Vector2(0, Globs.FLOOR_BOTTOM_COLLIDER_Y)
	else:
		get_node("Body/StaticBody2D").position = Vector2(0, 0)
