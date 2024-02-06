extends Node

var settingsdata = {"tutorialenabled": true, "mute": false, "fullscreen": false, "onlineusername": ""}

var menutohide

func setToFront(mth=null):
	menutohide = mth
	if(menutohide):
		menutohide.visible = false
	updateButtons()
	get_parent().move_child(self, get_parent().get_child_count())
	self.layer = 10
	get_node("SettingsMenu").visible = true
	get_node("SettingsMenu").grab_focus()

func setMute(val):
	settingsdata.mute = val
	AudioServer.set_bus_mute(0, val)

func _ready():
	settingsdata = FileHandler.loadSettingsFromFile()
	if(settingsdata.fullscreen):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	AudioServer.set_bus_mute(0, settingsdata.mute)


func _on_BackButton_pressed():
	SoundHandler.playSFX("ButtonSound")
	if(menutohide):
		menutohide.visible = true
	self.layer = 0
	get_node("SettingsMenu").visible = false


func _on_MuteButton_pressed():
	SoundHandler.playSFX("ButtonSound")
	setMute(!settingsdata.mute)
	updateButtons()
	
	FileHandler.saveSettingsToFile(settingsdata)


func _on_TutorialButton_pressed():
	SoundHandler.playSFX("ButtonSound")
	settingsdata.tutorialenabled = !settingsdata.tutorialenabled
	updateButtons()
	
	FileHandler.saveSettingsToFile(settingsdata)



func _on_MuteButton_ready():
	updateButtons()


func _on_TutorialButton_ready():
	updateButtons()

func updateButtons():
	
	if(Globs.DEVICE_TYPE == "Android"):
		get_node("SettingsMenu/FullscreenButton").visible = false
	
	if(settingsdata.tutorialenabled):
		get_node("SettingsMenu/TutorialButton").text = "Tutorial: On"
	else:
		get_node("SettingsMenu/TutorialButton").text = "Tutorial: Off"
	
	if(settingsdata.mute):
		get_node("SettingsMenu/MuteButton").text = "Muted: Yes"
	else:
		get_node("SettingsMenu/MuteButton").text = "Muted: No"
	
	if(settingsdata.fullscreen):
		get_node("SettingsMenu/FullscreenButton").text = "Fullscreen: On"
	else:
		get_node("SettingsMenu/FullscreenButton").text = "Fullscreen: Off"


func _on_CreditsBackButton_pressed():
	SoundHandler.playSFX("ButtonSound")
	get_node("SettingsMenu/CreditsScreen").visible = false
	get_node("SettingsMenu/ControlsScreen").visible = false


func _on_CreditsButton_pressed():
	SoundHandler.playSFX("ButtonSound")
	get_node("SettingsMenu/CreditsScreen").visible = true


func _on_FullscreenButton_pressed():
	SoundHandler.playSFX("ButtonSound")
	settingsdata.fullscreen = !settingsdata.fullscreen
	if(settingsdata.fullscreen):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	updateButtons()
	FileHandler.saveSettingsToFile(settingsdata)

func _on_FullscreenButton_ready():
	updateButtons()

func _on_ControlsButton_pressed():
	SoundHandler.playSFX("ButtonSound")
	get_node("SettingsMenu/ControlsScreen").visible = true

func _on_button_hover():
	SoundHandler.playSFX("ButtonHover")
