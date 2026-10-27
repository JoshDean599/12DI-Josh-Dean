extends Node2D

@onready var HitMarker = $HitMarker
@onready var note = preload("res://NewScenes/Objects/game_note.tscn")

var paused = false
var loadedMap = null
var noteQueue = []
var noteSpeed = 500 # Maybe change it so each note has it's own speed?

var time = 0 # How long the song has played for

func _ready() -> void:
	loadedMap = FileHandler.get_map(GameData.SelectedMap, GameData.SelectedDifficulty)

func start():
	paused = false

func stop():
	paused = true

func finish():
	stop()

func set_time(newTime: float):
	time = newTime

func _process(delta: float) -> void:
	if paused:
		return
	time += delta
	
	$Notes.position.x = -noteSpeed * time
	

func create_note(noteSettings: Dictionary):
	var noteInstance = note.instantiate()
	$Notes.call_deferred("add_child", noteInstance)
	noteInstance.settings = noteSettings
	noteInstance.holdEndTime = noteSettings.time + noteSettings.tailTime
	
	# Add the note to the end of the note queue
	noteQueue.push_back(noteInstance)
