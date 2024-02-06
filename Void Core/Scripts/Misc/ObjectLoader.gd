extends Node

###load in the objects
@onready var smoothstonetile = preload("res://Objects/Scenes/SmoothStoneTile.tscn")
@onready var cobblestonetile = preload("res://Objects/Scenes/CobbleStoneTile.tscn")
@onready var dirttile = preload("res://Objects/Scenes/DirtTile.tscn")
@onready var grasstile = preload("res://Objects/Scenes/GrassTile.tscn")
@onready var orangeflowergrasstile = preload("res://Objects/Scenes/OrangeFlowerGrassTile.tscn")
@onready var pinkflowergrasstile = preload("res://Objects/Scenes/PinkFlowerGrassTile.tscn")
@onready var yellowflowergrasstile = preload("res://Objects/Scenes/YellowFlowerGrassTile.tscn")
@onready var rocks = preload("res://Objects/Scenes/Rocks.tscn")
@onready var treestump = preload("res://Objects/Scenes/TreeStump.tscn")
@onready var bronzecoins = preload("res://Objects/Scenes/BronzeCoins.tscn")
@onready var lantern = preload("res://Objects/Scenes/Lantern.tscn")
@onready var orangeflowerpot = preload("res://Objects/Scenes/OrangeFlowerPot.tscn")
@onready var purpleflowerpot = preload("res://Objects/Scenes/PurpleFlowerPot.tscn")
@onready var voidcore = preload("res://Objects/Scenes/TheVoidCore.tscn")
@onready var bronzegamemachine = preload("res://Objects/Scenes/BronzeGameMachine.tscn")
@onready var dimensionsatellite = preload("res://Objects/Scenes/DimensionSatellite.tscn")
###

@onready var objectbyid = [null,
					smoothstonetile,
					cobblestonetile,
					dirttile,
					grasstile,
					orangeflowergrasstile,
					pinkflowergrasstile,
					yellowflowergrasstile,
					rocks,
					treestump,
					bronzecoins,
					lantern,
					orangeflowerpot,
					purpleflowerpot,
					voidcore,
					bronzegamemachine,
					dimensionsatellite,
				]
