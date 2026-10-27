extends Node2D

@onready var timeHandler = $TimeHandler

func _on_visibility_changed() -> void:
	if not is_node_ready():
		return
	if visible:
		$ScoreHandler.score = 0
		$ScoreHandler.incriment_score(0) # Update the score visual to correctly show the score
		play()
	else:
		print("Leaving game area")
		pause()

func play():
	$CanvasLayer/GameEndCard.visible = false
	if get_parent().get_map() == {}:
		return
	var startTime = DisplayServer.window_get_size().x / get_parent().noteMoveSpeed - get_parent().get_map().bufferTime + 1
	if startTime < 0:
		startTime = 0
	timeHandler.play(-startTime)
	if get_parent().get_map_properties() != {}:
		timeHandler.set_music(get_parent().get_map_properties().song)
	$NoteHandler.load_song()
	$NoteHandler.active = true

func pause():
	timeHandler.pause()
	$NoteHandler.active = false
