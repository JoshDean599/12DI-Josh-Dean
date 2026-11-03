extends Node2D

var bufferTime = 0

func _ready() -> void:
	load_song()

func load_song():
	print("loaded song in, ", get_parent().name)
	var dir = DirAccess.open(FileHandler.SongFolderPath + "/" + GameData.SelectedMap)
	for i in dir.get_files():
		if FileHandler.remove_type(i, ".mp3") != "":
			$AudioStreamPlayer.stream = AudioStreamMP3.load_from_file(
				FileHandler.SongFolderPath + "/" + GameData.SelectedMap + "/" + i
				)
			break

func play():
	$AudioStreamPlayer.play()

func play_at(time: float):
	if time < 0:
		bufferTime = time
		print("Set Buffer time")
	else:
		print("Playing audio")
		$AudioStreamPlayer.play(time)

func pause():
	$AudioStreamPlayer.stop()

func _process(delta: float) -> void:
	if bufferTime < 0:
		bufferTime += delta
		if bufferTime >= 0:
			play_at(bufferTime)
