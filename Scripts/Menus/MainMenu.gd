extends Control

onready var displaylabeltween = get_node("ShowComingSoonTween")
onready var menuoptions = get_node("MenuOptions")
onready var playoptions = get_node("PlayOptions")
onready var creditscreen = get_node("CreditsScreen")

onready var worldscene = load("res://Scenes/Main.tscn")

const skiptogame = false

var newworld = false

func _ready():
	if(skiptogame):
		_on_PlayWorldButton_pressed()
	updatePlayWorldButton()

func ShowComingSoonLabel():
	displaylabeltween.interpolate_property(get_node("MenuOptions/ComingSoon"), "visible", 1, 0, 3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	displaylabeltween.start()

func updatePlayWorldButton():
	var doesfileexist = FileHandler.checkIfFileExists()
	if(doesfileexist):
		playoptions.get_node("PlayWorldButton").text = "Load World"
		playoptions.get_node("DeleteWorldButton").visible = true
	else:
		playoptions.get_node("PlayWorldButton").text = "New World"
		playoptions.get_node("DeleteWorldButton").visible = false

func _on_PlayButton_pressed():
	SoundHandler.playSFX("button")
	menuoptions.visible = false
	playoptions.visible = true
	creditscreen.visible = false
	


func _on_MultiplayerButton_pressed():
	SoundHandler.playSFX("button")
	ShowComingSoonLabel()


func _on_DimensionsButton_pressed():
	SoundHandler.playSFX("button")
	ShowComingSoonLabel()


func _on_CreditsButton_pressed():
	SoundHandler.playSFX("button")
	menuoptions.visible = false
	playoptions.visible = false
	creditscreen.visible = true


func _on_ExitGameButton_pressed():
	SoundHandler.playSFX("button")
	get_tree().quit()


func _on_PlayWorldButton_pressed():
	SoundHandler.playSFX("button")
	get_node("LoadingScreen").visible = true
	get_node("LoadingScreenTimer").start(1)


func _on_DeleteWorldButton_pressed():
	SoundHandler.playSFX("button")
	FileHandler.deleteFile()
	updatePlayWorldButton()


func _on_BackButton_pressed():
	SoundHandler.playSFX("button")
	menuoptions.visible = true
	playoptions.visible = false
	creditscreen.visible = false


func _on_LoadingScreenTimer_timeout():
	var newworlddata = FileHandler.loadWorldFromFile()
	var worldinstance = worldscene.instance()
	Constants.worlddata = newworlddata
	Constants.checkIfNewWorld()
	Constants.inworld = true
	get_tree().get_root().add_child(worldinstance)
	queue_free()


func _on_SettingsBut_pressed():
	SoundHandler.playSFX("button")
	SettingsMenu.setToFront()
