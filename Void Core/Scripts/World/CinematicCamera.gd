extends Camera2D

var haventplayedanimyet = true

func _ready():
	pass

func _process(_delta):
	if(haventplayedanimyet):
		if(enabled):
			haventplayedanimyet = false
			get_node("AnimationPlayer").play("Falling")
