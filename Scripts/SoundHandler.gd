extends Node

onready var pickupsound = get_tree().get_root().get_node("AllSounds/Pickup")
onready var placesound = get_tree().get_root().get_node("AllSounds/Place")
onready var coinclinksound = get_tree().get_root().get_node("AllSounds/Coinclink")
onready var normalboop = get_tree().get_root().get_node("AllSounds/NormalBoop")
onready var errorsound = get_tree().get_root().get_node("AllSounds/Error")
onready var winsound = get_tree().get_root().get_node("AllSounds/Win")
onready var voidinputsound = get_tree().get_root().get_node("AllSounds/VoidInput")
onready var voidoutputsound = get_tree().get_root().get_node("AllSounds/VoidOutput")
onready var buttonsound = get_tree().get_root().get_node("AllSounds/ButtonSound")

onready var sfxdict = {
	"pickup": pickupsound,
	"place": placesound,
	"coinclink": coinclinksound,
	"normalboop": normalboop,
	"error": errorsound,
	"win": winsound,
	"voidinput": voidinputsound,
	"voidoutput": voidoutputsound,
	"button": buttonsound
}

func _ready():
	pass

func playSFX(soundtoplay):
	sfxdict[soundtoplay].play()
