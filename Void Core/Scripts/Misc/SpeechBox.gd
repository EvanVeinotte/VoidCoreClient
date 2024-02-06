extends Control

var totaltext
var displayedtext
var positioninthetext
var doneadding = false
var autoclear

signal saytimedone

func _ready():
	pass

func sayText(texttosay, autocleartext=true):
	get_node("SayTimer").stop()
	doneadding = false
	autoclear = autocleartext
	positioninthetext = 0
	totaltext = texttosay
	displayedtext = ""
	plusOneLetter()


func plusOneLetter():
	displayedtext += totaltext[positioninthetext]
	if(totaltext[positioninthetext] != " " and Globs.inworld):
		get_node("SpeechSound").play(0)
	get_node("Label").text = displayedtext
	positioninthetext += 1
	if(positioninthetext >= len(totaltext)):
		doneadding = true
		if(autoclear):
			get_node("SayTimer").start(Globs.SPEECH_BOX_SPEED)
	else:
		get_node("LetterTimer").start(Globs.SPEECH_BOX_LETTER_SPEED)


func _on_LetterTimer_timeout():
	plusOneLetter()


func _on_SayTimer_timeout():
	positioninthetext = 0
	totaltext = ""
	displayedtext = ""
	get_node("Label").text = displayedtext
	emit_signal("saytimedone")
