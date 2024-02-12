extends Node2D

@onready var chunkloader = get_node("ChunkLoader")
@onready var player = get_node("Player")

var referencemap = {}
var themap = []
var visiblechunkkeys = []

var newworld
var onlineuid
var onlineworldname
var voiditemcount

func _ready():
	#get_tree().get_root().set_canvas_cull_mask_bit(0, false)
	#get_tree().get_root().set_canvas_cull_mask_bit(1, false)
	#this loads all the mainly referenced nodes into
	#the MouseController, for whatever reason 
	#I decided it was a good idea for it to be the script
	#that everything uses to reference all the things
	MouseController.loadMainInstances()
	themap = Globs.worlddata.themap
	newworld = Globs.worlddata.newworld
	LootTable.scriptedloot = Globs.worlddata.scriptedloot
	onlineuid = Globs.onlineuid
	onlineworldname = Globs.onlineworldname
	voiditemcount = Globs.worlddata.voiditemcount
	chunkloader.loadInMap(themap)

func setValueToMap(cx, cy, z, y, x, value):
	cx = str(cx)
	cy = str(cy)
	if(themap.has(cx)):
		if(themap[cx].has(cy)):
			themap[cx][cy][z][y][x] = value
		else:
			themap[cx][cy] = Utils.createEmptyChunkArray()
			themap[cx][cy][z][y][x] = value
	else:
		themap[cx] = {}
		themap[cx][cy] = Utils.createEmptyChunkArray()
		themap[cx][cy][z][y][x] = value

func getTheMapValue(cx, cy, z, y, x):
	cx = str(cx)
	cy = str(cy)
	if(z < 0 or z > Globs.MAP_SIZE.z - 1):
		return 0
	if(themap.has(cx)):
		if(themap[cx].has(cy)):
			return themap[cx][cy][z][y][x]
	#if return not reached, return zero because invalid
	return 0

func getReferenceMapValue(cx, cy, z, y, x):
	cx = str(cx)
	cy = str(cy)
	if(z < 0 or z > Globs.MAP_SIZE.z - 1):
		return 0
	if(referencemap.has(cx)):
		if(referencemap[cx].has(cy)):
			return referencemap[cx][cy][z][y][x]
	#if return not reached, return zero because invalid
	return null

func setValueToReferenceMap(cx, cy, z, y, x, value):
	cx = str(cx)
	cy = str(cy)
	if(referencemap.has(cx)):
		if(referencemap[cx].has(cy)):
			referencemap[cx][cy][z][y][x] = value
		else:
			referencemap[cx][cy] = Utils.createEmptyChunkArray()
			referencemap[cx][cy][z][y][x] = value
	else:
		referencemap[cx] = {}
		referencemap[cx][cy] = Utils.createEmptyChunkArray()
		referencemap[cx][cy][z][y][x] = value

func checkAndCreateChunk(cx, cy):
	if(themap.has(cx)):
		if(themap[cx].has(cy)):
			return true
		else:
			themap[cx][cy] = Utils.createEmptyChunkArray()
			referencemap[cx][cy] = Utils.createEmptyChunkArray()
	else:
		themap[cx] = {}
		themap[cx][cy] = Utils.createEmptyChunkArray()
		referencemap[cx] = {}
		referencemap[cx][cy] = Utils.createEmptyChunkArray()

func instantiateNewObject(worldpos, objid, objstate, objrot, updateadjacent=false, spawnindata=null, setvisible=true):
	var newobject = ObjectLoader.objectbyid[objid].instantiate()
	newobject.theworld = self
	newobject.setObject(objid, objstate, objrot, worldpos, spawnindata)
	if(objid == 14):
		MouseController.thevoidcore = newobject
	newobject.visible = setvisible
	chunkloader.add_child(newobject)
	var chunkpos = WorldCalculations.worldPosToChunkPos(worldpos)
	setValueToMap(chunkpos.chunkx, chunkpos.chunky, chunkpos.z, chunkpos.y, chunkpos.x, newobject.encodeSelf())
	setValueToReferenceMap(chunkpos.chunkx, chunkpos.chunky, chunkpos.z, chunkpos.y, chunkpos.x, newobject)
	newobject.resetLastWorldPos()
	if(updateadjacent):
		processFloorColliders(newobject)
		updateAdjacentObjects(worldpos)

