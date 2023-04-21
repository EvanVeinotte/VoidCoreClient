extends Node2D

onready var MinigameController = get_parent().get_parent()
onready var cooldowntimer = get_node("EnemyCoolDown")

var enemyspeed = 400
var enemycooldown = 2
var enemyactive = false
var enemywaiting = false
var start = false

func restart():
	enemyactive = false
	enemywaiting = false
	enemyspeed = 300
	visible = false
	start = true
	self.get_node("Area2D").monitorable = false
	

func _ready():
	pass
	
func _process(delta):
	if(start):
		if(!enemywaiting):
			enemywaiting = true
			cooldowntimer.wait_time = enemycooldown * randf() + 0.05
			cooldowntimer.start()
		
		if(enemyactive):
			self.position = Vector2(self.position.x - enemyspeed * delta, self.position.y)
		if(enemyactive and self.position.x <= 170):
			MinigameController.howmanyenemiesactive -= 1
			MinigameController.score += MinigameController.scoreincamount
			MinigameController.updateCoins()
			self.get_node("Area2D").monitorable = false
			self.visible = false
			enemywaiting = false
			enemyactive = false
			MinigameController.displayScore()
			



func _on_EnemyCoolDown_timeout():
	if(start):
		if(MinigameController.howmanyenemiesactive < 2):
			self.get_node("Area2D").monitorable = true
			self.visible = true
			enemyactive = true
			self.position = Vector2(1200, self.position.y)
			self.get_node("Sprite").texture = MinigameController.enemysprites[floor(3 * randf())]
			MinigameController.howmanyenemiesactive += 1
			enemyspeed = log((MinigameController.score + 100)/100) * 400 + 400
		else:
			cooldowntimer.wait_time = enemycooldown * randf() + 0.05
			cooldowntimer.start()
