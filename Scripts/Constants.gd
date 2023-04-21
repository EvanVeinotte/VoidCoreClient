extends Node

const TILE_WIDTH = 300
const TILE_HEIGHT = 150
var SCREEN_SIZE = Vector2.ZERO
const WORLD_X_OFFSET = Vector2(TILE_WIDTH/2, TILE_HEIGHT/2)
const WORLD_Y_OFFSET = Vector2(-TILE_WIDTH/2, TILE_HEIGHT/2)
const WORLD_Z_OFFSET = Vector2(0, -TILE_HEIGHT/2)
const HOLD_UNTIL_WALK = 0.1
const WALK_SPEED = 16000
const MAP_SIZE = Vector3(16,16,3)
const FLOOR_BOTTOM_COLLIDER_Y = 60
const PLAYER_WALK_Z_OFFSET = 55

const WIDTH_IT_SHOULD_BE = 1920
const HEIGHT_IT_SHOULD_BE = 1080

const CAMERA_ZOOM_MAX = 4
const CAMERA_ZOOM_MIN = 0.2

const COIN_STACK_LIMIT = 5
const COIN_LYING_HEIGHT = 21

const SPAWN_IN_SPEED = 3000

const GAME_WINDOW_TIME = 1
const ESSENCE_SPAWN_DELAY = 0.5

var inworld = true

func _ready():
	SCREEN_SIZE = get_viewport().size
	get_tree().get_root().connect("size_changed", self, "sizeChanged")
	if(OS.get_name() != "Android"):
		SCREEN_SIZE *= 2
	
	print(getEncodedValue(3, 6, 3))

func sizeChanged():
	#print(SCREEN_SIZE, get_tree().get_root().get_node("Main/Camera2D").position)

	SCREEN_SIZE = get_viewport().size
	#print(SCREEN_SIZE, get_tree().get_root().get_node("Main/Camera2D").position)

func getEncodedValue(encoded, startpos, endpos):
	var endposdivider = pow(10, endpos)
	var startposdivider = pow(10, startpos)
	var withstartposremoved = encoded - floor(encoded/startposdivider) * startposdivider
	var finalvalue = floor(withstartposremoved/endposdivider)
	return finalvalue

func encodeForMap(objecttypeid, objectid, isrotated, extradata=0):
	var encodedvalue = isrotated * 10000000000 + extradata * 10000000 + objectid * 1000 + objecttypeid
	return encodedvalue

func globalPosToWorld(globpos):
	#added so mouse is in middle
	globpos = Vector2(globpos.x - TILE_WIDTH/2, globpos.y)
	var worldxpos
	var worldypos
	worldxpos = (-globpos.x * WORLD_Y_OFFSET.y + WORLD_Y_OFFSET.x * globpos.y) / (WORLD_Y_OFFSET.x * WORLD_X_OFFSET.y - WORLD_Y_OFFSET.y * WORLD_X_OFFSET.x)
	worldypos = (-globpos.x * WORLD_X_OFFSET.y + WORLD_X_OFFSET.x * globpos.y) / (WORLD_X_OFFSET.x * WORLD_Y_OFFSET.y - WORLD_X_OFFSET.y * WORLD_Y_OFFSET.x)
	worldxpos = floor(worldxpos)
	worldypos = floor(worldypos)
	return Vector3(worldxpos, worldypos, 0)
