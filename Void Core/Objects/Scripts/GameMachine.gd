extends WorldObject

@export var mycointype = 0

var essenceinside = 0
var isspawning = false

func _ready():
	isplaceableon = false
	super()
	

func beRotated(settovalue=null, initset=false):
	if(canrotate):
		if(!initset):
			if(!MouseController.thevoidcore.voidscript.triggers.RotatedMachine):
				MouseController.thevoidcore.voidscript.triggers.RotatedMachine = true
				MouseController.thevoidcore.voidscript.updateFromTriggers()
		if(settovalue != null):
			myobjrot = bool(settovalue)
			get_node("Body/Sprite").frame = int(myobjrot)
			get_node("Body/Sprite").flip_h = bool(settovalue)
			get_node("Body/ScreenSprite").flip_h = get_node("Body/Sprite").flip_h
			get_node("Body/Highlight").flip_h = get_node("Body/Sprite").flip_h
			var newscale = 1 - int(settovalue) * 2
			get_node("Body/PlayerSensor").scale = Vector2(newscale, 1)
			theworld.newObjectPlaced(self)
		else:
			get_node("Body/Sprite").flip_h = !get_node("Body/Sprite").flip_h
			myobjrot = get_node("Body/Sprite").flip_h
			get_node("Body/Sprite").frame = int(myobjrot)
			get_node("Body/ScreenSprite").flip_h = get_node("Body/Sprite").flip_h
			get_node("Body/Highlight").flip_h = get_node("Body/Sprite").flip_h
			get_node("Body/PlayerSensor").scale = Vector2(get_node("Body/PlayerSensor").scale.x * -1, 1)
			theworld.newObjectPlaced(self)

func doActiveAction():
	MouseController.thevoidcore.voidscript.triggers.GameEntered = true
	MouseController.thevoidcore.voidscript.updateFromTriggers()
	get_tree().get_root().get_node("GameWorld/Minigame").currentgamemachine = self
	get_tree().get_root().get_node("GameWorld/Minigame").openGameWindow(myobjid)

func _on_PlayerSensor_body_entered(body):
	if(body.get_name() == "Player"):
		get_node("Body/Highlight").visible = true
		MouseController.activeclickables.append(self)
		MouseController.thevoidcore.voidscript.triggers.CloseToTheMachine = true
		MouseController.thevoidcore.voidscript.updateFromTriggers()


func _on_PlayerSensor_body_exited(body):
	if(body.get_name() == "Player"):
		get_node("Body/Highlight").visible = false
		MouseController.activeclickables.erase(self)


func _process(delta):
	super(delta)
	if(!isspawning):
		if(essenceinside > 0):
			var essencetospawn = int(essenceinside) % 5
			if(essencetospawn == 0):
				essencetospawn = 5
			essenceinside -= essencetospawn
			var postoplace = theworld.getPlaceableWorldPosRing(myworldpos)
			if(postoplace):
				MouseController.thevoidcore.voidscript.triggers.EssenceEarned = true
				MouseController.thevoidcore.voidscript.updateFromTriggers()
				var newxpos = postoplace.x * Globs.WORLD_X_OFFSET.x + postoplace.y * Globs.WORLD_Y_OFFSET.x
				var newypos = postoplace.x * Globs.WORLD_X_OFFSET.y + postoplace.y * Globs.WORLD_Y_OFFSET.y
				var gamemachinecenterpos = get_node("Body/PlayerSensor").get_global_position()
				var newlootid = essencetospawn * 100000 + mycointype
				var thisobjectid = Utils.getObjectValue(newlootid, "object_id")
				var statedata = Utils.getObjectValue(newlootid, "object_state")
				theworld.instantiateNewObject(postoplace, thisobjectid, statedata, false, true, [gamemachinecenterpos, Vector2(newxpos, newypos)])
				isspawning = true
				get_node("EssenceSpawnTimer").start(Globs.ESSENCE_SPAWN_DELAY)
			else:
				essenceinside = 0
				print("no pos to place in")


func _on_EssenceSpawnTimer_timeout():
	isspawning = false
