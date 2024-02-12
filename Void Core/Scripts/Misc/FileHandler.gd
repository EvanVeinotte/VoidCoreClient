extends Node

#
#@onready var SaveLabel
#@onready var displaylabeltween
#
#func loadMainInstances():
	#SaveLabel = get_tree().get_root().get_node("Main/CanvasLayer/SaveLabel")
	#displaylabeltween = get_tree().get_root().get_node("Main/CanvasLayer/DisplayLabelTween")

func _ready():
	pass

func saveDataToFile(datatosave, address):
	var file = FileAccess.open(address, FileAccess.WRITE)
	file.store_string(JSON.stringify(datatosave))
	file.close()

func loadDataFromFile(address):
	var file = FileAccess.open(address, FileAccess.READ)
	if(file):
		var jsondata
		var jsonreader = JSON.new()
		var error = jsonreader.parse(file.get_as_text())
		if(error == OK):
			jsondata = jsonreader.data
		else:
			return {}
		file.close()
		return jsondata
	return {}

func saveWorldToFile(myworld, worldaddress):
	if(!Globs.thisworldismine):
		return
	var worldobject = {"player": {"position": {"x": myworld.player.position.x, "y": myworld.player.position.y}},
						"newworld": false,
						"onlineuid": myworld.onlineuid,
						"onlineworldname": myworld.onlineworldname,
						"scriptedloot": LootTable.scriptedloot,
						"voiditemcount": myworld.voiditemcount,
						"themap": myworld.themap}
	saveDataToFile(worldobject, worldaddress)
	#ShowSaveLabel()

func checkIfWorldFileExists(worldaddress):
	var file = FileAccess.open(worldaddress, FileAccess.READ)
	if(file):
		var jsondata
		var jsonreader = JSON.new()
		var error = jsonreader.parse(file.get_as_text())
		if(error == OK):
			jsondata = jsonreader.data
		file.close()
		if(jsondata):
			return true
	return false

func loadNewWorld(worldaddress):
	var newworld
	var file = FileAccess.open("res://DataFiles/StarterMap.tres", FileAccess.READ)
	if(file):
		var jsondata
		var jsonreader = JSON.new()
		var error = jsonreader.parse(file.get_as_text())
		if(error == OK):
			jsondata = jsonreader.data
		file.close()
		if(jsondata):
			newworld = jsondata
	var onlineuid = Utils.genUID()
	newworld["onlineuid"] = onlineuid
	saveDataToFile(newworld, worldaddress)
	return newworld

func loadWorldFromFile(worldaddress):
	var loadedworld = loadDataFromFile(worldaddress)
	if(!loadedworld.has("onlineuid")):
		loadedworld["onlineuid"] = Utils.genUID()
		saveDataToFile(loadedworld, worldaddress)
	return loadedworld

func saveHighscoreToFile(listOfHighscores):
	saveDataToFile(listOfHighscores, "user://Highscores.tres")

func loadHighscoresFromFile():
	var highscores = loadDataFromFile("user://Highscores.tres")
	if(highscores):
		return highscores
	else:
		saveHighscoreToFile({})
		return {}


func saveSettingsToFile(settingsdata):
	saveDataToFile(settingsdata, "user://Settings.tres")

func loadSettingsFromFile():
	var settingsdata = loadDataFromFile("user://Settings.tres")
	if(settingsdata):
		return settingsdata
	else:
		var initsettingsdata = {"tutorialenabled": true, "mute": false, "fullscreen": true, "master": 0, "sfx": 0, "music": -12, "onlineusername": ""}
		saveSettingsToFile(initsettingsdata)
		return initsettingsdata

func saveOnlineToFile(onlinedata):
	saveDataToFile(onlinedata, "user://Online.tres")

func loadOnlineDataFromFile():
	var onlinedata = loadDataFromFile("user://Online.tres")
	if(onlinedata):
		return onlinedata
	else:
		var initonlinedata = {"username": ""}
		saveSettingsToFile(initonlinedata)
		return initonlinedata

func deleteFile(fileaddress):
	var dir = DirAccess.open("user://")
	if(dir):
		if(dir.remove(fileaddress) != OK):
			print("Could not locate the file to delete.")
	else:
		print("Could not open directory to delete file.")
