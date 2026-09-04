extends VBoxContainer

var songButton = preload("res://Scenes/Objects/song_button.tscn")

func add_song(Name: String):
	var newButton = songButton.instantiate()
	newButton.song.text = Name
	add_child.call_deferred(newButton)

func clear_list():
	for i in get_children():
		i.queue_free()

func load_list(Path: String):
	var dir = DirAccess.
	pass

func refresh_list():
	pass
