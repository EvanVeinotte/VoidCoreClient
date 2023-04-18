
class_name WorldObject extends Node2D

export(Vector3) var worldpos = Vector3(0,0,0) setget calculateposition
export(int) var objecttypeid = 1
export(int) var objectid = 1
var ispickupable = true
var isplaceableon = true
var selected = false
var lastworldpos = worldpos
var canplace = true
var spawnin = false

onready var camera = get_tree().get_root().get_node("Main/Camera2D")
onready var myworld = get_tree().get_root().get_node("Main/World")
onready var player = get_tree().get_root().get_node("Main/World/YSort/Player")

onready var postween = get_node("Body/PosTween")
onready var scaletween = get_node("Body/ScaleTween")

func calculateposition(newworldpos):
	worldpos = newworldpos
	var newxpos = newworldpos.x * Constants.WORLD_X_OFFSET.x + newworldpos.y * Constants.WORLD_Y_OFFSET.x
	var newypos = newworldpos.x * Constants.WORLD_X_OFFSET.y + newworldpos.y * Constants.WORLD_Y_OFFSET.y
	self.position = Vector2(newxpos, newypos)
	var body = get_node("Body")
	body.position = Vector2(body.position.x, -(Constants.TILE_HEIGHT/2) * newworldpos.z)
	
	if(1 > newworldpos.z):
		#self.z_index = newworldpos.z
		self.z_index = ceil(self.position.y/(Constants.TILE_HEIGHT/2)) * 10 + newworldpos.z
	else:
		self.z_index = ceil(self.position.y/(Constants.TILE_HEIGHT/2)) * 10 + newworldpos.z

func getObjectUnder():
	var newcoord = Vector3(worldpos.x, worldpos.y, worldpos.z - 1)
	var objectunder
	if(myworld.checkIfWithinWorldMap(newcoord)):
		objectunder = myworld.referencemap[newcoord.z][newcoord.y][newcoord.x]
	return objectunder

func checkPointInside(pointpos):
	var poligonpoints = get_node("Body/Area2D/CollisionPolygon2D").get_polygon()
	var newpoligonpoints = []
	for p in poligonpoints:
		newpoligonpoints.append(Vector2(self.position.x + p[0], self.position.y + p[1] - (Constants.TILE_HEIGHT/2) * worldpos.z))
	return Geometry.is_point_in_polygon(pointpos, newpoligonpoints)

func beSelected():
	get_node("Body").modulate = Color(0,1,0)
	myworld.themap[lastworldpos.z][lastworldpos.y][lastworldpos.x] = 0
	myworld.referencemap[lastworldpos.z][lastworldpos.y][lastworldpos.x] = 0
	myworld.objectPickedUp(self)
	selected = true
	MouseController.selectednode = self

func beDeselected():
	get_node("Body").modulate = Color(1,1,1)
	selected = false
	myworld.newObjectPlaced(self, !canplace)

func setLastWorldPos():
	lastworldpos = worldpos

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
		get_node("Body/StaticBody2D").position = Vector2(0, Constants.FLOOR_BOTTOM_COLLIDER_Y)
	else:
		get_node("Body/StaticBody2D").position = Vector2(0, 0)

func doSpawnIn():
	print("ok")
	z_index = 999
	position = spawnin[0]
	scale = Vector2.ZERO
	var distance = sqrt(pow(spawnin[0].x - spawnin[1].x, 2) + pow(spawnin[0].y - spawnin[1].y, 2))
	var timeittakes = distance/Constants.SPAWN_IN_SPEED
	scaletween.interpolate_property(self, "scale", Vector2.ZERO, Vector2.ONE, timeittakes, Tween.TRANS_LINEAR, Tween.EASE_IN)
	postween.interpolate_property(self, "position", spawnin[0], spawnin[1], timeittakes, Tween.TRANS_LINEAR, Tween.EASE_IN)
	scaletween.start()
	postween.start()

func _onPosTweenEnd():
	calculateposition(worldpos)

func _ready():
	get_node("Body/PosTween").connect("tween_all_completed", self, "_onPosTweenEnd")
	if(spawnin):
		doSpawnIn()

func _process(_delta):
	if(selected):
		var vectoritshouldbe = Vector2(Constants.WIDTH_IT_SHOULD_BE, Constants.HEIGHT_IT_SHOULD_BE)
		var newworldpos = Constants.globalPosToWorld(((get_viewport().get_mouse_position() - vectoritshouldbe/2) * camera.zoom) + vectoritshouldbe/2 + camera.position - vectoritshouldbe * 0.5)
		var zstacklevel = myworld.getZStackLevel(newworldpos)
		if(zstacklevel == -1):
			worldpos = Vector3(newworldpos.x, newworldpos.y, Constants.MAP_SIZE.z)
			get_node("Body").modulate = Color(1,0,0)

		else:
			worldpos = Vector3(newworldpos.x, newworldpos.y, zstacklevel)
			if(objecttypeid == 5):
				get_node("Body").modulate = Color(1,1,1)
			else:
				get_node("Body").modulate = Color(0,1,0)
		
		if(getObjectUnder()):
			if(!getObjectUnder().isplaceableon):
				if(!(objecttypeid == 5 and getObjectUnder().objecttypeid == 5)):
					get_node("Body").modulate = Color(1,0,0)
					canplace = false
			else:
				canplace = true
		else:
			canplace = true
		
		if(newworldpos.x < 0 or newworldpos.y < 0 or newworldpos.x > Constants.MAP_SIZE.x or newworldpos.y > Constants.MAP_SIZE.y):
			get_node("Body").modulate = Color(1,0,0)
		
		calculateposition(worldpos)
		
		if(!canplace):
			get_node("Body").modulate = Color(1,0,0)
			
		
