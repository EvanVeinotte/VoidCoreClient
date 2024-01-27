extends Node2D

@onready var chunkloader = get_node("ChunkLoader")

var referencemap = {}
var visiblechunkkeys = []

func instantiateNewObject(chunk, placepos, objid, objstate, objrot, updateadjacent=false, spawnindata=null):
	var newobject = ObjectLoader.objectbyid[objecttypeid].instance()
	newobject.setObject(objid, objstate, objrot, spawnindata)
	newobject.worldpos = Vector3(placepos.x, placepos.y, placepos.z)
	##its a coin stack
	#if(objecttypeid == 5):
		#newobject.stackstate = extradata
	##its the voidcore
	#if(objecttypeid == 4):
		#MouseController.thevoidcore = newobject
	chunkloader.add_child(newobject)
	###!!! Definitely have to add the map adding handler and
	### reference map adding handler functions
	themap[chunk.x][chunk.y][placepos.z][placepos.y][placepos.x] = Utils.encodeObjectData(newobject)
	referencemap[chunk.x][chunk.y][placepos.z][placepos.y][placepos.x] = newobject
	if(updateadjacent):
		processFloorColliders(newobject)
		updateAdjacentObjects(placepos)

func getClickedObject(clickpos, doubleclick=false):
	var allclicked = []
	var selectednode
	for cobject in chunkloader.get_children():
		var isinside = cobject.checkPointInside(clickpos)
		if(isinside):
			allclicked.append(cobject)
	if(len(allclicked) == 1):
		if(!doubleclick):
			allclicked[0].beSelected()
			selectednode = allclicked[0]
		else:
			allclicked[0].beRotated()
	elif(len(allclicked) > 1):
		var closest = allclicked[0]
		for cobject in allclicked:
			if(cobject.worldpos.x + cobject.worldpos.y + cobject.worldpos.z > closest.worldpos.x + closest.worldpos.y + closest.worldpos.z):
				closest = cobject
		if(!doubleclick):
			closest.beSelected()
			selectednode = closest
		else:
			closest.beRotated()
