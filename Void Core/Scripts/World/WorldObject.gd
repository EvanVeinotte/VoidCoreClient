extends Node2D

class_name WorldObject

var theworld
@onready var camera = get_tree().get_root().get_node("GameWorld/MainCamera")
@onready var player = get_tree().get_root().get_node("GameWorld/World/Player")

var myobjid
var myobjstate
var myobjrot

var myworldpos = Vector3(0,0,0)
var lastworldpos = myworldpos

var canrotate = true
var canplace = true
#this will change if objs change their colliders based on neighbors
var floorlike = false
var coinlike = false
var isplaceableon = true

var selected = false
var spawnindata = null

func encodeSelf():
	return Utils.encodeObjectData(self)

func setObject(myid, mystate, myrot, worldpos, newspawnindata=null):
	myobjid = myid
	myobjstate = mystate
	myobjrot = myrot
	spawnindata = newspawnindata
	updatePosition(worldpos)

func beRotated(settovalue=null, _initset=false):
	if(canrotate):
		if(settovalue != null):
			get_node("Body/Sprite").flip_h = bool(settovalue)
			myobjrot = bool(settovalue)
		else:
			get_node("Body/Sprite").flip_h = !get_node("Body/Sprite").flip_h
			myobjrot = get_node("Body/Sprite").flip_h
		if(get_node("Body/Sprite").hframes == 2):
			get_node("Body/Sprite").frame = int(myobjrot)
		theworld.newObjectPlaced(self)

func beSelected():
	selected = true
	get_node("Body").modulate = Color(0,1,0)
	SoundHandler.playSFX("Pickup")
	var lastcp = WorldCalculations.worldPosToChunkPos(lastworldpos)
	theworld.setValueToMap(lastcp.chunkx,lastcp.chunky,lastcp.z, lastcp.y, lastcp.x, 0)
	theworld.setValueToReferenceMap(lastcp.chunkx,lastcp.chunky,lastcp.z, lastcp.y, lastcp.x, 0)
	theworld.objectPickedUp(self)
	selected = true
	MouseController.selectednode = self

func beDeselected():
	get_node("Body").modulate = Color(1,1,1)
	SoundHandler.playSFX("Place")
	selected = false
	theworld.newObjectPlaced(self, !canplace)

func updatePosition(newworldpos):
	myworldpos = newworldpos
	var newxpos = newworldpos.x * Globs.WORLD_X_OFFSET.x + newworldpos.y * Globs.WORLD_Y_OFFSET.x
	var newypos = newworldpos.x * Globs.WORLD_X_OFFSET.y + newworldpos.y * Globs.WORLD_Y_OFFSET.y
	self.position = Vector2(newxpos, newypos)
	var body = get_node("Body")
	body.position = Vector2(body.position.x, -(Globs.TILE_HEIGHT/2.0) * newworldpos.z)

	self.z_index = ceil(self.position.y/(Globs.TILE_HEIGHT/2.0)) * 10 + newworldpos.z

func getObjectUnder():
	var newcoord = Vector3(myworldpos.x, myworldpos.y, myworldpos.z - 1)
	var objectunder
	var chunkdata = WorldCalculations.worldPosToChunkPos(newcoord)
	if(newcoord.z >= 0):
		objectunder = theworld.getReferenceMapValue(chunkdata.chunkx, chunkdata.chunky, chunkdata.z, chunkdata.y, chunkdata.x)
	return objectunder

func resetLastWorldPos():
	lastworldpos = myworldpos

func checkPointInside(pointpos):
	var poligonpoints = get_node("Body/Area2D/CollisionPolygon2D").get_polygon()
	var newpoligonpoints = []
	for p in poligonpoints:
		newpoligonpoints.append(Vector2(self.position.x + p[0], self.position.y + p[1] - (Globs.TILE_HEIGHT/2.0) * myworldpos.z))
	return Geometry2D.is_point_in_polygon(pointpos, newpoligonpoints)

func doSpawnIn():
	z_index = 999
	position = spawnindata[0]
	scale = Vector2.ZERO
	var distance = sqrt(pow(spawnindata[0].x - spawnindata[1].x, 2) + pow(spawnindata[0].y - spawnindata[1].y, 2))
	var timeittakes = distance/Globs.SPAWN_IN_SPEED
	var scaletween = get_tree().create_tween().set_ease(Tween.EASE_IN)
	var postween = get_tree().create_tween().set_ease(Tween.EASE_IN)
	self.scale = Vector2.ZERO
	self.position = spawnindata[0]
	scaletween.tween_property(self, "scale", Vector2.ONE, timeittakes)
	postween.tween_property(self, "position", spawnindata[1], timeittakes)
	postween.tween_callback(_onPosTweenEnd)

func _onPosTweenEnd():
	if(coinlike):
		SoundHandler.playSFX("Coinclink")
	else:
		SoundHandler.playSFX("Place")
	updatePosition(myworldpos)

func _ready():
	if(spawnindata):
		doSpawnIn()
	beRotated(myobjrot, true)

func _process(_delta):
	if(selected):
		var vectoritshouldbe = Vector2(Globs.WIDTH_IT_SHOULD_BE, Globs.HEIGHT_IT_SHOULD_BE)
		var newworldpos = Utils.globalPosToWorld(((get_viewport().get_mouse_position() - vectoritshouldbe/2) / camera.zoom) + vectoritshouldbe/2 + camera.position - vectoritshouldbe * 0.5)
		var zstacklevel = theworld.getZStackLevel(newworldpos)
		if(zstacklevel == -1):
			myworldpos = Vector3(newworldpos.x, newworldpos.y, Globs.MAP_SIZE.z)
			get_node("Body").modulate = Color(1,0,0)
		else:
			myworldpos = Vector3(newworldpos.x, newworldpos.y, zstacklevel)
			if(coinlike):
				get_node("Body").modulate = Color(1,1,1)
			else:
				get_node("Body").modulate = Color(0,1,0)
		if(getObjectUnder()):
			if(!getObjectUnder().isplaceableon):
				if(!(coinlike and getObjectUnder().coinlike)):
					get_node("Body").modulate = Color(1,0,0)
					canplace = false
			else:
				canplace = true
		else:
			canplace = true
		if(myworldpos == player.worldpos):
			canplace = false
		if(zstacklevel == -1):
			canplace = false
		#if(newworldpos.x < 0 or newworldpos.y < 0 or newworldpos.x > Globs.MAP_SIZE.x or newworldpos.y > Globs.MAP_SIZE.y):
			#get_node("Body").modulate = Color(1,0,0)
		updatePosition(myworldpos)
		if(!canplace):
			get_node("Body").modulate = Color(1,0,0)
