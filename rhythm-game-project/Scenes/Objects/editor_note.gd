extends Node2D

const GRID_SIZE: Vector2 = Vector2(100, 100)
var dragging = false
var draggedOffset = Vector2.ZERO
var resizing = false
var resizingOffset = Vector2.ZERO
@export var snappingKey = KEY_SPACE

const doubleClickThreshold = 0.2
var lastClickTime = 0.0
@onready var clickTimer = $Timer

var GridLockKeyPress = false
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		GridLockKeyPress = event.keycode == snappingKey

func _process(_delta: float) -> void:
	if dragging:
		if GridLockKeyPress:
			position = (get_global_mouse_position() - draggedOffset).snapped(GRID_SIZE)
		else:
			position = get_global_mouse_position() - draggedOffset
		var intName = int(name)
		if intName > 1:
			var lowerNote = get_parent().get_node(str(intName - 1))
			if lowerNote && position.x < lowerNote.position.x:
				var newName = lowerNote.name
				lowerNote.name = "PlaceHolderName"
				name = newName
				lowerNote.name = name
		if intName < get_parent().get_children().size():
			var upperNote = get_parent().get_node(str(intName + 1))
			if upperNote && position.x > upperNote.position.x:
				var newName = name
				name = "PlaceHolderName"
				upperNote.name = newName
				name = upperNote.name
	
	if resizing:
		$Tail.position = get_global_mouse_position()

func _on_click_detector_button_down() -> void:
	dragging = true
	draggedOffset  = get_global_mouse_position() - global_position
	
#	var currentTime = Time.get_ticks_msec() / 1000.0
#	if currentTime - lastClickTime <= doubleClickThreshold:
#		clickTimer.stop()
#		get_parent().get_parent().show_note_options()
#	else:
#		clickTimer.start(doubleClickThreshold)
#	lastClickTime = currentTime


func _on_click_detector_button_up() -> void:
	dragging = false


func _on_drag_detector_button_down() -> void:
	resizing = true
	resizingOffset = get_global_mouse_position() - global_position
	print(get_global_mouse_position())
	print($Tail.global_position)
	print(global_position)


func _on_drag_detector_button_up() -> void:
	resizing = false


func _on_drag_detector_mouse_entered() -> void:
	$Tail.scale = Vector2(1.1, 1.1)


func _on_drag_detector_mouse_exited() -> void:
	$Tail.scale = Vector2(1, 1)
