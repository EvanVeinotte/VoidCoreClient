extends WorldObject

const listofskins = [null, "res://Images/Plants/purplepottedplant.png","res://Images/Plants/orangepottedplant.png"]

func setSouthCol(whattosetto):
	get_node("Body/StaticBody2D/southcol").disabled = false

func setNorthCol(whattosetto):
	get_node("Body/StaticBody2D/northcol").disabled = false

func setEastCol(whattosetto):
	get_node("Body/StaticBody2D/eastcol").disabled = false

func setWestCol(whattosetto):
	get_node("Body/StaticBody2D/westcol").disabled = false

func setCollidersBottom(settobottom):
	pass

func _ready():
	objecttypeid = 2
	isplaceableon = false

func setObject(newobjectid):
	objectid = newobjectid
	if(objectid < len(listofskins) and objectid > 0):
		get_node("Body/Sprite").texture = load(listofskins[objectid])
