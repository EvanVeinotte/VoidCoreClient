extends Node

###load in the objects
@onready var smoothstonetile = preload("res://Objects/SmoothStoneTile.tscn")
@onready var cobblestonetile = preload("res://Objects/CobbleStoneTile.tscn")
@onready var dirttile = preload("res://Objects/DirtTile.tscn")
@onready var grasstile = preload("res://Objects/GrassTile.tscn")
@onready var orangeflowergrasstile = preload("res://Objects/OrangeFlowerGrassTile.tscn")
@onready var pinkflowergrasstile = preload("res://Objects/PinkFlowerGrassTile.tscn")
@onready var yellowflowergrasstile = preload("res://Objects/YellowFlowerGrassTile.tscn")
@onready var rocks = preload("res://Objects/Rocks.tscn")
@onready var treestump = preload("res://Objects/TreeStump.tscn")
@onready var bronzecoins = preload("res://Objects/BronzeCoins.tscn")
@onready var lantern = preload("res://Objects/Lantern.tscn")
@onready var orangeflowerpot = preload("res://Objects/OrangeFlowerPot.tscn")
@onready var purpleflowerpot = preload("res://Objects/PurpleFlowerPot.tscn")
###

var objectbyid = [null,
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
					purpleflowerpot
				]
