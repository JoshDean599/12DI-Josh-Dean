extends Sprite2D

@onready var game = get_parent().get_parent()

var settings = {}
var active = false

func _ready() -> void:
	position = Vector2(settings.time * game.noteSpeed, settings.offset)
	$Tail.position = Vector2(settings.tailTime * game.noteSpeed, settings.tailOffset)

func _process(_delta: float) -> void:
	
	if active:
		if game.holding:
			self_modulate = Color(0.321, 0.819, 0.0, 1.0)
			if game.time >= settings.time + settings.tailTime:
				free_note()
			pass
		else:
			free_note()
	elif game.time >= settings.time:
		free_note()

func free_note():
	game.noteQueue.pop_at(game.noteQueue.find(self))
	queue_free()
