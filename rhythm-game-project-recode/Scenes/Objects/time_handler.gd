extends Node2D

@onready var audio = $AudioStreamPlayer
var bufferTime = 0.0
var buffering = true
var time = 0.0
var active = false

func reset():
	buffering = true
	bufferTime = get_tree().current_scene.map.bufferTime
	time = -bufferTime
	pass

func play():
	print("Play")
	active = true
	if not buffering:
		audio.play()
		audio.seek(time)

func pause():
	print("Pause")
	active = false
	audio.stop()

func finish(finishTime):
	Tween.new().tween_property(audio, "AudioStreamPlayer:volume_db", -100, finishTime) # >:(

	pass

func _process(delta: float) -> void:
	if not active:
		return
	if buffering:
		bufferTime -= delta
		if bufferTime <= 0:
			print("buffer end")
			buffering = false
			audio.play()
			audio.seek(0.0)
	
	time = audio.get_playback_position() - bufferTime
