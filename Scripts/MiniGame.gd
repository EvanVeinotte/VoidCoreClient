extends Node2D

var allminigames = ["res://Scenes/MiniGames/BasicMiniGame.tscn"]
onready var canvaslayer = get_node("CanvasLayer")
onready var scaletween = get_node("ScaleTween")
onready var postween = get_node("PosTween")
var currentminigame
var currentgamemachine

var gameopen = false

func _ready():
	pass

func loadMinigame(gamepath):
	var newminigame = load(gamepath).instance()
	newminigame.MinigameController = self
	setColors(newminigame.colordata)
	currentminigame = newminigame
	get_node("CanvasLayer").add_child(newminigame)

func setColors(colordata):
	print(colordata)
	get_node("CanvasLayer/ArcadeBg").modulate = Color(colordata[0])
	get_node("CanvasLayer/ExitButton").modulate = Color(colordata[1])

func openGameWindow(gameindex):
	loadMinigame(allminigames[gameindex])
	canvaslayer.visible = true
	gameopen = true
	Constants.inworld = false
	scaletween.interpolate_property(canvaslayer, "scale", Vector2.ZERO, Vector2.ONE, Constants.GAME_WINDOW_TIME, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	postween.interpolate_property(canvaslayer, "offset", Constants.SCREEN_SIZE/2, Vector2.ZERO, Constants.GAME_WINDOW_TIME, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	scaletween.start()
	postween.start()

func closeGameWindow():
	Constants.inworld = true
	MouseController.holding = false
	MouseController.walkinghold = false
	MouseController.player.setWalking(false)
	gameopen = false
	scaletween.interpolate_property(canvaslayer, "scale", Vector2.ONE, Vector2(0.005,0.005), Constants.GAME_WINDOW_TIME, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	postween.interpolate_property(canvaslayer, "offset", Vector2.ZERO, Constants.SCREEN_SIZE/2, Constants.GAME_WINDOW_TIME, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	scaletween.start()
	postween.start()

func _on_ExitButton_button_up():
	closeGameWindow()


func _on_ScaleTween_tween_all_completed():
	if(!gameopen):
		canvaslayer.visible = false
		if(currentgamemachine):
			currentgamemachine.essenceinside = currentminigame.totalcoins
			currentgamemachine = null
		
		if(currentminigame):
			currentminigame.queue_free()
			currentminigame = null
	
