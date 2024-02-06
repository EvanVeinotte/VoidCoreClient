extends Node2D

var allminigames = {15: "res://Scenes/MiniGames/BasicMiniGame.tscn", 999:"res://Scenes/MiniGames/SilverMiniGame.tscn"}
@onready var canvaslayer = get_node("CanvasLayer")

var currentminigame
var currentgamemachine

var gameopen = false
var inbetween = false

func _ready():
	loadMinigame("res://Scenes/MiniGames/BasicMiniGame.tscn")

func loadMinigame(gamepath):
	if(currentminigame):
		currentminigame.queue_free()
	var newminigame = load(gamepath).instantiate()
	newminigame.MinigameController = self
	setColors(newminigame.colordata)
	currentminigame = newminigame
	get_node("CanvasLayer").add_child(newminigame)

func setColors(colordata):
	get_node("CanvasLayer/ArcadeBg").modulate = Color(colordata[0])
	get_node("CanvasLayer/ExitButton").modulate = Color(colordata[1])

func openGameWindow(gameindex):
	#inbetween = true
	loadMinigame(allminigames[gameindex])
	canvaslayer.visible = true
	gameopen = true

func closeGameWindow():
	#inbetween = true
	currentgamemachine.isspawning = true
	currentgamemachine.get_node("EssenceSpawnTimer").start(Globs.ESSENCE_SPAWN_DELAY)
	currentgamemachine.essenceinside = currentminigame.totalcoins
	currentminigame.queue_free()
	currentminigame = null
	canvaslayer.visible = false
	gameopen = false

func _on_ExitButton_button_up():
	closeGameWindow()
	
