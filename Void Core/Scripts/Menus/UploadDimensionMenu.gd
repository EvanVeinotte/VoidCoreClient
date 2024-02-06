extends Control

var valid = false
var validstring = "Dimension Satellite Position: [color=green]valid[/color]"
var invalidstring = "Dimension Satellite Position: [color=red]invalid[/color]"
var uploadsuccessstring = "Upload was successful!"
var uploadfailstring = "Could not communicate with server."
@onready var httpreq = get_node("HTTPRequest")
var thumbtopost = null
var worldname = ""
var username = ""
var date = ""

func _ready():
	if(SettingsMenu.settingsdata.has("onlineusername")):
		get_node("UsernameInput").text = SettingsMenu.settingsdata.onlineusername
		get_node("WorldNameInput").text = MouseController.theworld.onlineworldname
	if(valid):
		setValid()
	else:
		setInvalid()

func setValid():
	get_node("SatelliteValid").text = validstring
	get_node("UploadButton").disabled = false

func setInvalid():
	get_node("SatelliteValid").text = invalidstring
	get_node("UploadButton").disabled = true

func _on_button_hovered():
	SoundHandler.playSFX("ButtonHover")

func showLoading():
	get_node("LoadingSprite").visible = true
	get_node("UploadButton").visible = false

func hideLoading():
	get_node("LoadingSprite").visible = false
	get_node("UploadButton").visible = true

func _on_upload_button_pressed():
	SoundHandler.playSFX("Place")
	var worldnameinvalid = false
	var usernameinvalid = false
	if(len(get_node("WorldNameInput").text) < 1):
		worldnameinvalid = true
		get_node("WorldNameLabel").modulate = Color(1,0,0)
	else:
		get_node("WorldNameLabel").modulate = Color(1,1,1)
	if(len(get_node("UsernameInput").text) < 1):
		usernameinvalid = true
		get_node("UsernameLabel").modulate = Color(1,0,0)
	else:
		get_node("UsernameLabel").modulate = Color(1,1,1)
	if(worldnameinvalid or usernameinvalid or valid == false):
		SoundHandler.playSFX("Error")
		return false
	
	SettingsMenu.settingsdata["onlineusername"] = get_node("UsernameInput").text
	username = get_node("UsernameInput").text
	FileHandler.saveSettingsToFile(SettingsMenu.settingsdata)
	MouseController.theworld.onlineworldname = get_node("WorldNameInput").text
	worldname = get_node("WorldNameInput").text
	FileHandler.saveWorldToFile(MouseController.theworld, Globs.currentworldfileaddress)
	date = Time.get_datetime_string_from_system(true).split("T")[0]
	
	var fadetween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	fadetween.tween_property(self, "modulate", Color(1,1,1,0), 0.5)
	fadetween.tween_callback(takeThumbnail)
	fadetween.tween_interval(0.5)
	fadetween.tween_property(self, "modulate", Color(1,1,1,1), 0.5)
	fadetween.tween_callback(showLoading)
	fadetween.tween_interval(1)
	fadetween.tween_callback(makePostRequest)
	

func takeThumbnail():
	var thumb = get_tree().get_root().get_texture().get_image()
	thumb.shrink_x2()
	thumb.shrink_x2()
	thumbtopost = Marshalls.raw_to_base64(thumb.save_png_to_buffer())
	thumb.save_png("user://lookatme.png")
	SoundHandler.playSFX("CameraSnap")

func _on_exit_button_pressed():
	Globs.inworld = true
	self.queue_free()


func _on_dimensions_button_pressed():
	pass


func _on_click_mask_timer_timeout():
	get_node("LilClickMask").visible = false

func makePostRequest():
	var updata = {"uid": MouseController.theworld.onlineuid, "worldname": worldname, 
					"username": username, "date": date, "thumbnail": thumbtopost}
	
	var body = JSON.stringify(updata)
	var headers = ["Content-Type: application/json"]
	httpreq.request("http://" + Globs.IPANDPORT + Globs.POSTWORLDURL, headers, HTTPClient.METHOD_POST, body)

func _on_http_request_request_completed(_result, response_code, _headers, _body):
	hideLoading()
	if(str(response_code) == "200"):
		get_node("SatelliteValid").text = uploadsuccessstring
	else:
		get_node("SatelliteValid").text = uploadfailstring
