extends Node

func play():
	$Audio.play()

func pause():
	$Audio.stop()

func load_song(song, file):
	if file:
		if Globals.load_song(Globals.mapPath + song + ".json").Song != "":
			$Audio.stream = load(Globals.musicPath + Globals.load_song(Globals.mapPath + song + ".json").Song + ".wav")
	else:
		$Audio.stream = load(Globals.musicPath + song + ".wav")
