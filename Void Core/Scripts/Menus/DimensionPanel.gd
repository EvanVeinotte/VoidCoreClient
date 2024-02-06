extends Control

var uid
var worldname
var username
var date
var thumbnail

func _ready():
	get_node("Panel/WorldName").text = worldname
	get_node("Panel/Username").text = username
	get_node("Panel/Date").text = date
	var thumbnailimg = Image.new()
	var loadsuccess = thumbnailimg.load_png_from_buffer(thumbnail)
	if(loadsuccess == OK):
		get_node("Panel/TextureRect").texture = ImageTexture.create_from_image(thumbnailimg)

func _on_go_button_pressed():
	pass # Replace with function body.
