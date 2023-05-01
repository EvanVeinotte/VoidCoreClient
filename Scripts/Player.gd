extends KinematicBody2D

onready var feetcollider = get_node("CollisionShape2D")
onready var mysprite = get_node("Sprite")
onready var cinecam = get_node("Sprite/CinematicCamera")

var walking = false
var testy = true
var currentzlevel = 1
var building = false
var worldpos = Vector3.ZERO

var firstbuild = true

var playingintroanimation = false
var startedbouncing = false
var donebouncing = true


func setWalking(iswalking):
	if(!playingintroanimation):
		if(!building):
			walking = iswalking
			if(iswalking):
				get_node("AnimationPlayer").play("Run")
			else:
				get_node("AnimationPlayer").play("Idle")
	else:
		if(donebouncing):
			get_node("AnimationPlayer").play("GetUp")

func _ready():
	if(SettingsMenu.settingsdata.tutorialenabled):
		playingintroanimation = Constants.newworld
	else:
		playingintroanimation = false
	if(playingintroanimation):
		cinecam.current = true
		print("hello")
		get_tree().get_root().get_node("Main/CanvasLayer/AnimationPlayer").play("CineCome")
		get_node("AnimationPlayer").play("Falling")
		mysprite.position = Vector2(0, -11800)
		donebouncing = false
	self.z_index = ceil((self.position.y + Constants.PLAYER_WALK_Z_OFFSET)/(Constants.TILE_HEIGHT/2)) * 10 + currentzlevel

func _physics_process(delta):
	if(playingintroanimation and donebouncing == false):
		mysprite.position = Vector2(0, mysprite.position.y + Constants.PLAYER_FALL_SPEED)
		if(mysprite.position.y >= 0):
			if(!startedbouncing):
				startedbouncing = true
				mysprite.position = Vector2.ZERO
				get_tree().get_root().get_node("Main/CanvasLayer/AnimationPlayer").play("CineGone")
				get_node("AnimationPlayer").play("Bounce")
	elif(walking):
		if(!MouseController.thevoidcore.voidscript.triggers.FirstMoved):
			MouseController.thevoidcore.voidscript.triggers.FirstMoved = true
			MouseController.thevoidcore.voidscript.updateFromTriggers()
		var mousecoords = get_viewport().get_mouse_position()
		var playerviewportcoords = feetcollider.get_global_transform_with_canvas().origin
		var walkvec = Vector2(mousecoords.x - playerviewportcoords.x, mousecoords.y - playerviewportcoords.y).normalized()
		if(MouseController.myworld.themap[worldpos.z-1][worldpos.y][worldpos.x]):
			move_and_slide(walkvec * Constants.WALK_SPEED * delta)
		updateWorldPos()
		self.z_index = ceil((self.position.y + Constants.PLAYER_WALK_Z_OFFSET)/(Constants.TILE_HEIGHT/2)) * 10 + currentzlevel

func updateWorldPos():
	var newworldpos = Constants.globalPosToWorld(self.position + feetcollider.position)
	worldpos = Vector3(newworldpos.x, newworldpos.y, currentzlevel)

func _on_TextureButton_pressed():
	if(!playingintroanimation):
		if(building):
			building = false
			get_node("AnimationPlayer").play("Idle")
		else:
			if(firstbuild):
				firstbuild = false
				MouseController.thevoidcore.voidscript.triggers.FirstBuildModeEntered = true
				MouseController.thevoidcore.voidscript.updateFromTriggers()
			building = true
			get_node("AnimationPlayer").play("Build")


func _on_AnimationPlayer_animation_finished(anim_name):
	if(anim_name == "GetUp"):
		get_node("AnimationPlayer").play("Idle")
		playingintroanimation = false
	if(anim_name == "Bounce"):
		donebouncing = true
		MouseController.camera.current = true
		Constants.inworld = true
		MouseController.thevoidcore.voidscript.sayLine()
