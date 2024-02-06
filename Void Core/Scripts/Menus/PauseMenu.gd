extends Control


func _ready():
	pass

func openPauseMenu():
	Globs.inworld = false
	self.visible = true

func _on_MainMenuButton_pressed():
	SoundHandler.playSFX("ButtonSound")
	FileHandler.saveWorldToFile(MouseController.theworld, Globs.currentworldfileaddress)
	var mainmenuobject = load("res://Scenes/Menus/MainMenu.tscn")
	var newmainmenuinstance = mainmenuobject.instantiate() 
	get_tree().get_root().add_child(newmainmenuinstance)
	Globs.inworld = false
	MouseController.theworld = null
	get_tree().get_root().get_node("GameWorld").queue_free()


func _on_ReturnButton_pressed():
	SoundHandler.playSFX("ButtonSound")
	Globs.inworld = true
	self.visible = false
	MouseController.holding = false
	MouseController.walkinghold = false
	MouseController.player.setWalking(false)


func _on_SettingsBut_pressed():
	SoundHandler.playSFX("ButtonSound")
	SettingsMenu.setToFront(self)


func _on_button_hovered():
	SoundHandler.playSFX("ButtonHover")
