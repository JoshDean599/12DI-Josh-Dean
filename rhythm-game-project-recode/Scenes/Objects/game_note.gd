extends Node2D

@onready var game = get_tree().current_scene.get_node("Game")
@onready var noteHandler = game.get_node("NoteHandler")
var settings = {}
var holdEndTime = 0

var active = false
var failed = false

func _ready() -> void:
	update_position()
	get_viewport().size_changed.connect(on_window_size_changed)

func on_window_size_changed():
	update_position()

func update_position() -> void:
	# Set the notes initial position
	global_position = Vector2(settings.time * get_tree().current_scene.noteMoveSpeed,
		settings.offset * float(DisplayServer.window_get_size().y) / (get_tree().current_scene.YCollumnHeight + 1))
	# Setup the notes tail position
	$Tail.position =  Vector2(settings.tailTime * get_tree().current_scene.noteMoveSpeed,
		settings.tailOffset * float(DisplayServer.window_get_size().y) / (get_tree().current_scene.YCollumnHeight + 1))

func _process(_delta: float) -> void:
	# Check if the note is held:
	var distanceFromHit = noteHandler.get_parent().time - holdEndTime
	if active:
		if noteHandler.holding:
			#First condition for hold notes, second for single notes
			if distanceFromHit >= 0 or holdEndTime - settings.time == 0: # Successfuly held note!
				if distanceFromHit < noteHandler.scores.Bad.max and distanceFromHit > -noteHandler.scores.Bad.min:
					on_success(distanceFromHit)
				else:
					on_fail()
				queue_free()
			else: # Holding note:
				# Update visuals
				if game.time - settings.time >= 0:
					$Head.position.x = (game.time - settings.time) * get_tree().current_scene.noteMoveSpeed
				$Tail.modulate = Color(0.0, 1.0, 0.0, 1.0)
				pass
		else: # Stopped holding Note -- Add some drop offset so you don't need to hold it for all the time to still pass it
			if distanceFromHit >= -noteHandler.scores.Bad.min:
				on_success(distanceFromHit)
			else:
				on_fail()
			queue_free()
			pass
	else:
		if distanceFromHit >= noteHandler.scores.Miss.min and not failed:
			on_fail()
			failed = true
	
	# Clear the note once it's no longer in use
	if not active and game.time > holdEndTime + noteHandler.scores.Miss.min:
		print("Freeing Note")
		queue_free()

func on_success(distanceFromHit) -> void:
	var score = "bad"
	for i in noteHandler.scores:
		if distanceFromHit > -noteHandler.scores[i].min and distanceFromHit < noteHandler.scores[i].max:
			score = i
			break
	print(score)
	game.incriment_score(noteHandler.scores[score].score)

func on_fail() -> void:
	print("fail")
