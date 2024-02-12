extends WorldObject

@onready var uploadmenu = load("res://Scenes/Menus/upload_dimension_menu.tscn")

var valid = false
var firstvalidcheck = true


func _ready():
	isplaceableon = false
	super()

func beRotated(settovalue=null, _initset=false):
	if(canrotate):
		if(settovalue != null):
			get_node("Body/Sprite").flip_h = bool(settovalue)
			myobjrot = bool(settovalue)
			get_node("Body/Highlight").flip_h = get_node("Body/Sprite").flip_h
		else:
			get_node("Body/Sprite").flip_h = !get_node("Body/Sprite").flip_h
			myobjrot = get_node("Body/Sprite").flip_h
			get_node("Body/Highlight").flip_h = get_node("Body/Sprite").flip_h
		if(get_node("Body/Sprite").hframes == 2):
			get_node("Body/Sprite").frame = int(myobjrot)
			get_node("Body/Indicators").frame = int(myobjrot)
			updatePosition(myworldpos)
		theworld.newObjectPlaced(self)

func updatePosition(newworldpos):
	super(newworldpos)
	checkIfSpawnTile()

func checkIfSpawnTile():
	var xoff
	var yoff
	if(int(myobjrot) == 0):
		xoff = 0
		yoff = 1
	elif(int(myobjrot) == 1):
		xoff = 1
		yoff = 0
	
	var cpos = WorldCalculations.worldPosToChunkPos(myworldpos + Vector3(xoff, yoff, 0))
	var spawntile = theworld.getTheMapValue(cpos.chunkx, cpos.chunky, cpos.z - 1, cpos.y, cpos.x)
	if(spawntile):
		setValid()
	else:
		setInvalid()

func doActiveAction():
	Globs.inworld = false
	var newuploadmenu = uploadmenu.instantiate()
	newuploadmenu.valid = valid
	get_tree().get_root().get_node("GameWorld/CanvasLayer").add_child(newuploadmenu)



func setValid():
	if(valid == false and firstvalidcheck == false):
		SoundHandler.playSFX("IndicateCorrect")
	get_node("Body/Indicators").modulate = Color(0,1,0)
	valid = true
	firstvalidcheck = false

func setInvalid():
	if(valid == true and firstvalidcheck == false):
		SoundHandler.playSFX("IndicateIncorrect")
	get_node("Body/Indicators").modulate = Color(1,0,0)
	valid = false
	firstvalidcheck = false


func _on_area_2d_body_entered(body):
	if(body.get_name() == "Player" and Globs.thisworldismine):
		get_node("Body/Highlight").visible = true
		MouseController.activeclickables.append(self)


func _on_area_2d_body_exited(body):
	if(body.get_name() == "Player" and Globs.thisworldismine):
		get_node("Body/Highlight").visible = false
		MouseController.activeclickables.erase(self)



