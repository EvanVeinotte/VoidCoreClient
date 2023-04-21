extends WorldObject

const listofskins = [null, "res://Images/GameMachines/basicgamemachine.png"]

var essenceinside = 0
var isspawning = false

func setSouthCol(whattosetto):
	get_node("Body/StaticBody2D/southcol").disabled = false

func setNorthCol(whattosetto):
	get_node("Body/StaticBody2D/northcol").disabled = false

func setEastCol(whattosetto):
	get_node("Body/StaticBody2D/eastcol").disabled = false

func setWestCol(whattosetto):
	get_node("Body/StaticBody2D/westcol").disabled = false

func setCollidersBottom(settobottom):
	pass

func _ready():
	objecttypeid = 6
	isplaceableon = false

func beRotated(settovalue=null):
	if(canrotate):
		if(settovalue):
			get_node("Body/Sprite").flip_h = bool(settovalue)
			get_node("Body/ScreenSprite").flip_h = get_node("Body/Sprite").flip_h
			get_node("Body/Highlight").flip_h = get_node("Body/Sprite").flip_h
			var newscale = 1 - int(settovalue) * 2
			get_node("Body/PlayerSensor").scale = Vector2(newscale, 1)
			isrotated = bool(settovalue)
			myworld.newObjectPlaced(self)
		else:
			get_node("Body/Sprite").flip_h = !get_node("Body/Sprite").flip_h
			get_node("Body/ScreenSprite").flip_h = get_node("Body/Sprite").flip_h
			get_node("Body/Highlight").flip_h = get_node("Body/Sprite").flip_h
			get_node("Body/PlayerSensor").scale = Vector2(get_node("Body/PlayerSensor").scale.x * -1, 1)
			isrotated = get_node("Body/Sprite").flip_h
			myworld.newObjectPlaced(self)

func setObject(newobjectid):
	objectid = newobjectid
	if(objectid < len(listofskins) and objectid > 0):
		get_node("Body/Sprite").flip_h = bool(isrotated)
		get_node("Body/ScreenSprite").flip_h = get_node("Body/Sprite").flip_h
		get_node("Body/Highlight").flip_h = get_node("Body/Sprite").flip_h
		var newscale = 1 - int(isrotated) * 2
		get_node("Body/PlayerSensor").scale = Vector2(newscale, 1)
		get_node("Body/Sprite").texture = load(listofskins[objectid])

func doActiveAction():
	print("PLAY")
	camera.get_node("MiniGame").currentgamemachine = self
	camera.get_node("MiniGame").openGameWindow(objectid - 1)

func _on_PlayerSensor_body_entered(body):
	if(body.get_name() == "Player"):
		get_node("Body/Highlight").visible = true
		MouseController.activeclickables.append(self)


func _on_PlayerSensor_body_exited(body):
	if(body.get_name() == "Player"):
		get_node("Body/Highlight").visible = false
		MouseController.activeclickables.erase(self)

func _process(delta):
	
	if(!isspawning):
		if(essenceinside > 0):
			var essencetospawn = int(essenceinside) % 5
			if(essencetospawn == 0):
				essencetospawn = 5
			essenceinside -= essencetospawn
			var postoplace = myworld.getPlaceableWorldPosRing(worldpos)
			if(postoplace):
				var newxpos = postoplace.x * Constants.WORLD_X_OFFSET.x + postoplace.y * Constants.WORLD_Y_OFFSET.x
				var newypos = postoplace.x * Constants.WORLD_X_OFFSET.y + postoplace.y * Constants.WORLD_Y_OFFSET.y
				var gamemachinecenterpos = get_node("Body/PlayerSensor").get_global_position()
				var newlootid = essencetospawn * 10000000 + 1005
				var thisobjecttypeid = Constants.getEncodedValue(newlootid, 3, 0)
				var thisobjectid = Constants.getEncodedValue(newlootid, 7, 3)
				var extradata = Constants.getEncodedValue(newlootid, 10, 7)
				var isrotated = Constants.getEncodedValue(newlootid, 11, 10)
				print(newlootid)
				myworld.instantiateNewObject(postoplace, thisobjecttypeid, thisobjectid, extradata, isrotated, true, [gamemachinecenterpos, Vector2(newxpos, newypos)])
				isspawning = true
				get_node("EssenceSpawnTimer").start(Constants.ESSENCE_SPAWN_DELAY)
			else:
				essenceinside = 0
				print("no pos to place in")


func _on_EssenceSpawnTimer_timeout():
	isspawning = false
