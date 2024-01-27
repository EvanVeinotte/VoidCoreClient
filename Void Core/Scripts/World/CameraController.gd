extends Camera2D

@export var player : Node2D


func _ready():
	self.position = player.position


func _process(delta):
	var playerdist = player.position - self.position

	if(abs(playerdist.x) > 1 or abs(playerdist.y) > 1):
		playerdist = Vector2(playerdist.x/10, playerdist.y/10)
		var xvel = (playerdist.x * playerdist.x * playerdist.x)/20
		var yvel = (playerdist.y * playerdist.y * playerdist.y)/20
		if(xvel > 100):
			xvel = 100
		elif(xvel < -100):
			xvel = -100
		elif(xvel > 0 and xvel < 1):
			xvel = 0
		elif(xvel < 0 and xvel > -1):
			xvel = 0
		if(yvel > 100):
			yvel = 100
		elif(yvel < -100):
			yvel = -100
		elif(yvel > 0 and yvel < 1):
			yvel = 0
		elif(yvel < 0 and yvel > -1):
			yvel = 0
		self.position = Vector2(self.position.x + xvel, self.position.y + yvel)
	else:
		self.position = player.position
