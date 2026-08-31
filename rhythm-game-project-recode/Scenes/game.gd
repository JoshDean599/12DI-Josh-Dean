extends Node2D

@onready var timeHandler = $TimeHandler
var currentSong := ""
var active = false

func _on_button_pressed() -> void:
	pause()
	get_parent().change_scene("SongSelectMenu")

func _on_visibility_changed() -> void:
	if visible:
		await get_tree().create_timer(0).timeout
		get_tree().current_scene.load_map(currentSong)
		$CanvasLayer/GameEndCard.visible = false
		$ScoreHandler.score = 0
		$ScoreHandler.incriment_score(0) # Update the score visual to correctly show the score
		play()

func play():
	var startTime = DisplayServer.window_get_size().x / get_parent().noteMoveSpeed - get_parent().map.bufferTime + 1
	if startTime < 0:
		startTime = 0
	timeHandler.play(-startTime)
	$TimeHandler.set_music(get_parent().map.Song)
	$NoteHandler.active = true
	$NoteHandler.load_song()

func pause():
	timeHandler.pause()
	$NoteHandler.active = false
