extends Node

var basiclootarray = []
var basiclootpercentages = {
							00001: 10,
							00002: 10,
							00003: 10,
							00004: 10,
							00005: 3,
							00006: 3,
							00007: 3,
							00008: 7,
							00009: 7,
							500010: 10,
							00011: 7,
							00012: 10,
							00013: 10
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
