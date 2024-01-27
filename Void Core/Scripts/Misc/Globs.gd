extends Node

const CHUNK_SIZE = 16
const TILE_WIDTH = 300
const TILE_HEIGHT = 150
var SCREEN_SIZE = Vector2.ZERO
const WORLD_X_OFFSET = Vector2(TILE_WIDTH/2.0, TILE_HEIGHT/2.0)
const WORLD_Y_OFFSET = Vector2(-TILE_WIDTH/2.0, TILE_HEIGHT/2.0)
const WORLD_Z_OFFSET = Vector2(0, -TILE_HEIGHT/2.0)
const HOLD_UNTIL_WALK = 0.15
const WALK_SPEED = 16000
const MAP_SIZE = Vector3(16,16,3)
const FLOOR_BOTTOM_COLLIDER_Y = 60
const PLAYER_WALK_Z_OFFSET = 55

const WIDTH_IT_SHOULD_BE = 1920
const HEIGHT_IT_SHOULD_BE = 1080

const CAMERA_ZOOM_MAX = 4
const CAMERA_ZOOM_MIN = 0.5

const COIN_STACK_LIMIT = 5
const COIN_LYING_HEIGHT = 21

const SPAWN_IN_SPEED = 3000

const GAME_WINDOW_TIME = 1
const ESSENCE_SPAWN_DELAY = 0.5

const SPEECH_BOX_LETTER_SPEED = 0.1
const SPEECH_BOX_SPEED = 2

const PLAYER_FALL_SPEED = 20

var inworld = false
var newworld
var worlddata

var DEVICE_TYPE

#for debugging
const skiptogame = false