func setChunkVisibility(cx, cy, setto):
	if(referencemap.has(cx)):
		if(referencemap[cx].has(cy)):
			for z in referencemap[cx][cy]:
				for y in z:
					for x in y:
						if(x):
							x.visible = setto

func objectPickedUp(thisobject):
	updateAdjacentObjects(thisobject.lastworldpos)

func newObjectPlaced(thisobject, sendback=false):
	if(!sendback):
		var chunkpos = WorldCalculations.worldPosToChunkPos(thisobject.myworldpos)
		setValueToMap(chunkpos.chunkx, chunkpos.chunky, chunkpos.z, chunkpos.y, chunkpos.x, thisobject.encodeSelf())
		setValueToReferenceMap(chunkpos.chunkx, chunkpos.chunky, chunkpos.z, chunkpos.y, chunkpos.x, thisobject)
		
		thisobject.resetLastWorldPos()
		processFloorColliders(thisobject)
		updateAdjacentObjects(thisobject.myworldpos)
		
		FileHandler.saveWorldToFile(self, Globs.currentworldfileaddress)
		
	else:
		var chunkpos = WorldCalculations.worldPosToChunkPos(thisobject.lastworldpos)
		thisobject.myworldpos = Vector3(thisobject.lastworldpos.x, thisobject.lastworldpos.y, thisobject.lastworldpos.z)
		setValueToMap(chunkpos.chunkx, chunkpos.chunky, chunkpos.z, chunkpos.y, chunkpos.x, thisobject.encodeSelf())
		setValueToReferenceMap(chunkpos.chunkx, chunkpos.chunky, chunkpos.z, chunkpos.y, chunkpos.x, thisobject)
		thisobject.updatePosition(thisobject.myworldpos)


func checkIfPlaceablePos(thepos, voidok=false):
	var cpos = WorldCalculations.worldPosToChunkPos(thepos)
	var completelyempty = true
	for z in range(Globs.MAP_SIZE.z):
		var curz = Globs.MAP_SIZE.z - z - 1
		if(getReferenceMapValue(cpos.chunkx, cpos.chunky, curz, cpos.y, cpos.x)):
			completelyempty = false
			if(curz == 2):
				break
			if(getReferenceMapValue(cpos.chunkx, cpos.chunky, curz, cpos.y, cpos.x).isplaceableon):
				var wpos = WorldCalculations.chunkPosToWorldPos(cpos.chunkx, cpos.chunky, cpos.x, cpos.y, curz + 1)
				if(wpos != player.worldpos):
					return Vector3(thepos.x, thepos.y, curz + 1)
			else:
				break
	if(voidok):
		if(completelyempty):
			return Vector3(thepos.x, thepos.y, 0)
	return false

func getPlaceableWorldPosRing(startpos, voidok=false):
	player.updateWorldPos()
	var foundposition = false
	var ring = 0
	
	while !foundposition:
		ring += 1
		#this means the search will go out 3 blocks from the center
		if(ring > 3):
			break
		var botleftstartpos = Vector2(startpos.x - 1 * ring, startpos.y + 1 * ring)
		var botrightstartpos = Vector2(startpos.x + 1 * ring, startpos.y + 1 * ring)
		var _topleftstartpos = Vector2(startpos.x - 1 * ring, startpos.y - 1 * ring)
		var toprightstartpos = Vector2(startpos.x + 1 * ring, startpos.y - 1 * ring) 
		for i in range((ring-1) * 2 + 3):
			var newpos = checkIfPlaceablePos(Vector3(botleftstartpos.x + i, botleftstartpos.y, 0), voidok)
			if(newpos):
				foundposition = newpos
				break
		if(foundposition):
			return foundposition
		for i in range((ring-1) * 2 + 3):
			var newpos = checkIfPlaceablePos(Vector3(botrightstartpos.x, botrightstartpos.y - i, 0), voidok)
			if(newpos):
				foundposition = newpos
				break
		if(foundposition):
			return foundposition
		for i in range((ring-1) * 2 + 3):
			var newpos = checkIfPlaceablePos(Vector3(toprightstartpos.x - i, toprightstartpos.y, 0), voidok)
			if(newpos):
				foundposition = newpos
				break
		if(foundposition):
			return foundposition
		for i in range((ring-1) * 2 + 3):
			var newpos = checkIfPlaceablePos(Vector3(toprightstartpos.x, toprightstartpos.y + i, 0), voidok)
			if(newpos):
				foundposition = newpos
				break
		if(foundposition):
			return foundposition
	
	if(voidok == false):
		return getPlaceableWorldPosRing(startpos, true)
	return foundposition

