extends KinematicBody2D

onready var feetcollider = get_node("CollisionShape2D")

var walking = false
var testy = true
var currentzlevel = 1
var building = false

func setWalking(iswalking):
	if(!building):
		walking = iswalking
		if(iswalking):
			get_node("AnimationPlayer").play("Run")
		else:
			get_node("AnimationPlayer").play("Idle")

func _ready():
	self.z_index = ceil((self.position.y + Constants.PLAYER_WALK_Z_OFFSET)/(Constants.TILE_HEIGHT/2)) * 10 + currentzlevel

func _physics_process(delta):
	if(walking):
		var mousecoords = get_viewport().get_mouse_position()
		var playerviewportcoords = feetcollider.get_global_transform_with_canvas().origin
		var walkvec = Vector2(mousecoords.x - playerviewportcoords.x, mousecoords.y - playerviewportcoords.y).normalized()
		move_and_slide(walkvec * Constants.WALK_SPEED * delta)
		self.z_index = ceil((self.position.y + Constants.PLAYER_WALK_Z_OFFSET)/(Constants.TILE_HEIGHT/2)) * 10 + currentzlevel


func _on_TextureButton_pressed():
	if(building):
		building = false
		get_node("AnimationPlayer").play("Idle")
	else:
		building = true
		get_node("AnimationPlayer").play("Build")
