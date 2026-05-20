extends Node

var Audio = null

func load_song(song):
	if not Audio:
		Audio = $Audio
	$Audio.stream = load(Globals.basePath + "Music/" + Globals.load_song(Globals.basePath + "Maps/" + song + ".json").Song + ".wav")
	
