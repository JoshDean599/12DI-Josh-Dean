extends Node2D

@onready var audio = $AudioStreamPlayer
@onready var fadeTween: Tween
var time = 0.0
var bufferTime = 0.0
var active = false

func set_music(song: String):
	if ResourceLoader.exists("res://Assets/Songs/" + song + ".mp3"):
			$AudioStreamPlayer.stream = load("res://Assets/Songs/" + song + ".mp3")
	else:
		print("ERROR in loading the music")

func reset():
	time = -get_tree().current_scene.map.bufferTime

func play(startTime):
	time = startTime
	active = true
	audio.volume_db = 0
	if time >= 0:
		audio.play()
		audio.seek(time)

func pause():
	if fadeTween:
		fadeTween.kill()
	active = false
	audio.stop()

func finish(finishTime):
	if fadeTween:
		fadeTween.kill()
	fadeTween = create_tween()
	fadeTween.connect("finished", on_tween_finished)
	fadeTween.tween_property(audio, "volume_db", -80, finishTime + 2)

func on_tween_finished():
	pause()
	get_parent().get_node("CanvasLayer/GameEndCard").visible = true

func _process(delta: float) -> void:
	if not active:
		return
	if time < 0:
		time += delta
		return
	elif not audio.playing:
		bufferTime = time
		audio.play()
		audio.seek(0.0)
	
	time = audio.get_playback_position() + bufferTime
