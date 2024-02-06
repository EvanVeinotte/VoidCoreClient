extends Node


var holdtime = 0
var holding = false
var walkinghold = false

var activeclickables = []

var selectednode

@onready var player
@onready var theworld
@onready var maincamera
@onready var cinecam
var thevoidcore



var zoom_sensitivity = 10
var zoom_speed = 0.05

var events = {}
var last_drag_distance = 0

var thisturnzooming = false

func loadMainInstances():
	player = get_tree().get_root().get_node("GameWorld/World/Player")
	theworld = get_tree().get_root().get_node("GameWorld/World")
	maincamera = get_tree().get_root().get_node("GameWorld/MainCamera")
	walkinghold = false
	holding = false

func _ready():
	pass # Replace with function body.

func _unhandled_input(_event):
	if Globs.inworld:
		pass

func _input(event):
	if Globs.inworld:
		thisturnzooming = false
		if event is InputEventScreenTouch:
			if event.pressed:
				events[event.index] = event
			else:
				events.erase(event.index)
		if event is InputEventScreenDrag:
			
			maincamera.get_parent().get_node("CanvasLayer/Label").text = str(events.size())
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
					if(thevoidcore.voidscript.triggers.PHASETWO == true and thevoidcore.voidscript.triggers.Zoomed == false):
						thevoidcore.voidscript.triggers.Zoomed = true
						thevoidcore.voidscript.updateFromTriggers()
					var new_zoom = (1 + zoom_speed) if drag_distance < last_drag_distance else (1 - zoom_speed)
					new_zoom = clamp(maincamera.zoom.x * new_zoom, Globs.CAMERA_ZOOM_MIN, Globs.CAMERA_ZOOM_MAX)
					maincamera.zoom = Vector2.ONE * new_zoom
					last_drag_distance = drag_distance
		
		if(!thisturnzooming):
			if event is InputEventMouseButton:
				var vectoritshouldbe = Vector2(Globs.WIDTH_IT_SHOULD_BE, Globs.HEIGHT_IT_SHOULD_BE)
				var clickpos = ((event.position - vectoritshouldbe/2) / maincamera.zoom) + vectoritshouldbe/2 + maincamera.position - vectoritshouldbe * 0.5
				
				if(event.button_index != MOUSE_BUTTON_WHEEL_UP and event.button_index != MOUSE_BUTTON_WHEEL_DOWN):
					if(event.pressed):
						if(!player.building):
							for item in activeclickables:
								if(item.checkPointInside(clickpos)):
									item.doActiveAction()
					
					if(event.double_click):
						if(player.building):
							theworld.getClickedObject(clickpos, true)
						else:
							if(thevoidcore.checkPointInside(clickpos)):
								FileHandler.saveWorldToFile(theworld, Globs.currentworldfileaddress)
					
				if(event.button_index == MOUSE_BUTTON_WHEEL_UP):
					zoomCamera(-0.1)
				elif(event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
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
	if Globs.inworld:
		if(!walkinghold):
			if(holding):
				holdtime += delta
			if(holdtime > Globs.HOLD_UNTIL_WALK):
				walkinghold = true
			if(walkinghold):
				if(!player.building):
					if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
						player.setWalking(true)
					else:
						walkinghold = false
				else:
					var vectoritshouldbe = Vector2(Globs.WIDTH_IT_SHOULD_BE, Globs.HEIGHT_IT_SHOULD_BE)
					var clickpos = ((get_viewport().get_mouse_position() - vectoritshouldbe/2) / maincamera.zoom) + vectoritshouldbe/2 + maincamera.position - vectoritshouldbe * 0.5
					theworld.getClickedObject(clickpos)
		if(Input.is_action_just_pressed("escape")):
			thevoidcore.voidscript.triggers.DidPause = true
			thevoidcore.voidscript.updateFromTriggers()
			get_tree().get_root().get_node("GameWorld/CanvasLayer/PauseMenu").openPauseMenu()
		elif(Input.is_action_just_pressed("buildmode")):
				player._on_TextureButton_pressed()

func zoomCamera(howmuch):
	howmuch = -howmuch
	if(thevoidcore.voidscript.triggers.PHASETWO == true and thevoidcore.voidscript.triggers.Zoomed == false):
		thevoidcore.voidscript.triggers.Zoomed = true
		thevoidcore.voidscript.updateFromTriggers()
	var newcamerazoom = Vector2(maincamera.zoom.x + howmuch, maincamera.zoom.y + howmuch)
	var newnewx = newcamerazoom.x
	var newnewy = newcamerazoom.y
	if(newcamerazoom.x < Globs.CAMERA_ZOOM_MIN):
		newnewx = Globs.CAMERA_ZOOM_MIN
	if(newcamerazoom.x > Globs.CAMERA_ZOOM_MAX):
		newnewx = Globs.CAMERA_ZOOM_MAX
	if(newcamerazoom.y < Globs.CAMERA_ZOOM_MIN):
		newnewy = Globs.CAMERA_ZOOM_MIN
	if(newcamerazoom.y > Globs.CAMERA_ZOOM_MAX):
		newnewy = Globs.CAMERA_ZOOM_MAX
	maincamera.zoom = Vector2(newnewx, newnewy)
