extends Camera2D

var haventplayedanimyet = true

func _ready():
	pass

func _process(delta):
	if(haventplayedanimyet):
		if(current):
			haventplayedanimyet = false
			get_node("AnimationPlayer").play("Falling")
