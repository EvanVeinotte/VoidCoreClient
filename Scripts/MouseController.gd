extends Node


var holdtime = 0
var holding = false
var walkinghold = false

var activeclickables = []

var selectednode

onready var lildot = load("res://Scenes/Dot.tscn")

onready var player
onready var myworld
onready var camera
onready var cinecam
var thevoidcore



var zoom_sensitivity = 10
var zoom_speed = 0.05

var events = {}
var last_drag_distance = 0

var thisturnzooming = false

func loadMainInstances():
	player = get_tree().get_root().get_node("Main/World/YSort/Player")
	myworld = get_tree().get_root().get_node("Main/World")
	camera = get_tree().get_root().get_node("Main/Camera2D")
	walkinghold = false
	holding = false

func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if Constants.inworld:
		pass

func _input(event):
	if Constants.inworld:
		thisturnzooming = false
		if event is InputEventScreenTouch:
			if event.pressed:
				events[event.index] = event
			else:
				events.erase(event.index)
		if event is InputEventScreenDrag:
			
			camera.get_parent().get_node("CanvasLayer/Label").text = str(events.size())
			events[event.index] = event
			
			if events.size() == 2:
				thisturnzooming = true
				player.setWalking(false)
				var keys = events.keys()
				var key1 = keys[0]
				var key2 = keys[1]
				var touch1 = events[key1].position
				var touch2 = events[key2].position
				var drag_distance = touch1.distance_to(touch2)
				if abs(drag_distance - last_drag_distance) > zoom_sensitivity:
					if(MouseController.thevoidcore.voidscript.triggers.PHASETWO == true and MouseController.thevoidcore.voidscript.triggers.Zoomed == false):
						MouseController.thevoidcore.voidscript.triggers.Zoomed = true
						MouseController.thevoidcore.voidscript.updateFromTriggers()
					var new_zoom = (1 + zoom_speed) if drag_distance < last_drag_distance else (1 - zoom_speed)
					new_zoom = clamp(camera.zoom.x * new_zoom, Constants.CAMERA_ZOOM_MIN, Constants.CAMERA_ZOOM_MAX)
					camera.zoom = Vector2.ONE * new_zoom
					last_drag_distance = drag_distance
		
		if(!thisturnzooming):
			if event is InputEventMouseButton:
				var vectoritshouldbe = Vector2(Constants.WIDTH_IT_SHOULD_BE, Constants.HEIGHT_IT_SHOULD_BE)
				var clickpos = ((event.position - vectoritshouldbe/2) * camera.zoom) + vectoritshouldbe/2 + camera.position - vectoritshouldbe * 0.5
				
				if(event.button_index != BUTTON_WHEEL_UP and event.button_index != BUTTON_WHEEL_DOWN):
					if(event.pressed):
						if(!player.building):
							for item in activeclickables:
								if(item.checkPointInside(clickpos)):
									item.doActiveAction()
					
					if(event.doubleclick):
						if(player.building):
							myworld.checkIfObjectClicked(clickpos, true)
						else:
							if(thevoidcore.checkPointInside(clickpos)):
								FileHandler.saveWorldToFile(myworld)
					
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


func _process(delta):
	if Constants.inworld:
		
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
	if(MouseController.thevoidcore.voidscript.triggers.PHASETWO == true and MouseController.thevoidcore.voidscript.triggers.Zoomed == false):
		MouseController.thevoidcore.voidscript.triggers.Zoomed = true
		MouseController.thevoidcore.voidscript.updateFromTriggers()
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
