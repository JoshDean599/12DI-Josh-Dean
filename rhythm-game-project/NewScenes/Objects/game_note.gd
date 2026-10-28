extends Sprite2D

@onready var game = get_parent().get_parent()

var settings = {}
var hitOnRelease = false
var holding = false

func _ready() -> void:
	position = Vector2((game.time - settings.time) * game.noteSpeed, settings.offset)
	$Tail.position = Vector2(settings.tailTime * game.noteSpeed, settings.tailOffset)
	
	game.pressedKey.connect(onKeyPressed)
	game.releasedKey.connect(onKeyReleased)
	game.stoppedHolding.connect(onStopHolding)

func _process(_delta: float) -> void:
	position.x = -(game.time - settings.time) * game.noteSpeed
	
	if not holding and game.time >= settings.time + GameData.Scores.Miss.min:
		missed_note()

func hit_note():
	if settings.time - GameData.Scores.Bad.min < game.time and game.time < settings.time + GameData.Scores.Bad.max:
		print("Success")
		free_note()
	elif settings.time - GameData.Scores.Miss.min < game.time and game.time < settings.time + GameData.Scores.Miss.max:
		missed_note()

func missed_note():
	print("Missed")
	free_note()

func free_note():
	game.noteQueue.pop_at(game.noteQueue.find(self))
	queue_free()

func onKeyPressed():
	holding = true
	hit_note()

func onKeyReleased():
	if hitOnRelease:
		hit_note()

func onStopHolding():
	holding = false
