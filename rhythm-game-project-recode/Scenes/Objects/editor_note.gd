extends Node2D

var time = 0
var offset = 0
var tailTime = 0
var tailOffset = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_position() -> void:
	position.x = time * get_tree().current_scene.noteMoveSpeed
	position.y = offset
	
	$Tail.position.x = tailTime * get_tree().current_scene.noteMoveSpeed
	$Tail.position.y = DisplayServer.window_get_size().y * tailOffset
