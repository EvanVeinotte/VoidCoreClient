extends Node

var settingsdata = {"tutorialenabled": true, "mute": false}

var menutohide

func setToFront(mth=null):
	menutohide = mth
	if(menutohide):
		menutohide.visible = false
	print("SETTINGS")
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
	AudioServer.set_bus_mute(0, settingsdata.mute)


func _on_BackButton_pressed():
	SoundHandler.playSFX("button")
	if(menutohide):
		menutohide.visible = true
	self.layer = 0
	get_node("SettingsMenu").visible = false


func _on_MuteButton_pressed():
	SoundHandler.playSFX("button")
	setMute(!settingsdata.mute)
	updateButtons()
	
	FileHandler.saveSettingsToFile(settingsdata)


func _on_TutorialButton_pressed():
	SoundHandler.playSFX("button")
	settingsdata.tutorialenabled = !settingsdata.tutorialenabled
	updateButtons()
	
	FileHandler.saveSettingsToFile(settingsdata)



func _on_MuteButton_ready():
	updateButtons()


func _on_TutorialButton_ready():
	updateButtons()

func updateButtons():
	if(settingsdata.tutorialenabled):
		get_node("SettingsMenu/TutorialButton").text = "Tutorial: On"
	else:
		get_node("SettingsMenu/TutorialButton").text = "Tutorial: Off"
	
	if(settingsdata.mute):
		get_node("SettingsMenu/MuteButton").text = "Muted: Yes"
	else:
		get_node("SettingsMenu/MuteButton").text = "Muted: No"
