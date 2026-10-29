extends Sprite2D

var noteTime = 0
var noteOffset = 0
var tailTime = 0
var tailOffset = 0

var dragging = false
var clickPosition = Vector2.ZERO
var clickTime = 0

func update_position():
	position.x = noteTime * get_parent().get_parent().viewSpeed
	position.y = noteOffset
	# Rearrange notes within the Notes Node:
	while get_index() > 0 and position.x < get_parent().get_child(get_index() - 1).position.x:
		get_parent().move_child(self, get_index() - 1)
	while get_index() < get_parent().get_child_count() - 1 and position.x > get_parent().get_child(get_index() + 1).position.x:
		get_parent().move_child(self, get_index() + 1)
	
	$Tail.position.x = tailTime * get_parent().get_parent().viewSpeed
	$Tail.position.y = tailOffset

func _on_button_gui_input(event: InputEvent) -> void:
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
		noteTime = (get_global_mouse_position().x - clickPosition.x) / get_parent().get_parent().viewSpeed
		# Limit the time to be equal to or greater than 0
		if noteTime < 0:
			noteTime = 0
		noteOffset = get_global_mouse_position().y - clickPosition.y
		update_position()

func _on_tail_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == 1: # Left Click
			if event.pressed:
				dragging = true
				clickPosition = get_global_mouse_position() - $Tail.position
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		tailTime = (get_global_mouse_position().x - clickPosition.x) / get_parent().get_parent().viewSpeed
		# Limit the time to be equal to or greater than 0
		if tailTime < 0:
			tailTime = 0
		tailOffset = get_global_mouse_position().y - clickPosition.y
		update_position()
