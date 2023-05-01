extends Sprite

onready var speechbox = get_node("SpeechBox")

var thescript = [
	" ",
	"Hello child...",
	"I been waiting so long...",
	"For you to feeeed me...",
	"Click and hold to walk.",
	"Good...",
	"Now click yourself to enter build mode.",
	"Feed me the essence!",
	"More...",
	"One more...",
	"Ahhhh YESSSS!!!",
	"Your reward...",
	"Enter build mode and bridge to the machine...",
	"Get close to the machine...",
	"Now click the machine while not in build mode...",
	"Earn more essence...",
	"Now glut my maw once more...",
	"Again...",
	"Feed me one more...",
	"Goooooooooooood",
	"Now use your scroll wheel to zoom.",
	"Approach me and click me to enter the pause menu.",
	"Enter build mode and double click the machine to rotate.",
	"I have taught you everything I can...",
	"Now...",
	"Fill",
	"The",
	"Void",
]

const thescriptautoends = [
	true,
	true,
	true,
	true,
	false,
	true,
	false,
	false,
	false,
	false,
	true,
	true,
	true,
	false,
	false,
	false,
	false,
	false,
	false,
	true,
	false,
	false,
	false,
	true,
	true,
	true,
	true,
	true,
	
]

var scriptpos = 0

var triggers = {
	"FirstMoved": false,
	"FirstBuildModeEntered": false,
	"TotalEssenceFed": 0,
	"WaitingToGetClose": false,
	"CloseToTheMachine": false,
	"GameEntered": false,
	"EssenceEarned": false,
	"PHASETWO": false,
	"Zoomed": false,
	"DidPause": false,
	"RotatedMachine": false,
	"TutorialOver": false
}

func _ready():
	speechbox.connect("saytimedone", self, "_say_Timer_Done")
	
	if(Constants.DEVICE_TYPE == "Android" or Constants.DEVICE_TYPE == "iOS"):
		thescript[20] = "Now use two fingers on the screen to zoom."
	#sayLine()

func updateFromTriggers():
	
	if(triggers.TutorialOver):
		return
	
	if(!triggers.PHASETWO):
		if(triggers.FirstMoved):
			scriptpos = 5
		if(triggers.FirstBuildModeEntered):
			scriptpos = 7
		if(triggers.TotalEssenceFed == 1):
			scriptpos = 8
		if(triggers.TotalEssenceFed == 2):
			scriptpos = 9
		if(triggers.TotalEssenceFed == 3):
			scriptpos = 10
		if(triggers.WaitingToGetClose):
			scriptpos = 13
		if(triggers.CloseToTheMachine):
			scriptpos = 14
		if(triggers.GameEntered):
			scriptpos = 15
		if(triggers.EssenceEarned):
			scriptpos = 16
		if(triggers.TotalEssenceFed == 4):
			scriptpos = 17
		if(triggers.TotalEssenceFed == 5):
			scriptpos = 18
		if(triggers.TotalEssenceFed == 6):
			scriptpos = 19
	else:
		if(triggers.Zoomed):
			scriptpos = 21
		if(triggers.DidPause):
			scriptpos = 22
		if(triggers.RotatedMachine):
			scriptpos = 23
	
	sayLine()

func _say_Timer_Done():
	scriptpos += 1
	if(!triggers.TutorialOver):
		sayLine()

func sayLine():
	if(SettingsMenu.settingsdata.tutorialenabled):
		if(Constants.newworld):
			speechbox.sayText(thescript[scriptpos], thescriptautoends[scriptpos])
			if(scriptpos == 10):
				triggers.WaitingToGetClose = true
			if(scriptpos == 19):
				triggers.PHASETWO = true
			if(scriptpos == 27):
				triggers.TutorialOver = true
