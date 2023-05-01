extends Node

var basiclootarray = []
var basiclootpercentages = {
							1001: 10,
							2001: 10,
							3001: 10,
							4001: 10,
							5001: 3,
							6001: 3,
							7001: 3,
							1007: 7,
							1008: 7,
							50001005: 10,
							1003: 7,
							1002: 10,
							2002: 10
							}
#var basiclootarray = [2001,3001,4001,1002,2002,1003]
var customfirstlootarray = []
var firstlootarray = []

func _ready():
	for i in basiclootpercentages.keys():
		for a in range(basiclootpercentages[i]):
			basiclootarray.append(i)
	randomize()

func getRandomLoot(lootclass):
	var randvalue
	if(customfirstlootarray):
		var loottoreturn = customfirstlootarray[0]
		customfirstlootarray.remove(0)
		return loottoreturn
	if(firstlootarray):
		var loottoreturn = firstlootarray[0]
		firstlootarray.remove(0)
		return loottoreturn
	if(lootclass == "basic"):
		randvalue = floor(randf() * len(basiclootarray))
		return basiclootarray[randvalue]
		
