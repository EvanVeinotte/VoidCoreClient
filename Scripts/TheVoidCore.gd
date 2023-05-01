extends WorldObject

onready var whitespinner1 = get_node("Body/TheBall/WhiteSpinner/Sprite1")
onready var whitespinner2 = get_node("Body/TheBall/WhiteSpinner/Sprite2")
onready var whitespinner3 = get_node("Body/TheBall/WhiteSpinner/Sprite3")
onready var animationplayer = get_node("AnimationPlayer")
onready var voidscript = get_node("Body/TheBall")

var howmuchessence = 0
var itemspawntimer = 0
var spawningitem = false

var totalessencefed = 0
var totalitemsspawned = 0

func setSouthCol(whattosetto):
	get_node("Body/StaticBody2D/southcol").disabled = false

func setNorthCol(whattosetto):
	get_node("Body/StaticBody2D/northcol").disabled = false

func setEastCol(whattosetto):
	get_node("Body/StaticBody2D/eastcol").disabled = false

func setWestCol(whattosetto):
	get_node("Body/StaticBody2D/westcol").disabled = false

func checkPointInside(pointpos):
	var poligonpoints = get_node("Body/Area2D/CollisionPolygon2D").get_polygon()
	var newpoligonpoints = []
	for p in poligonpoints:
		newpoligonpoints.append(Vector2(self.position.x + p[0], self.position.y + p[1] - (Constants.TILE_HEIGHT/2) * worldpos.z))
	return Geometry.is_point_in_polygon(pointpos, newpoligonpoints)

func _ready():
	objecttypeid = 4
	canrotate = false
	isplaceableon = false
	updateEssence(howmuchessence)

func setObject(objectid):
	pass

func updateEssence(newessence):
	get_node("Body/TheBall/Hungry").scale = Vector2(1,1)
	howmuchessence = newessence
	
	if(howmuchessence > 0):
		SoundHandler.playSFX("voidinput")
	if(howmuchessence == 0):
		whitespinner1.visible = false
		whitespinner2.visible = false
		whitespinner3.visible = false
	if(howmuchessence == 1):
		whitespinner1.visible = true
		whitespinner2.visible = false
		whitespinner3.visible = false
		totalessencefed = 1 + totalitemsspawned * 3
		voidscript.triggers.TotalEssenceFed = totalessencefed
		voidscript.updateFromTriggers()
	if(howmuchessence == 2):
		whitespinner1.visible = true
		whitespinner2.visible = true
		whitespinner3.visible = false
		totalessencefed = 2 + totalitemsspawned * 3
		voidscript.triggers.TotalEssenceFed = totalessencefed
		voidscript.updateFromTriggers()
	if(howmuchessence == 3):
		whitespinner1.visible = true
		whitespinner2.visible = true
		whitespinner3.visible = true
		totalessencefed = 3 + totalitemsspawned * 3
		voidscript.triggers.TotalEssenceFed = totalessencefed
		voidscript.updateFromTriggers()
		spawningitem = true
		totalitemsspawned += 1
	

func _process(delta):
	if(spawningitem):
		itemspawntimer += delta
		animationplayer.playback_speed = 1 + itemspawntimer * 10
		
		if(itemspawntimer >= 1):
			itemspawntimer = 0
			spawningitem = false
			animationplayer.playback_speed = 1
			updateEssence(0)
			var postoplace = myworld.getPlaceableWorldPosRing(worldpos)
			if(postoplace):
				SoundHandler.playSFX("voidoutput")
				var newxpos = postoplace.x * Constants.WORLD_X_OFFSET.x + postoplace.y * Constants.WORLD_Y_OFFSET.x
				var newypos = postoplace.x * Constants.WORLD_X_OFFSET.y + postoplace.y * Constants.WORLD_Y_OFFSET.y
				var voidcenterpos = get_node("Body/TheBall/Highlighter").get_global_position()
				var newlootid = LootTable.getRandomLoot("basic")
				var thisobjecttypeid = Constants.getEncodedValue(newlootid, 3, 0)
				var thisobjectid = Constants.getEncodedValue(newlootid, 7, 3)
				var extradata = Constants.getEncodedValue(newlootid, 10, 7)
				var isrotated = Constants.getEncodedValue(newlootid, 11, 10)
				myworld.instantiateNewObject(postoplace, thisobjecttypeid, thisobjectid, extradata, isrotated, true, [voidcenterpos, Vector2(newxpos, newypos)])
			else:
				print("no pos to place in")


func _on_PlayerSensor_body_entered(body):
	if(body.get_name() == "Player"):
		if(SettingsMenu.settingsdata.tutorialenabled):
			if(voidscript.triggers.PHASETWO or Constants.newworld == false):
				get_node("Body/TheBall/Highlighter").visible = true
				MouseController.activeclickables.append(self)
		else:
			get_node("Body/TheBall/Highlighter").visible = true
			MouseController.activeclickables.append(self)


func _on_PlayerSensor_body_exited(body):
	if(body.get_name() == "Player"):
		if(SettingsMenu.settingsdata.tutorialenabled):
			if(voidscript.triggers.PHASETWO or Constants.newworld == false):
				get_node("Body/TheBall/Highlighter").visible = false
				MouseController.activeclickables.erase(self)
		else:
			get_node("Body/TheBall/Highlighter").visible = false
			MouseController.activeclickables.erase(self)

func doActiveAction():
	print("PAUSE")
	MouseController.thevoidcore.voidscript.triggers.DidPause = true
	MouseController.thevoidcore.voidscript.updateFromTriggers()
	get_tree().get_root().get_node("Main/CanvasLayer/PauseMenu").openPauseMenu()
