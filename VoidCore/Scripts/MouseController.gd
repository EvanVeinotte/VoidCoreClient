extends Node


var holdtime = 0
var holding = false
var walkinghold = false

var selectednode

onready var lildot = load("res://Scenes/Dot.tscn")

onready var player = get_tree().get_root().get_node("Main/World/YSort/Player")
onready var myworld = get_tree().get_root().get_node("Main/World")
onready var camera = get_tree().get_root().get_node("Main/Camera2D")
var thevoidcore

func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton:
		
		if(event.button_index == BUTTON_WHEEL_UP):
			zoomCamera(-0.1)
		elif(event.button_index == BUTTON_WHEEL_DOWN):
			zoomCamera(0.1)
		else:
			if(event.pressed):
				holding = true
			else:
				holding = false
				holdtime = 0
				walkinghold = false
				player.setWalking(false)
				if(selectednode):
					selectednode.beDeselected()
					selectednode = null
	
	if event is InputEventKey:
		get_tree().get_root().get_node("Main").saveWorldToFile()


func _process(delta):
	if(!walkinghold):
		if(holding):
			holdtime += delta
		if(holdtime > Constants.HOLD_UNTIL_WALK):
			walkinghold = true
		
		if(walkinghold):
			if(!player.building):
				player.setWalking(true)
			else:
				var vectoritshouldbe = Vector2(Constants.WIDTH_IT_SHOULD_BE, Constants.HEIGHT_IT_SHOULD_BE)
				var clickpos = ((get_viewport().get_mouse_position() - vectoritshouldbe/2) * camera.zoom) + vectoritshouldbe/2 + camera.position - vectoritshouldbe * 0.5
#				print(get_viewport().get_mouse_position())
#				var newdot = lildot.instance()
#				newdot.position = clickpos
#				get_tree().get_root().get_node("Main/World").add_child(newdot)
				myworld.checkIfObjectClicked(clickpos)


func zoomCamera(howmuch):
	var newcamerazoom = Vector2(camera.zoom.x + howmuch, camera.zoom.y + howmuch)
	var newnewx = newcamerazoom.x
	var newnewy = newcamerazoom.y
	if(newcamerazoom.x < Constants.CAMERA_ZOOM_MIN):
		newnewx = Constants.CAMERA_ZOOM_MIN
	if(newcamerazoom.x > Constants.CAMERA_ZOOM_MAX):
		newnewx = Constants.CAMERA_ZOOM_MAX
	if(newcamerazoom.y < Constants.CAMERA_ZOOM_MIN):
		newnewy = Constants.CAMERA_ZOOM_MIN
	if(newcamerazoom.y > Constants.CAMERA_ZOOM_MAX):
		newnewy = Constants.CAMERA_ZOOM_MAX
	camera.zoom = Vector2(newnewx, newnewy)
