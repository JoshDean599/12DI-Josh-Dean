extends Node2D

var time = 0
var offset = 0
var tailTime = 0
var tailOffset = 0

var dragging = 0 # 0 == not dragging, 1 == dragging head, 2 == dragging tail
var drag_offset = Vector2.ZERO

var clickPosition = Vector2.ZERO
var clickTime = 0

func _ready() -> void:
	get_viewport().size_changed.connect(on_window_size_changed)

func on_window_size_changed():
	update_position()

func update_position() -> void:
	position.x = time * get_tree().current_scene.noteMoveSpeed
	position.y = offset * float(DisplayServer.window_get_size().y) / (get_tree().current_scene.YCollumnHeight + 1)
	
	$Tail.position.x = tailTime * get_tree().current_scene.noteMoveSpeed
	$Tail.position.y = DisplayServer.window_get_size().y * tailOffset


func _on_head_detector_button_down() -> void:
	dragging = 1
	print("Dragging")

func _on_head_detector_button_up() -> void:
	pass # Replace with function body.

func _on_tail_detector_button_down() -> void:
	pass # Replace with function body.

func _on_tail_detector_button_up() -> void:
	pass # Replace with function body.


func _on_head_detector_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 2:
		if event.pressed:
			clickPosition = DisplayServer.mouse_get_position()
			clickTime = Time.get_ticks_msec() / 1000.0
		else: #Onrelease
			if clickPosition == DisplayServer.mouse_get_position() and Time.get_ticks_msec() / 1000.0 - clickTime < 0.25:
				queue_free()
