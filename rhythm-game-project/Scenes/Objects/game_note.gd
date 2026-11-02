extends Sprite2D

@onready var game = get_parent().get_parent()

var active = false # If it's been hit
var finishedHoldNote = false
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
	position = Vector2(-(game.time - StartTime) * GameData.NoteSpeed, StartOffset)
	$Tail.position = Vector2(EndTime * GameData.NoteSpeed, EndOffset)
	$Line2D.points[1] = $Tail.position

func _process(_delta: float) -> void:
	if game.paused:
		return
	position.x = -(game.time - StartTime) * GameData.NoteSpeed
	
	if active:
		if not finishedHoldNote and StartTime + EndTime <= game.time:
			clear_note()
			finishedHoldNote = true
	else:
		if StartTime + GameData.Scores.Bad.max < game.time:
			missed_note()

func check_hit():
	if active:
		if (StartTime + EndTime) - GameData.Scores.Bad.min <= game.time and (
		game.time) <= StartTime + EndTime + GameData.Scores.Bad.max:
			clear_note()
		else:
			missed_note()
		return
	if StartTime - GameData.Scores.Bad.min <= game.time and ( # Check that it's within range
		game.time) <= StartTime + GameData.Scores.Bad.max:
		if EndTime == 0: # If it's a tap note, clear it instantly
			clear_note()
		else: # If it's a hold note, set it to active
			game.holdNoteQueue.push_back(self)
			modulate = Color(1.0, 0.392, 0.0, 0.243)
			active = true
	else:
		print("Missed Note")
		missed_note()

func missed_note():
	remove_from_queues()
	if active and not finishedHoldNote:
		finishedHoldNote = true
	if modulate == Color(1.0, 1.0, 1.0, 1.0) or modulate == Color(1.0, 0.392, 0.0, 0.243):
		modulate = Color(1.0, 1.0, 1.0, 0.243)
	await get_tree().create_timer(2).timeout
	queue_free()

func clear_note():
	modulate = Color(0.0, 1.0, 0.0, 0.243)
	remove_from_queues()
	if active:
		finishedHoldNote = true
	
	var score = "bad"
	for i in GameData.Scores:
		if game.time - (StartTime + EndTime) > -GameData.Scores[i].min and (
			game.time - (StartTime + EndTime)) < GameData.Scores[i].max:
			score = i
			game.update_score(GameData.Scores[i].score) # Increase the score
			break
	await get_tree().create_timer(2).timeout
	queue_free()

func remove_from_queues() -> void:
	if game.noteQueue.find(self) >= 0: # Remove from the note queue if found
		game.noteQueue.pop_at(game.noteQueue.find(self))
	if game.holdNoteQueue.find(self) >= 0: # Remove from the hold note queue if found
		game.holdNoteQueue.pop_at(game.holdNoteQueue.find(self))