func getZStackLevel(curworldpos):
	var foundemptylevel = false
	var curlevel = 0
	var cpos = WorldCalculations.worldPosToChunkPos(Vector3(curworldpos.x,curworldpos.y, 0))
	checkAndCreateChunk(cpos.chunkx, cpos.chunky)
	for level in themap[cpos.chunkx][cpos.chunky]:
		if(getTheMapValue(cpos.chunkx, cpos.chunky, curlevel, cpos.y, cpos.x)):
			curlevel +=1
		else:
			foundemptylevel = true
			break
	if(foundemptylevel):
		return curlevel
	else:
		return -1

func getClickedObject(clickpos, doubleclick=false):
	var allclicked = []
	var selectednode = null
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
			if(cobject.myworldpos.x + cobject.myworldpos.y + cobject.myworldpos.z > closest.myworldpos.x + closest.myworldpos.y + closest.myworldpos.z):
				closest = cobject
		if(!doubleclick):
			closest.beSelected()
			selectednode = closest
		else:
			closest.beRotated()
	return selectednode

func processFloorColliders(thisfloor):
	if(thisfloor.floorlike):
		var worldpos = thisfloor.myworldpos
		if(worldpos.z == player.currentzlevel - 1):
			var northpos = Vector3(worldpos.x, worldpos.y - 1, worldpos.z)
			var nchunkpos = WorldCalculations.worldPosToChunkPos(northpos)
			if(getReferenceMapValue(nchunkpos.chunkx, nchunkpos.chunky, nchunkpos.z, nchunkpos.y,nchunkpos.x)):
				thisfloor.setNorthCol(false)
			else:
				thisfloor.setNorthCol(true)
			
			var southpos = Vector3(worldpos.x, worldpos.y + 1, worldpos.z)
			var schunkpos = WorldCalculations.worldPosToChunkPos(southpos)
			if(getReferenceMapValue(schunkpos.chunkx, schunkpos.chunky, schunkpos.z, schunkpos.y,schunkpos.x)):
				thisfloor.setSouthCol(false)
			else:
				thisfloor.setSouthCol(true)
			
			var eastpos = Vector3(worldpos.x + 1, worldpos.y, worldpos.z)
			var echunkpos = WorldCalculations.worldPosToChunkPos(eastpos)
			if(getReferenceMapValue(echunkpos.chunkx, echunkpos.chunky, echunkpos.z, echunkpos.y,echunkpos.x)):
				thisfloor.setEastCol(false)
			else:
				thisfloor.setEastCol(true)
			
			var westpos = Vector3(worldpos.x - 1, worldpos.y, worldpos.z)
			var wchunkpos = WorldCalculations.worldPosToChunkPos(westpos)
			if(getReferenceMapValue(wchunkpos.chunkx, wchunkpos.chunky, wchunkpos.z, wchunkpos.y,wchunkpos.x)):
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

func updateAdjacentObjects(wpos):
	var adjacentobjects = getAdjacentObjects(wpos)
	for aobj in adjacentobjects:
		processFloorColliders(aobj)

func getAdjacentObjects(thispos):
	var adjacentobjects = []
	#north,east,south,west
	var newposes = [Vector3(thispos.x,thispos.y - 1,thispos.z), Vector3(thispos.x + 1,thispos.y,thispos.z),
					Vector3(thispos.x,thispos.y + 1,thispos.z), Vector3(thispos.x - 1,thispos.y,thispos.z)]
	for i in range(4):
		var newpos = newposes[i]
		var newcpos = WorldCalculations.worldPosToChunkPos(newpos)
		var adjobj = getReferenceMapValue(newcpos.chunkx, newcpos.chunky, newcpos.z, newcpos.y, newcpos.x)
		if(adjobj):
			adjacentobjects.append(adjobj)
	return adjacentobjects
