extends Node


onready var SaveLabel
onready var displaylabeltween

func loadMainInstances():
	SaveLabel = get_tree().get_root().get_node("Main/CanvasLayer/SaveLabel")
	displaylabeltween = get_tree().get_root().get_node("Main/CanvasLayer/DisplayLabelTween")

func _ready():
	pass

func saveWorldToFile(myworld):
	var file = File.new()
	file.open("user://StartMap.tres", File.WRITE)
	print(myworld.firstlootarray)
	var worldobject = {"player": {"position": {"x": myworld.player.position.x, "y": myworld.player.position.y}},
						"newworld": myworld.newworld,
						"firstlootarray": myworld.firstlootarray,
						"themap": myworld.themap}
	file.store_string(JSON.print(worldobject))
	file.close()
	#ShowSaveLabel()

func checkIfFileExists():
	var file = File.new()
	if(file.file_exists("user://StartMap.tres")):
		file.open("user://StartMap.tres", File.READ)
		var result = JSON.parse(file.get_as_text()).result
		file.close()
		
		if(result):
			if(result.has("firstlootarray")):
				return true
		
	return false
	
func loadWorldFromFile():
	var file = File.new()
	if(file.file_exists("user://StartMap.tres")):
		file.open("user://StartMap.tres", File.READ)
		var result = JSON.parse(file.get_as_text()).result
		file.close()
		
		if(result):
			if(result.has("firstlootarray")):
				return result
		
	var newworld
	file.open("res://Saves/StarterMap.tres", File.READ)
	newworld = JSON.parse(file.get_as_text()).result
	file.close()
	saveWorldToFile(newworld)
	return newworld
		
	

func saveHighscoreToFile(listOfHighscores):
	var file = File.new()
	file.open("user://Highscores.tres", File.WRITE)
	file.store_string(JSON.print(listOfHighscores))
	file.close()

func loadHighscoresFromFile():
	var file = File.new()
	if(file.file_exists("user://Highscores.tres")):
		file.open("user://Highscores.tres", File.READ)
		var result = JSON.parse(file.get_as_text()).result
		file.close()
		return result
	else:
		saveHighscoreToFile({})
		return {}


func saveSettingsToFile(settingsdata):
	var file = File.new()
	file.open("user://Settings.tres", File.WRITE)
	file.store_string(JSON.print(settingsdata))
	file.close()

func loadSettingsFromFile():
	var file = File.new()
	if(file.file_exists("user://Settings.tres")):
		file.open("user://Settings.tres", File.READ)
		var result = JSON.parse(file.get_as_text()).result
		file.close()
		return result
	else:
		saveSettingsToFile({"tutorialenabled": true, "mute": false})
		return {"tutorialenabled": true, "mute": false}

func deleteFile():
	var dir = Directory.new()
	dir.remove("user://StartMap.tres")

func ShowSaveLabel():
	if(SaveLabel):
		displaylabeltween.interpolate_property(SaveLabel, "visible", 1, 0, 3, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		displaylabeltween.start()
