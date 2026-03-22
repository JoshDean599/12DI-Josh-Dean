extends Node2D

# Set constant before game start
const IN_EDIT_MODE: bool = false
var currentLevelName: String = "1"

var levelInfo = {
	"1" = {
		fkTimes = [
			[1],
			[2],
			[3],
			[4]
		],
		music = load("res://Music/NEFFEX - Hate It or Love It [Copyright Free] No.82.wav")
		
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$MusicPlayer.stream = levelInfo[currentLevelName].music
	$MusicPlayer.play()
	
	if IN_EDIT_MODE:
		Signals.KeyListenerPress.connect(KeyListenerPress)
	else:
		var fkTimes = levelInfo[currentLevelName].fkTimes
		
		var counter: int = 0
		for key in fkTimes:
			var buttonName: String = ""
			match counter:
				0:
					buttonName = "button_D"
				1:
					buttonName = "button_F"
				2:
					buttonName = "button_J"
				3:
					buttonName = "button_K"
			
			for delay in key:
				SpawnFallingKey(buttonName, delay)
			
			counter += 1

func KeyListenerPress(buttonName: String, arrayNum: int):
	pass

func SpawnFallingKey(buttonName: String, delay: float):
	await get_tree().create_timer(delay).timeout
	Signals.CreateFallingKey.emit(buttonName	)
