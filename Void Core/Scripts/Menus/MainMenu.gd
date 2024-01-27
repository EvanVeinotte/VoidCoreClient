extends Control

@onready var menuoptions = get_node("MenuOptions")
@onready var playoptions = get_node("PlayOptions")
@onready var areyousureoptions = get_node("AreYouSureOptions")


@onready var worldscene = load("res://Scenes/Main.tscn")

var displaylabeltween

var newworld = false

var worldaddresstoload
var worldaddresstodelete

func _ready():
	if(Globs.skiptogame):
		_on_play_world_1_button_pressed()
	updatePlayWorldButton()

func ShowComingSoonLabel():
	if(displaylabeltween):
		displaylabeltween.kill()
	displaylabeltween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_LINEAR)
	get_node("MenuOptions/ComingSoon").modulate = Color(1,1,1,1)
	displaylabeltween.tween_property(get_node("MenuOptions/ComingSoon"), "modulate", Color(1,1,1,0), 3)

func updatePlayWorldButton():
	var world1exists = FileHandler.checkIfWorldFileExists("user://World1.tres")
	var world2exists = FileHandler.checkIfWorldFileExists("user://World2.tres")
	var world3exists = FileHandler.checkIfWorldFileExists("user://World3.tres")
	
	if(world1exists):
		playoptions.get_node("PlayWorld1Button").text = "Load World 1"
		playoptions.get_node("PlayWorld1Button/TrashButton1").visible = true
	else:
		playoptions.get_node("PlayWorld1Button").text = "New World 1"
		playoptions.get_node("PlayWorld1Button/TrashButton1").visible = false
	
	if(world2exists):
		playoptions.get_node("PlayWorld2Button").text = "Load World 2"
		playoptions.get_node("PlayWorld2Button/TrashButton2").visible = true
	else:
		playoptions.get_node("PlayWorld2Button").text = "New World 2"
		playoptions.get_node("PlayWorld2Button/TrashButton2").visible = false
	
	if(world3exists):
		playoptions.get_node("PlayWorld3Button").text = "Load World 3"
		playoptions.get_node("PlayWorld3Button/TrashButton3").visible = true
	else:
		playoptions.get_node("PlayWorld3Button").text = "New World 3"
		playoptions.get_node("PlayWorld3Button/TrashButton3").visible = false

func _on_PlayButton_pressed():
	SoundHandler.playSFX("ButtonSound")
	menuoptions.visible = false
	playoptions.visible = true

func _on_MultiplayerButton_pressed():
	SoundHandler.playSFX("ButtonSound")
	ShowComingSoonLabel()


func _on_DimensionsButton_pressed():
	SoundHandler.playSFX("ButtonSound")
	ShowComingSoonLabel()


func _on_ExitGameButton_pressed():
	SoundHandler.playSFX("ButtonSound")
	get_tree().quit()


func _on_BackButton_pressed():
	SoundHandler.playSFX("ButtonSound")
	menuoptions.visible = true
	playoptions.visible = false


func _on_SettingsBut_pressed():
	SoundHandler.playSFX("ButtonSound")
	SettingsMenu.setToFront()


func _on_NoNotSure_pressed():
	SoundHandler.playSFX("ButtonSound")
	playoptions.visible = true
	areyousureoptions.visible = false


func _on_YesImSure_pressed():
	SoundHandler.playSFX("ButtonSound")
	FileHandler.deleteFile(worldaddresstodelete)
	updatePlayWorldButton()
	playoptions.visible = true
	areyousureoptions.visible = false


func _on_loading_screen_timer_timeout():
	var makenewworld = FileHandler.checkIfWorldFileExists(worldaddresstoload)
	var newworlddata
	if(makenewworld):
		newworlddata = FileHandler.loadNewWorld(worldaddresstoload)
	else:
		newworlddata = FileHandler.loadWorldFromFile(worldaddresstoload)
	var worldinstance = worldscene.instance()
	Globs.worlddata = newworlddata
	Utils.checkIfNewWorld()
	Utils.checkIfIntroCutscene()
	Globs.inworld = true
	get_tree().get_root().add_child(worldinstance)
	queue_free()


func _on_play_world_1_button_pressed():
	worldaddresstoload = "user://World1.tres"
	SoundHandler.playSFX("ButtonSound")
	get_node("LoadingScreen").visible = true
	get_node("LoadingScreenTimer").start(1)


func _on_play_world_2_button_pressed():
	worldaddresstoload = "user://World2.tres"
	SoundHandler.playSFX("ButtonSound")
	get_node("LoadingScreen").visible = true
	get_node("LoadingScreenTimer").start(1)


func _on_play_world_3_button_pressed():
	worldaddresstoload = "user://World3.tres"
	SoundHandler.playSFX("ButtonSound")
	get_node("LoadingScreen").visible = true
	get_node("LoadingScreenTimer").start(1)


func _on_trash_button_1_pressed():
	worldaddresstodelete = "user://World1.tres"
	SoundHandler.playSFX("ButtonSound")
	playoptions.visible = false
	areyousureoptions.visible = true


func _on_trash_button_2_pressed():
	worldaddresstodelete = "user://World2.tres"
	SoundHandler.playSFX("ButtonSound")
	playoptions.visible = false
	areyousureoptions.visible = true


func _on_trash_button_3_pressed():
	worldaddresstodelete = "user://World3.tres"
	SoundHandler.playSFX("ButtonSound")
	playoptions.visible = false
	areyousureoptions.visible = true

func _on_button_hovered():
	SoundHandler.playSFX("ButtonHover")
