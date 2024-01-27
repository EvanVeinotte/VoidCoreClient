extends Node2D

@onready var world = get_parent()

func loadInMap(mapdata):
	pass
	#first get a list of every chunk x key
	#then get a list of every chunk y key in that chunk x key
	#then enter a loop to cycle over every z array
	#then enter a loop to cycle over every y array
	#and then for each x array, cycle through that
	#then individually spawn those objects in
	#and then also add them to the reference map
	var listofxchunkkeys = mapdata.keys()
	for xkey in listofxchunkkeys:
		var listofychunkkeys = xkey.keys()
		for ykey in listofychunkkeys:
			for z in range(Globs.MAP_SIZE.z):
				for y in range(Globs.MAP_SIZE.y):
					for x in range(Globs.MAP_SIZE.x):
						#check if there is an object in this pos
						if(mapdata[xkey][ykey][z][y][x]):
							var thisobjectid = Utils.getObjectValue(mapdata[xkey][ykey][z][y][x], "object_id")
							var thisobjectstate = Utils.getObjectValue(mapdata[xkey][ykey][z][y][x], "object_state")
							var thisobjectrotation = Utils.getObjectValue(mapdata[xkey][ykey][z][y][x], "object_rotation")
							world.instantiateNewObject(Vector2(xkey, ykey), Vector3(x,y,z), thisobjectid, thisobjectstate, thisobjectrotation)


