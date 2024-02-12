extends Control

@export var searchline:LineEdit
@export var clearbutt:Button
@export var pagelabel:Label
@export var incarrow:TextureButton
@export var decarrow:TextureButton
@export var panelholder:VBoxContainer
@export var loadingscreen:Control

@onready var panelobject = load("res://Scenes/Menus/DimensionPanel.tscn")
@onready var httpreq = get_node("HTTPRequest")
@onready var worldgethttp = get_node("WorldGetHTTP")
@onready var worldscene = load("res://Scenes/World/game_world.tscn")

var totalpages = 1
var pagenum = 1

var newworlddata

func _ready():
	makeGetRequest()

func makeGetRequest():
	var searchtext = ""
	if(searchline.text):
		searchtext = searchline.text
	var querystring = "?pagenum=" + str(pagenum) + "&search=" + searchtext
	httpreq.request("http://" + Globs.IPANDPORT + Globs.BASICFETCHURL + querystring)
	clearPage()
	showLoadingPanel()

func _on_http_request_request_completed(_result, response_code, _headers, body):
	hideLoadingPanel()
	if(str(response_code) == "200"):
		var json = JSON.parse_string(body.get_string_from_utf8())
		totalpages = json.totalpages
		displayPage(json.page)
	else:
		get_node("ServerClosed").visible = true

func clearPage():
	for oldpan in panelholder.get_children():
		oldpan.queue_free()

func displayPage(pagedata):
	clearPage()
	for pan in pagedata:
		var newpanel = panelobject.instantiate()
		newpanel.dimensionmenu = self
		newpanel.uid = pan.uid
		newpanel.worldname = pan.worldname
		newpanel.username = pan.username
		newpanel.date = pan.date
		newpanel.thumbnail = Marshalls.base64_to_raw(pan.thumbnail)
		panelholder.add_child(newpanel)

func _on_exit_button_pressed():
	self.queue_free()

func showLoadingPanel():
	loadingscreen.visible = true

func hideLoadingPanel():
	loadingscreen.visible = false

func _on_clear_button_pressed():
	searchline.text = ""
	clearbutt.visible = false
	pagenum = 1
	makeGetRequest()


func _on_inc_arrow_pressed():
	if(pagenum < totalpages):
		pagenum += 1


func _on_dec_arrow_pressed():
	if(pagenum > 1):
		pagenum -= 1
	makeGetRequest()


func _on_line_edit_text_submitted(_new_text):
	pagenum = 1
	makeGetRequest()

func startWorld():
	var worldinstance = worldscene.instantiate()
	Globs.worlddata = newworlddata
	Globs.newworld = newworlddata.newworld
	Utils.checkIfNewWorld()
	Utils.checkIfIntroCutscene()
	Globs.inworld = true
	Globs.thisworldismine = false
	Globs.onlineuid = newworlddata.onlineuid
	Globs.onlineworldname = newworlddata.onlineworldname
	for c in get_tree().get_root().get_children():
		if(c.name == "MainMenu"):
			c.queue_free()
	get_tree().get_root().add_child(worldinstance)
	queue_free()

func _on_world_load_timer_timeout():
	startWorld()

func makeWorldRequest(uid):
	var querystring = "?uid=" + uid
	worldgethttp.request("http://" + Globs.IPANDPORT + Globs.WORLDGETURL + querystring)
	get_node("LoadingScreen").visible = true

func _on_world_get_http_request_completed(_result, response_code, _headers, body):
	if(str(response_code) == "200"):
		var json = JSON.parse_string(body.get_string_from_utf8())
		get_node("LoadingScreen/WorldLoadTimer").start(0.5)
		newworlddata = json
	else:
		get_node("ServerClosed").visible = true
