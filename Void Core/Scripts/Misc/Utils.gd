extends Node

func checkIfNewWorld():
	Globs.newworld = Globs.worlddata.newworld

func checkIfIntroCutscene():
	#inworld needs to be false while cutscene is playing.
	if(SettingsMenu.settingsdata.tutorialenabled):
		Globs.inworld = !Globs.newworld
	else:
		Globs.inworld = true

func _ready():
	Globs.SCREEN_SIZE = get_viewport().size
	get_tree().get_root().connect("size_changed", sizeChanged)
	if(OS.get_name() != "Android"):
		Globs.SCREEN_SIZE *= 2
	Globs.DEVICE_TYPE = OS.get_name()

func sizeChanged():
	Globs.SCREEN_SIZE = get_viewport().size

#func getEncodedValue(encoded, startpos, endpos):
	#var endposdivider = pow(10, endpos)
	#var startposdivider = pow(10, startpos)
	#var withstartposremoved = encoded - floor(encoded/startposdivider) * startposdivider
	#var finalvalue = floor(withstartposremoved/endposdivider)
	#return finalvalue

func getObjectValue(encoded, valtoget):
	var startpos
	var endpos
	
	if(valtoget == "object_id"):
		startpos = 0
		endpos = 5
	elif(valtoget == "object_state"):
		startpos = 5
		endpos = 8
	elif(valtoget == "object_rotation"):
		startpos = 8
		endpos = 9
	
	var endposdivider = pow(10, endpos)
	var startposdivider = pow(10, startpos)
	var withstartposremoved = encoded - floor(encoded/startposdivider) * startposdivider
	var finalvalue = floor(withstartposremoved/endposdivider)
	return finalvalue

func encodeObjectData(obj):
	var objectid = obj.myobjid
	var objectstate = obj.mystate * 100000
	var objectrotation = int(obj.rotated) * 100000000
	var encodedvalue = objectrotation + objectstate + objectid
	return encodedvalue

#func encodeForMap(objecttypeid, objectid, isrotated, extradata=0):
	#var encodedvalue = isrotated * 10000000000 + extradata * 10000000 + objectid * 1000 + objecttypeid
	#return encodedvalue

func globalPosToWorld(globpos):
	#added so mouse is in middle
	globpos = Vector2(globpos.x - Globs.TILE_WIDTH/2.0, globpos.y)
	var worldxpos
	var worldypos
	worldxpos = (-globpos.x * Globs.WORLD_Y_OFFSET.y + Globs.WORLD_Y_OFFSET.x * globpos.y) / (Globs.WORLD_Y_OFFSET.x * Globs.WORLD_X_OFFSET.y - Globs.WORLD_Y_OFFSET.y * Globs.WORLD_X_OFFSET.x)
	worldypos = (-globpos.x * Globs.WORLD_X_OFFSET.y + Globs.WORLD_X_OFFSET.x * globpos.y) / (Globs.WORLD_X_OFFSET.x * Globs.WORLD_Y_OFFSET.y - Globs.WORLD_X_OFFSET.y * Globs.WORLD_Y_OFFSET.x)
	worldxpos = floor(worldxpos)
	worldypos = floor(worldypos)
	return Vector3(worldxpos, worldypos, 0)
