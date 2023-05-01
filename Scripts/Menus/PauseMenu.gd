extends Control


func _ready():
	pass

func openPauseMenu():
	Constants.inworld = false
	self.visible = true

func _on_MainMenuButton_pressed():
	SoundHandler.playSFX("button")
	FileHandler.saveWorldToFile(MouseController.myworld)
	var mainmenuobject = load("res://Scenes/Menus/MainMenu.tscn")
	var newmainmenuinstance = mainmenuobject.instance() 
	get_tree().get_root().add_child(newmainmenuinstance)
	Constants.inworld = false
	get_tree().get_root().get_node("Main").queue_free()


func _on_ReturnButton_pressed():
	SoundHandler.playSFX("button")
	Constants.inworld = true
	self.visible = false
	MouseController.holding = false
	MouseController.walkinghold = false
	MouseController.player.setWalking(false)


func _on_SettingsBut_pressed():
	SoundHandler.playSFX("button")
	SettingsMenu.setToFront(self)
