extends Node2D

const colordata = [Color(0.32, 0.27, 0.22), Color(0.50,0.32,0.36)]
const minigamename = "basic"
var MinigameController

@onready var player = get_node("Screen/Player")
@onready var enemysprites = [load("res://Images/MiniGames/BasicGame/woman.png"),
							load("res://Images/MiniGames/BasicGame/pill.png"),
							load("res://Images/MiniGames/BasicGame/money.png")]

@onready var enemy1 = get_node("Screen/Enemy1")
@onready var enemy2 = get_node("Screen/Enemy2")
@onready var enemy3 = get_node("Screen/Enemy3")

@onready var highscorenode = get_node("Screen/Highscore")
@onready var gameovernode = get_node("Screen/GameOver")
@onready var coinsfullnode = get_node("Screen/CoinsFull")

var playerposes = [270,510,750]
var playerposindex = 1

var howmanyenemiesactive = 0

var gameover = true
var score = 0
var highscore
var newhighscore = false
var scoreincamount = 100
var canrestart = true

var coinsthisround = 0
var savedcoins = 0
var totalcoins = 0

func _ready():
	var highscoredata = FileHandler.loadHighscoresFromFile()
	if(highscoredata):
		highscore = int(highscoredata[minigamename])
	else: 
		highscore = 0
	displayHighscore()
	randomize()

func restart():
	gameovernode.visible = false
	coinsthisround = 0
	highscorenode.visible = true
	newhighscore = false
	get_node("BlinkTimer").stop()
	score = 0
	displayScore()
	displayHighscore()
	playerposindex = 1
	player.position = Vector2(250,510)
	howmanyenemiesactive = 0
	gameover = false
	player.get_node("AnimationPlayer").speed_scale = 1
	enemy1.restart()
	enemy2.restart()
	enemy3.restart()

func saveScoreIfHighscore(newscore):
	if(newscore > highscore):
		var oldhighscoredict = FileHandler.loadHighscoresFromFile()
		highscore = newscore
		oldhighscoredict[minigamename] = highscore
		FileHandler.saveHighscoreToFile(oldhighscoredict)
		newhighscore = true

func displayHighscore():
	if(newhighscore):
		SoundHandler.playSFX("Win")
		get_node("BlinkTimer").start(0.5)
	var digits = get_node("Screen/Highscore").get_children()
	for i in range(5):
		digits[i].frame = Utils.getDigit(highscore, i)
	for i in range(5):
		if(digits[4-i].frame == 0):
			digits[4-i].frame = 10
		else:
			break

func displayScore():
	var digits = get_node("Screen/Score").get_children()
	for i in range(5):
		digits[i].frame = Utils.getDigit(score, i)
	for i in range(5):
		if(digits[4-i].frame == 0):
			digits[4-i].frame = 10
		else:
			break

func displayCoins():
	var digits = get_node("Screen/Coins").get_children()
	for i in range(2):
		digits[i].frame = Utils.getDigit(totalcoins, i)
	for i in range(2):
		if(digits[1-i].frame == 0):
			digits[1-i].frame = 10
		else:
			break

func updateCoins():
	coinsthisround = floor(score/1000.0)
	totalcoins = savedcoins + coinsthisround
	if(totalcoins > 99):
		totalcoins = 99
	displayCoins()
	
	

func _on_UpArrow_button_down():
	if(!gameover):
		if(playerposindex > 0):
			playerposindex -= 1
		player.position = Vector2(player.position.x, playerposes[playerposindex])
		SoundHandler.playSFX("NormalBoop")
	else:
		if(canrestart and coinsfullnode.visible == false):
			SoundHandler.playSFX("NormalBoop")
			restart()

func _on_DownArrow_button_down():
	if(!gameover):
		if(playerposindex < 2):
			playerposindex += 1
		player.position = Vector2(player.position.x, playerposes[playerposindex])
		SoundHandler.playSFX("NormalBoop")
	else:
		if(canrestart and coinsfullnode.visible == false):
			SoundHandler.playSFX("NormalBoop")
			restart()


func _on_Area2D_area_entered(_area):
	get_node("RestartTimer").start(1)
	SoundHandler.playSFX("Error")
	gameover = true
	canrestart = false
	savedcoins = totalcoins
	coinsthisround = 0
	if(savedcoins >= 99):
		coinsfullnode.visible = true
	gameovernode.visible = true
	enemy1.start = false
	enemy2.start = false
	enemy3.start = false
	player.get_node("AnimationPlayer").speed_scale = 0
	saveScoreIfHighscore(score)
	displayHighscore()

func _input(event):
	if(event is InputEventKey):
		if(event.pressed and event.as_text() == "Up"):
			_on_UpArrow_button_down()
		elif(event.pressed and event.as_text() == "Down"):
			_on_DownArrow_button_down()

func _on_RestartTimer_timeout():
	canrestart = true


func _on_BlinkTimer_timeout():
	highscorenode.visible = !highscorenode.visible
