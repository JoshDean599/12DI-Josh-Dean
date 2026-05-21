extends Node

func load_song(song):
	if Globals.load_song(Globals.mapPath + song + ".json").Song != "":
		$Audio.stream = load(Globals.musicPath + Globals.load_song(Globals.mapPath + song + ".json").Song + ".wav")
	
