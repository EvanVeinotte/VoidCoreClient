extends Node


func _ready():
	pass # Replace with function body.

func saveWorldToFile(myworld):
	var file = File.new()
	file.open("res://Saves/StartMap.tres", File.WRITE)
	file.store_string(JSON.print(myworld.themap))
	file.close()

func loadWorldFromFile():
	var file = File.new()
	file.open("res://Saves/StartMap.tres", File.READ)
	var result = JSON.parse(file.get_as_text()).result
	file.close()
	return result

func saveHighscoreToFile(listOfHighscores):
	var file = File.new()
	file.open("res://Saves/Highscores.tres", File.WRITE)
	file.store_string(JSON.print(listOfHighscores))
	file.close()

func loadHighscoresFromFile():
	var file = File.new()
	file.open("res://Saves/Highscores.tres", File.READ)
	var result = JSON.parse(file.get_as_text()).result
	file.close()
	return result
