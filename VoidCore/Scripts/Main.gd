extends Node2D

onready var myworld = get_tree().get_root().get_node("Main/World")

func _ready():
	pass # Replace with function body.

func saveWorldToFile():
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
