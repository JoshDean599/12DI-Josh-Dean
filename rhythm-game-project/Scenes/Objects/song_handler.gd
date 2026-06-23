extends Node

# Handles eveything related to the song in both the game and editor

@onready var Audio = $Audio
@export var songLocation = "res://Songs"

var map = {}


func load_map(Map : String): # Used in game:
	
	if not Audio:
		Audio = $Audio # In case this gets called before @onready
	
	var mapLocation = songLocation + "/Maps/" + Map + ".json"
	if not FileAccess.open(mapLocation, FileAccess.READ): # If map can't be loaded: Return
		push_error("Map can't be found, Returning")
		return
	map = JSON.parse_string(FileAccess.get_file_as_string(mapLocation))
	
	load_song(songLocation + "/Music/" + map.Song + ".wav")
	

func load_song(Song): # The song file to load
	if not FileAccess.open(Song, FileAccess.READ):
		print(Song)
		push_error("Song can't be found, Returning")
		return
	
	Audio.stream = load(Song)

func play_song(PlayPosition: float):
	Audio.play()
	Audio.seek(PlayPosition) # Jump to the position to start the song from
	

func stop_song():
	Audio.stop()
