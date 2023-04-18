extends Node2D

onready var player = get_tree().get_root().get_node("Main/World/YSort/Player")
onready var floorysort = get_node("YSort/FloorYSort")
onready var floorobject = preload("res://Objects/FloorTile.tscn")
onready var onebyonenostackobject = preload("res://Objects/1by1nostack.tscn")
onready var lightsource1by1 = preload("res://Objects/LightSource1by1.tscn")
onready var thevoidcore = preload("res://Scenes/TheVoidCore.tscn")
onready var essence = preload("res://Scenes/Essence.tscn")

onready var objecttypeids = [null, floorobject, onebyonenostackobject, lightsource1by1, thevoidcore,
							essence]

#3-0 = object type id
#7-3 = object id
#10-7 = extra data
#1001000100
var referencemap = []

var themap = [
			[[0, 0, 0, 2001, 2001, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 [0, 0, 2001, 2001, 2001, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 1, 1, 1, 2001, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 1, 1, 2001, 2001, 2001, 2001, 2001, 2001, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2001, 2001, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2001, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 1004, 4001, 4001, 3001, 4001, 0, 2001, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 2001, 4001, 4001, 4001, 4001, 3001, 1, 1, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 4001, 4001, 4001, 4001, 3001, 3001, 1, 1, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 1001, 0, 0, 1, 1, 1, 1, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2001, 1, 1, 1, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]],
			
			[[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 [0, 0, 0, 0, 1003, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 2002, 1002, 2002, 1002, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 30001005, 0, 0, 0, 0, 50001005, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50001005, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2001, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]],
			
			[[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0], 
			 [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]]
			]

func _ready():
	themap = get_tree().get_root().get_node("Main").loadWorldFromFile()
	for z in range(Constants.MAP_SIZE.z):
		referencemap.append([])
		for y in range(Constants.MAP_SIZE.y):
			referencemap[z].append([])
			for x in range(Constants.MAP_SIZE.x):
				referencemap[z][y].append(0)
	
	loadFloorsFromMap()

func loadFloorsFromMap():
	for z in range(Constants.MAP_SIZE.z):
		for y in range(Constants.MAP_SIZE.y):
			for x in range(Constants.MAP_SIZE.x):
				if(themap[z][y][x]):
					var thisobjecttypeid = Constants.getEncodedValue(themap[z][y][x], 3, 0)
					var thisobjectid = Constants.getEncodedValue(themap[z][y][x], 7, 3)
					var extradata = Constants.getEncodedValue(themap[z][y][x], 10, 7)
					instantiateNewObject(Vector3(x,y,z), thisobjecttypeid, thisobjectid, extradata, false)
	var floors = floorysort.get_children()
	for cfloor in floors:
		processFloorColliders(cfloor)

func instantiateNewObject(placepos, objecttypeid, objectid, extradata, updateadjacent, spawnindata=null):
	var newobject = objecttypeids[objecttypeid].instance()
	newobject.setObject(objectid)
	newobject.worldpos = Vector3(placepos.x, placepos.y, placepos.z)
	#its a coin stack
	if(objecttypeid == 5):
		newobject.stackstate = extradata
	#its the voidcore
	if(objecttypeid == 4):
		MouseController.thevoidcore = newobject
	if(spawnindata):
		newobject.spawnin = spawnindata
	floorysort.add_child(newobject)
	themap[placepos.z][placepos.y][placepos.x] = Constants.encodeForMap(objecttypeid, objectid, extradata)
	referencemap[placepos.z][placepos.y][placepos.x] = newobject
	if(updateadjacent):
		processFloorColliders(newobject)
		updateAdjacentObjects(placepos)
	

func updateAdjacentObjects(thispos):
	var adjacentobjects = getAdjacentObjects(thispos)
	for aobj in adjacentobjects:
		processFloorColliders(aobj)

func getAdjacentObjects(thispos):
	var adjacentobjects = []
	#north,east,south,west
	var newposes = [Vector3(thispos.x,thispos.y - 1,thispos.z), Vector3(thispos.x + 1,thispos.y,thispos.z),
					Vector3(thispos.x,thispos.y + 1,thispos.z), Vector3(thispos.x - 1,thispos.y,thispos.z)]
	for i in range(4):
		var newpos = newposes[i]
		if(checkIfWithinWorldMap(newpos)):
			if(referencemap[newpos.z][newpos.y][newpos.x]):
				adjacentobjects.append(referencemap[newpos.z][newpos.y][newpos.x])
	return adjacentobjects

func checkIfPlaceablePos(thepos):
	for z in range(Constants.MAP_SIZE.z):
		z = Constants.MAP_SIZE.z - z - 1
		if(checkIfWithinWorldMap(Vector3(thepos.x, thepos.y, z))):
			if(referencemap[z][thepos.y][thepos.x]):
				if(referencemap[z][thepos.y][thepos.x].isplaceableon):
					return Vector3(thepos.x, thepos.y, z + 1)
				else:
					break
	return false

func getPlaceableWorldPosRing(startpos):
	
	var foundposition = false
	var ring = 0
	
	while !foundposition:
		ring += 1
		if(ring > 3):
			break
		var botleftstartpos = Vector2(startpos.x - 1 * ring, startpos.y + 1 * ring)
		var botrightstartpos = Vector2(startpos.x + 1 * ring, startpos.y + 1 * ring)
		var topleftstartpos = Vector2(startpos.x - 1 * ring, startpos.y - 1 * ring)
		var toprightstartpos = Vector2(startpos.x + 1 * ring, startpos.y - 1 * ring) 
		for i in range((ring-1) * 2 + 3):
			var newpos = checkIfPlaceablePos(Vector2(botleftstartpos.x + i, botleftstartpos.y))
			if(newpos):
				foundposition = newpos
				break
		if(foundposition):
			return foundposition
		for i in range((ring-1) * 2 + 3):
			var newpos = checkIfPlaceablePos(Vector2(botrightstartpos.x, botrightstartpos.y - i))
			if(newpos):
				foundposition = newpos
				break
		if(foundposition):
			return foundposition
		for i in range((ring-1) * 2 + 3):
			var newpos = checkIfPlaceablePos(Vector2(toprightstartpos.x - i, toprightstartpos.y))
			if(newpos):
				foundposition = newpos
				break
		if(foundposition):
			return foundposition
		for i in range((ring-1) * 2 + 3):
			var newpos = checkIfPlaceablePos(Vector2(toprightstartpos.x, toprightstartpos.y + i))
			if(newpos):
				foundposition = newpos
				break
		if(foundposition):
			return foundposition
	
	return foundposition
	

func getZStackLevel(curworldpos):
	var foundemptylevel = false
	var curlevel = 0
	for level in themap:
		if(checkIfWithinWorldMap(curworldpos)):
			if(themap[curlevel][curworldpos.y][curworldpos.x]):
				curlevel +=1
			else:
				foundemptylevel = true
				break
	if(foundemptylevel):
		return curlevel
	else:
		return -1

func newObjectPlaced(thisobject, sendback=false):
	if(!sendback):
		if(checkIfWithinWorldMap(thisobject.worldpos)):
			var extradata = 0
			if(thisobject.objecttypeid == 5):
				print("hello")
				extradata = thisobject.stackstate
			var encodedvalue = Constants.encodeForMap(thisobject.objecttypeid, thisobject.objectid, extradata)
			themap[thisobject.worldpos.z][thisobject.worldpos.y][thisobject.worldpos.x] = encodedvalue
			referencemap[thisobject.worldpos.z][thisobject.worldpos.y][thisobject.worldpos.x] = thisobject
			
			processFloorColliders(thisobject)
			updateAdjacentObjects(thisobject.worldpos)
			
		else:
			thisobject.worldpos = Vector3(thisobject.lastworldpos.x, thisobject.lastworldpos.y, thisobject.lastworldpos.z)
			themap[thisobject.lastworldpos.z][thisobject.lastworldpos.y][thisobject.lastworldpos.x] = thisobject.objectid
			thisobject.calculateposition(thisobject.worldpos)
	else:
		thisobject.worldpos = Vector3(thisobject.lastworldpos.x, thisobject.lastworldpos.y, thisobject.lastworldpos.z)
		themap[thisobject.lastworldpos.z][thisobject.lastworldpos.y][thisobject.lastworldpos.x] = thisobject.objectid
		thisobject.calculateposition(thisobject.worldpos)

func objectPickedUp(thisobject):
	updateAdjacentObjects(thisobject.lastworldpos)

func loadFloorsIntoMap():
	var floors = floorysort.get_children()
	for cfloor in floors:
		themap[cfloor.worldpos.z][cfloor.worldpos.y][cfloor.worldpos.x] = 1
	for cfloor in floors:
		processFloorColliders(cfloor)

func processFloorColliders(thisfloor):
	thisfloor.setLastWorldPos()
	var worldpos = thisfloor.worldpos
	if(worldpos.z == player.currentzlevel - 1):
		var northpos = Vector3(worldpos.x, worldpos.y - 1, worldpos.z)
		if(checkIfWithinWorldMap(northpos)):
			if(Constants.getEncodedValue(themap[northpos.z][northpos.y][northpos.x], 3, 0) == 1):
				thisfloor.setNorthCol(false)
			else:
				thisfloor.setNorthCol(true)
		
		var southpos = Vector3(worldpos.x, worldpos.y + 1, worldpos.z)
		if(checkIfWithinWorldMap(southpos)):
			if(Constants.getEncodedValue(themap[southpos.z][southpos.y][southpos.x], 3, 0) == 1):
				thisfloor.setSouthCol(false)
			else:
				thisfloor.setSouthCol(true)
		
		var eastpos = Vector3(worldpos.x + 1, worldpos.y, worldpos.z)
		if(checkIfWithinWorldMap(eastpos)):
			if(Constants.getEncodedValue(themap[eastpos.z][eastpos.y][eastpos.x], 3, 0) == 1):
				thisfloor.setEastCol(false)
			else:
				thisfloor.setEastCol(true)
		
		var westpos = Vector3(worldpos.x - 1, worldpos.y, worldpos.z)
		if(checkIfWithinWorldMap(westpos)):
			if(Constants.getEncodedValue(themap[westpos.z][westpos.y][westpos.x], 3, 0) == 1):
				thisfloor.setWestCol(false)
			else:
				thisfloor.setWestCol(true)
		
		thisfloor.setCollidersBottom(false)
		
	elif(worldpos.z == player.currentzlevel):
		thisfloor.setNorthCol(true)
		thisfloor.setSouthCol(true)
		thisfloor.setEastCol(true)
		thisfloor.setWestCol(true)
		thisfloor.setCollidersBottom(true)
	else:
		thisfloor.setNorthCol(false)
		thisfloor.setSouthCol(false)
		thisfloor.setEastCol(false)
		thisfloor.setWestCol(false)

func checkIfWithinWorldMap(thispos):
	if(thispos.x < 0 or thispos.x >= Constants.MAP_SIZE.x):
		return false
	if(thispos.y < 0 or thispos.y >= Constants.MAP_SIZE.y):
		return false
	if(thispos.z < 0 or thispos.z >= Constants.MAP_SIZE.z):
		return false
	return true

func checkIfObjectClicked(clickpos):
	var allclicked = []
	var selectednode
	for cobject in floorysort.get_children():
		var isinside = cobject.checkPointInside(clickpos)
		if(isinside):
			allclicked.append(cobject)
	if(len(allclicked) == 1):
		allclicked[0].beSelected()
		selectednode = allclicked[0]
	elif(len(allclicked) > 1):
		var closest = allclicked[0]
		for cobject in allclicked:
			if(cobject.worldpos.x + cobject.worldpos.y + cobject.worldpos.z > closest.worldpos.x + closest.worldpos.y + closest.worldpos.z):
				closest = cobject
		closest.beSelected()
		selectednode = closest
	return selectednode
		
