extends CharacterBody2D

@onready var feetcollider = get_node("CollisionShape2D")
@onready var mysprite = get_node("Sprite")
@onready var cinecam = get_node("Sprite/CinematicCamera")


var walking = false
var currentzlevel = 1
var building = false
var worldpos = Vector3.ZERO
var lastchunkvals = []

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
		playingintroanimation = Globs.newworld
	else:
		playingintroanimation = false
	if(playingintroanimation):
		get_node("ShadowSprite").visible = false
		cinecam.enabled = true
		get_tree().get_root().get_node("GameWorld/CanvasLayer/AnimationPlayer").play("CineCome")
		get_node("AnimationPlayer").play("Falling")
		mysprite.position = Vector2(0, -11800)
		donebouncing = false
	self.z_index = ceil((self.position.y + Globs.PLAYER_WALK_Z_OFFSET)/(Globs.TILE_HEIGHT/2.0)) * 10 + currentzlevel
	self.position = Vector2(Globs.worlddata.player.position.x, Globs.worlddata.player.position.y)
	updateWorldPos()

func updateVisibleChunks(chunkvals):
	var theworld = MouseController.theworld
	var ringofchunks = [{"cx": str(chunkvals[0]-1), "cy": str(chunkvals[1]-1)},
						{"cx": str(chunkvals[0]), "cy": str(chunkvals[1]-1)},
						{"cx": str(chunkvals[0]+1), "cy": str(chunkvals[1]-1)},
						{"cx": str(chunkvals[0]-1), "cy": str(chunkvals[1])},
						{"cx": str(chunkvals[0]), "cy": str(chunkvals[1])},
						{"cx": str(chunkvals[0]+1), "cy": str(chunkvals[1])},
						{"cx": str(chunkvals[0]-1), "cy": str(chunkvals[1]+1)},
						{"cx": str(chunkvals[0]), "cy": str(chunkvals[1]+1)},
						{"cx": str(chunkvals[0]+1), "cy": str(chunkvals[1]+1)}
						]
	#true means no match
	var indexeswithoutamatch = [true,true,true,true,true,true,true,true,true]
	for ck in theworld.visiblechunkkeys:
		var isinnewring = false
		var ringchunkindex = 0
		for chunkfromring in ringofchunks:
			if(chunkfromring.cx == ck.cx and chunkfromring.cy == ck.cy):
				isinnewring = true
				indexeswithoutamatch[ringchunkindex] = false
				break
			ringchunkindex += 1
		if(!isinnewring):
			theworld.setChunkVisibility(ck.cx, ck.cy, false)
	for idx in range(len(indexeswithoutamatch)):
		if(indexeswithoutamatch[idx] == true):
			theworld.setChunkVisibility(ringofchunks[idx].cx, ringofchunks[idx].cy, true)
	theworld.visiblechunkkeys = ringofchunks

func _physics_process(delta):
	
	if(playingintroanimation and donebouncing == false and startedbouncing == false):
		mysprite.position = Vector2(0, mysprite.position.y + Globs.PLAYER_FALL_SPEED)
		if(mysprite.position.y >= 0):
			if(!startedbouncing):
				startedbouncing = true
				mysprite.position = Vector2.ZERO
				get_tree().get_root().get_node("GameWorld/CanvasLayer/AnimationPlayer").play("CineGone")
				get_node("AnimationPlayer").play("Bounce")
	else:
		if(Globs.inworld):
			if(Input.get_action_strength("playerright") + Input.get_action_strength("playerleft") + Input.get_action_strength("playerdown") + Input.get_action_strength("playerup") != 0):
				setWalking(true)
			else:
				if(!MouseController.walkinghold):
					if(MouseController.thevoidcore.voidscript.triggers.FirstMoved):
						setWalking(false)
			if(walking):
				if(!MouseController.thevoidcore.voidscript.triggers.FirstMoved):
					MouseController.thevoidcore.voidscript.triggers.FirstMoved = true
					MouseController.thevoidcore.voidscript.updateFromTriggers()
				
				var mousecoords = get_viewport().get_mouse_position()
				var playerviewportcoords = feetcollider.get_global_transform_with_canvas().origin
				var walkvec = Vector2.ZERO
				if(MouseController.walkinghold):
					walkvec = Vector2(mousecoords.x - playerviewportcoords.x, mousecoords.y - playerviewportcoords.y).normalized()
				else:
					walkvec.x = Input.get_action_strength("playerright") - Input.get_action_strength("playerleft")
					walkvec.y = Input.get_action_strength("playerdown") - Input.get_action_strength("playerup")
					walkvec = walkvec.normalized()
				
				var newcpos = WorldCalculations.worldPosToChunkPos(Vector3(worldpos.x, worldpos.y, worldpos.z - 1))
				if(MouseController.theworld.getTheMapValue(newcpos.chunkx, newcpos.chunky, newcpos.z, newcpos.y, newcpos.x)):
						velocity = walkvec * Globs.WALK_SPEED * delta
						move_and_slide()
				updateWorldPos()
				

func updateWorldPos():
	var newworldpos = WorldCalculations.globalPosToWorldPos(self.position + feetcollider.position, true)
	worldpos = Vector3(newworldpos.x, newworldpos.y, currentzlevel)
	self.z_index = ceil((self.position.y + Globs.PLAYER_WALK_Z_OFFSET)/(Globs.TILE_HEIGHT/2.0)) * 10 + currentzlevel
	var newcpos = WorldCalculations.worldPosToChunkPos(worldpos)
	var newchunkvals = [int(newcpos.chunkx), int(newcpos.chunky)]
	
	if(newchunkvals != lastchunkvals):
		if(MouseController.theworld):
			lastchunkvals = newchunkvals
			updateVisibleChunks(newchunkvals)

func _on_TextureButton_pressed():
	if(!playingintroanimation):
		if(!walking):
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
		get_node("ShadowSprite").visible = true
	if(anim_name == "Bounce"):
		donebouncing = true
		mysprite.position = Vector2.ZERO
		MouseController.maincamera.enabled = true
		cinecam.enabled = false
		Globs.inworld = true
		MouseController.thevoidcore.voidscript.sayLine()
