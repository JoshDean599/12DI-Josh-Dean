extends Sprite2D

@onready var game = get_parent().get_parent()

var hitOnRelease = false
var active = false # If it's been hit
var StartTime = 0
var StartOffset = 0
var EndTime = 0
var EndOffset = 0

func set_times(settings : Dictionary) -> void:
	StartTime = settings.StartTime
	StartOffset = settings.StartOffset
	EndTime = settings.EndTime
	EndOffset = settings.EndOffset

func _ready() -> void:
	position = Vector2((game.time - StartTime) * game.noteSpeed, StartOffset)
	$Tail.position = Vector2(EndTime * game.noteSpeed, EndOffset)
	
	game.releasedKey.connect(onKeyReleased)

func _process(_delta: float) -> void:
	position.x = -(game.time - StartTime) * game.noteSpeed
	
	if active and StartTime + EndTime <= game.time:
		clear_note()
		active = false
	
	if game.time > StartTime + EndTime + 2: # +2 Seconds
		free_note()

func check_hit():
	if StartTime - GameData.Scores.Bad.min <= game.time and ( # Check that it's within range
		game.time) <= StartTime + GameData.Scores.Bad.max:
		print("Hit Note")
		modulate = Color(0.0, 1.0, 0.0, 0.243)
		if EndTime == 0: # If it's a tap note, clear it instantly
			clear_note()
		else: # If it's a hold note, set it to active
			active = true
	else:
		missed_note()

func missed_note():
	print("Missed Note")
	modulate = Color(1.0, 1.0, 1.0, 0.243)
	await get_tree().create_timer(2).timeout
	free_note()

func clear_note():
	var score = "bad"
	for i in GameData.Scores:
		if game.time - (StartTime + EndTime) > -GameData.Scores[i].min and (
			game.time - (StartTime + EndTime)) < GameData.Scores[i].max:
			score = i
			break
	print("Cleared Note With The Score: ", score)
	await get_tree().create_timer(2).timeout
	free_note()

func free_note():
	if game.noteQueue.size() > 0:
		game.noteQueue.pop_at(game.noteQueue.find(self))
	queue_free()

func onKeyReleased():
	if active:
		if StartTime + EndTime - GameData.Scores.Bad.min <= game.time and ( #Check that it's within range
			game.time) <= StartTime + EndTime + GameData.Scores.Bad.max:
			clear_note()
		else:
			missed_note()
		active = false
	
	if hitOnRelease:
		clear_note()
