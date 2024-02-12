extends Node

const listofobjectnameswithid ={
	"Smooth Stone Tile" : 1,
	"Cobble Stone Tile" : 2,
	"Dirt Tile" : 3,
	"Grass Tile" : 4,
	"Orange Flower Grass Tile" : 5,
	"Pink Flower Grass Tile" : 6,
	"Yellow Flower Grass Tile" : 7,
	"Rocks" : 8,
	"Tree Stump" : 9,
	"Bronze Coins" : 10,
	"Lantern" : 11,
	"Orange Flower Pot" : 12,
	"Purple Flower Pot" : 13,
	"Void Core" : 14,
	"Bronze Game Machine" : 15,
	"Dimension Satellite" : 16,
	"Basic 10000 Statue" : 17,
	"Basic 20000 Statue" : 18
}

const objswithspeciallootspawnstates = {
	"Bronze Coins": 500000, #coins spawn from void with 5 in a stack
}

var basiclootpercentages = {
							"Smooth Stone Tile": 10,
							"Cobble Stone Tile": 10,
							"Dirt Tile": 10,
							"Grass Tile": 10,
							"Orange Flower Grass Tile": 3,
							"Pink Flower Grass Tile": 3,
							"Yellow Flower Grass Tile": 3,
							"Rocks": 7,
							"Tree Stump": 7,
							"Bronze Coins": 10,
							"Lantern": 7,
							"Orange Flower Pot": 10,
							"Purple Flower Pot": 10
							}
#var basiclootarray = [2001,3001,4001,1002,2002,1003]

var basiclootarray = []
var customfirstlootarray = []
var scriptedloot = {}

func _ready():
	for i in basiclootpercentages.keys():
		for a in range(basiclootpercentages[i]):
			var specialspawnstateval = 0
			if(objswithspeciallootspawnstates.has(i)):
				specialspawnstateval = objswithspeciallootspawnstates[i]
			basiclootarray.append(listofobjectnameswithid[i] + specialspawnstateval)
	randomize()

func getRandomLoot(lootclass):
	var randvalue
	if(customfirstlootarray):
		var loottoreturn = customfirstlootarray.pop_front()
		return loottoreturn
	if(scriptedloot):
		#the keys are strings, but we have to turn them to ints
		var scriptedkeys = scriptedloot.keys()
		for i in range(len(scriptedkeys)):
			scriptedkeys[i] = int(scriptedkeys[i])
		scriptedkeys.sort()
		for k in scriptedkeys:
			if(k <= MouseController.theworld.voiditemcount + 1):
				var loottoreturn = scriptedloot[str(k)]
				scriptedloot.erase(str(k))
				return loottoreturn

	if(lootclass == "basic"):
		randvalue = floor(randf() * len(basiclootarray))
		return basiclootarray[randvalue]
