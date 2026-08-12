extends Node2D

var time = 0
var offset = 0
var tailTime = 0
var tailOffset = 0

var dragging = false

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
	$Tail.position.y = tailOffset * DisplayServer.window_get_size().y / (get_tree().current_scene.YCollumnHeight + 1)

func _on_head_detector_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1: # Left Click
			if event.pressed:
				dragging = true
				clickPosition = get_global_mouse_position() - global_position
			else:
				dragging = false
		elif event.button_index == 2: # Right Click
			if event.pressed:
				clickPosition = DisplayServer.mouse_get_position()
				clickTime = Time.get_ticks_msec() / 1000.0
			else:
				if clickPosition == DisplayServer.mouse_get_position() and Time.get_ticks_msec() / 1000.0 - clickTime < 0.25:
					queue_free()
	elif event is InputEventMouseMotion and dragging:
		var snap = snapped(get_global_mouse_position().x - clickPosition.x - get_parent().position.x, get_tree().current_scene.noteMoveSpeed)
		time = snap / get_tree().current_scene.noteMoveSpeed
		# Limit the time to be equal to or greater than 0
		if time < 0:
			time = 0
		snap = DisplayServer.window_get_size().y / (get_tree().current_scene.YCollumnHeight + 1)
		offset = snapped(get_global_mouse_position().y - clickPosition.y, snap) / snap
		# Limit the offset to be within the screen size
		if offset < 1:
			offset = 1
		elif offset > get_tree().current_scene.YCollumnHeight:
			offset = get_tree().current_scene.YCollumnHeight
		# Adjust the tailOffset if it would go offscreen
		if tailOffset + offset < 1:
			tailOffset = -offset + 1
		elif tailOffset > get_tree().current_scene.YCollumnHeight - offset:
			tailOffset = get_tree().current_scene.YCollumnHeight - offset
		update_position()

func _on_tail_detector_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1: # Left Click
			if event.pressed:
				dragging = true
				clickPosition = get_global_mouse_position() - $Tail.position
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		var snap = snapped(get_global_mouse_position().x - clickPosition.x, get_tree().current_scene.noteMoveSpeed)
		tailTime = snap / get_tree().current_scene.noteMoveSpeed
		# Limit the time to be equal to or greater than 0
		if tailTime < 0:
			tailTime = 0
		snap = DisplayServer.window_get_size().y / (get_tree().current_scene.YCollumnHeight + 1)
		tailOffset = snapped(get_global_mouse_position().y - clickPosition.y, snap) / snap
		# Limit the tailOffset to the max size
		if tailOffset + offset < 1:
			tailOffset = -offset + 1
		elif tailOffset > get_tree().current_scene.YCollumnHeight - offset:
			tailOffset = get_tree().current_scene.YCollumnHeight - offset
		update_position()
