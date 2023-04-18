extends Node

var basiclootarray = [1001,2001,3001,4001,1002,2002,1003,50001005]

func _ready():
	randomize()

func getRandomLoot(lootclass):
	var randvalue
	if(lootclass == "basic"):
		randvalue = floor(randf() * len(basiclootarray))
		return basiclootarray[randvalue]
		
