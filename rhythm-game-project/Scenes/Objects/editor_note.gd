extends Node2D

# Editor note movement variables
var dragging = false
var draggedOffset = Vector2.ZERO
var tailDragging = false
var tailDraggingOffset = Vector2.ZERO
var clickPosition: Vector2i = Vector2i.ZERO
var clickTime = 0.0
@export var baseHeadScale: float = 1.0
@export var onHoverHeadScale: float = 1.1
@export var baseTailSize: float = 0.8
@export var onHoverTailSize: float = 1.1
@export var tailDragDetectorBaseScale: float = 2.0
@export var tailDragDetectorOffsetScale: float = 1.3

# Note Variables
var duration: float = 0
var noteType: int = 0



func _process(_delta: float) -> void:
	var gridSize = Vector2(Globals.noteMoveSpeed, Globals.noteMoveSpeed / 2)
	if dragging:
		if Globals.editorGridLockKeyPress:
			position = (get_global_mouse_position() - draggedOffset).snapped(gridSize)
		else:
			position = get_global_mouse_position() - draggedOffset
	
	if tailDragging:
		if Globals.editorGridLockKeyPress:
			$Tail.position = (get_global_mouse_position() - tailDraggingOffset).snapped(gridSize)
		else:
			$Tail.position = get_global_mouse_position() - tailDraggingOffset
		$Line2D.set_point_position(1, $Tail.position)


func _on_click_detector_button_down() -> void:
	dragging = true
	draggedOffset = get_global_mouse_position() - global_position


func _on_click_detector_button_up() -> void:
	dragging = false


func _on_click_detector_mouse_entered() -> void:
	$Head.scale = Vector2(onHoverHeadScale, onHoverHeadScale)


func _on_click_detector_mouse_exited() -> void:
	$Head.scale = Vector2(baseHeadScale, baseHeadScale)


func _on_drag_detector_button_down() -> void:
	tailDragging = true
	tailDraggingOffset = get_global_mouse_position() - $Tail.position
	
	$Head/ClickDetector.visible = false


func _on_drag_detector_button_up() -> void:
	tailDragging = false
	duration = abs($Head.position.x - $Tail.position.x)
	
	$Head/ClickDetector.visible = true
	if $Tail.position.x <= 30 and $Tail.position.x >= -30 and $Tail.position.y >= -30 and $Tail.position.y <= 30:
		$Tail.position = Vector2.ZERO
		$Tail/DragDetector.scale = Vector2(tailDragDetectorBaseScale, tailDragDetectorBaseScale)
	else:
		$Tail/DragDetector.scale = Vector2(tailDragDetectorOffsetScale, tailDragDetectorOffsetScale)


func _on_drag_detector_mouse_entered() -> void:
	$Tail.scale = Vector2(onHoverTailSize, onHoverTailSize)


func _on_drag_detector_mouse_exited() -> void:
	$Tail.scale = Vector2(baseTailSize, baseTailSize)


func _on_click_detector_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 2:
		if event.pressed:
			clickPosition = DisplayServer.mouse_get_position()
			clickTime = Time.get_ticks_msec() / 1000.0
		else:
			if clickPosition == DisplayServer.mouse_get_position() and Time.get_ticks_msec() / 1000.0 - clickTime < 0.25:
				queue_free()
