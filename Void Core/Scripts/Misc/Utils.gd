extends Node

func getDigit(fullnum, digitpos):
	var endposdivider = pow(10, digitpos)
	var startposdivider = pow(10, digitpos+1)
	var withstartposremoved = fullnum - floor(fullnum/startposdivider) * startposdivider
	var finalvalue = floor(withstartposremoved/endposdivider)
	return finalvalue

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
		startpos = 5
		endpos = 0
	elif(valtoget == "object_state"):
		startpos = 8
		endpos = 5
	elif(valtoget == "object_rotation"):
		startpos = 9
		endpos = 8
	
	var endposdivider = pow(10, endpos)
	var startposdivider = pow(10, startpos)
	var withstartposremoved = encoded - floor(encoded/startposdivider) * startposdivider
	var finalvalue = floor(withstartposremoved/endposdivider)
	return int(finalvalue)

func encodeObjectData(obj):
	var objectid = obj.myobjid
	var objectstate = obj.myobjstate * 100000
	var objectrotation = int(obj.myobjrot) * 100000000
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

func createEmptyChunkArray():
	var newchunkarray = []
	for z in range(Globs.MAP_SIZE.z):
		newchunkarray.append([])
		for y in range(Globs.CHUNK_SIZE):
			newchunkarray[z].append([])
			for x in range(Globs.CHUNK_SIZE):
				newchunkarray[z][y].append(0)
	return newchunkarray

func genUID():
	var newuid = str(Time.get_unix_time_from_system() * 1000) + str(int(randf() * 9999))
	return newuid
