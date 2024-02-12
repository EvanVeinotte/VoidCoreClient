extends WorldObject

@onready var whitespinner1 = get_node("Body/TheBall/WhiteSpinner/Sprite1")
@onready var whitespinner2 = get_node("Body/TheBall/WhiteSpinner/Sprite2")
@onready var whitespinner3 = get_node("Body/TheBall/WhiteSpinner/Sprite3")
@onready var animationplayer = get_node("AnimationPlayer")
@onready var voidscript = get_node("Body/TheBall")

var howmuchessence = 0
var itemspawntimer = 0
var spawningitem = false

var totalessencefed = 0
var totalitemsspawned = 0

func setSouthCol(_whattosetto):
	get_node("Body/StaticBody2D/southcol").disabled = false

func setNorthCol(_whattosetto):
	get_node("Body/StaticBody2D/northcol").disabled = false

func setEastCol(_whattosetto):
	get_node("Body/StaticBody2D/eastcol").disabled = false

func setWestCol(_whattosetto):
	get_node("Body/StaticBody2D/westcol").disabled = false

func setCollidersBottom(settobottom):
	if(settobottom):
		get_node("Body/StaticBody2D").position = Vector2(0, Globs.FLOOR_BOTTOM_COLLIDER_Y)
	else:
		get_node("Body/StaticBody2D").position = Vector2(0, 0)

func _ready():
	canrotate = false
	isplaceableon = false
	floorlike = true
	super()
	updateEssence(howmuchessence)

func updateEssence(newessence):
	get_node("Body/TheBall/Hungry").scale = Vector2(1,1)
	howmuchessence = newessence
	
	if(howmuchessence > 0):
		SoundHandler.playSFX("VoidInput")
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
	super(delta)
	if(spawningitem):
		itemspawntimer += delta
		animationplayer.speed_scale = 1 + itemspawntimer * 10
		
		if(itemspawntimer >= 1):
			itemspawntimer = 0
			spawningitem = false
			animationplayer.speed_scale = 1
			updateEssence(0)
			var postoplace = theworld.getPlaceableWorldPosRing(myworldpos)
			if(postoplace):
				SoundHandler.playSFX("VoidOutput")
				var newxpos = postoplace.x * Globs.WORLD_X_OFFSET.x + postoplace.y * Globs.WORLD_Y_OFFSET.x
				var newypos = postoplace.x * Globs.WORLD_X_OFFSET.y + postoplace.y * Globs.WORLD_Y_OFFSET.y
				var voidcenterpos = get_node("Body/TheBall/Highlighter").get_global_position()
				var newlootdata = LootTable.getRandomLoot("basic")
				var thisobjectid = Utils.getObjectValue(newlootdata, "object_id")
				var thisobjectstate = Utils.getObjectValue(newlootdata, "object_state")
				var thisobjectrotation = Utils.getObjectValue(newlootdata, "object_rotation")
				theworld.voiditemcount += 1
				theworld.instantiateNewObject(postoplace, thisobjectid, thisobjectstate, thisobjectrotation, true, [voidcenterpos, Vector2(newxpos, newypos)])
			else:
				print("no pos to place in")


func _on_PlayerSensor_body_entered(body):
	if(body.get_name() == "Player"):
		if(SettingsMenu.settingsdata.tutorialenabled):
			if(voidscript.triggers.PHASETWO or Globs.newworld == false):
				get_node("Body/TheBall/Highlighter").visible = true
				MouseController.activeclickables.append(self)
		else:
			get_node("Body/TheBall/Highlighter").visible = true
			MouseController.activeclickables.append(self)


func _on_PlayerSensor_body_exited(body):
	if(body.get_name() == "Player"):
		if(SettingsMenu.settingsdata.tutorialenabled):
			if(voidscript.triggers.PHASETWO or Globs.newworld == false):
				get_node("Body/TheBall/Highlighter").visible = false
				MouseController.activeclickables.erase(self)
		else:
			get_node("Body/TheBall/Highlighter").visible = false
			MouseController.activeclickables.erase(self)

func doActiveAction():
	MouseController.thevoidcore.voidscript.triggers.DidPause = true
	MouseController.thevoidcore.voidscript.updateFromTriggers()
	get_tree().get_root().get_node("GameWorld/CanvasLayer/PauseMenu").openPauseMenu()
