extends Node2D

@onready var theworld = get_parent()

func loadInMap(mapdata):
	#first get a list of every chunk x key
	#then get a list of every chunk y key in that chunk x key
	#then enter a loop to cycle over every z array
	#then enter a loop to cycle over every y array
	#and then for each x array, cycle through that
	#then individually spawn those objects in
	#and then also add them to the reference map
	var listofxchunkkeys = mapdata.keys()
	for xkey in listofxchunkkeys:
		var listofychunkkeys = mapdata[xkey].keys()
		for ykey in listofychunkkeys:
			for z in range(Globs.MAP_SIZE.z):
				for y in range(Globs.MAP_SIZE.y):
					for x in range(Globs.MAP_SIZE.x):
						#check if there is an object in this pos
						if(mapdata[xkey][ykey][z][y][x]):
							var thisobjectid = Utils.getObjectValue(mapdata[xkey][ykey][z][y][x], "object_id")
							var thisobjectstate = Utils.getObjectValue(mapdata[xkey][ykey][z][y][x], "object_state")
							var thisobjectrotation = Utils.getObjectValue(mapdata[xkey][ykey][z][y][x], "object_rotation")
							var worldpos = WorldCalculations.chunkPosToWorldPos(xkey,ykey,x,y,z)
							theworld.instantiateNewObject(worldpos, thisobjectid, thisobjectstate, thisobjectrotation, true, null, false)
							#print(str(x) + ", " + str(y) + ", " + str(z))
	#this is to make the surrounding chunks visible
	theworld.player.updateWorldPos()


