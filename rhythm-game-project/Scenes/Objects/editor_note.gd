extends Node2D

# Editor note movement variables
var time: float = 0.0
var offset: float = 0.0 # How far from the center the note is

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
@onready var editor = get_parent().get_parent()

# Note Variables
var duration: float = 0
var noteType: int = 0


func _process(_delta: float) -> void:
	if dragging:
		position.x = snapped(get_global_mouse_position().x - draggedOffset.x, editor.snapDistance * editor.songNoteMoveSpeed)
		position.y = snapped(get_global_mouse_position().y - draggedOffset.y, editor.songNoteMoveSpeed / 4.0)
		if position.x < 0: # Limit the x position
			position.x = 0
	
	if tailDragging:
		$Tail.position.x = snapped(get_global_mouse_position().x - tailDraggingOffset.x, editor.snapDistance * editor.songNoteMoveSpeed)
		$Tail.position.y = snapped(get_global_mouse_position().y - tailDraggingOffset.y, editor.songNoteMoveSpeed / 4.0)
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
		else: #Onrelease
			if clickPosition == DisplayServer.mouse_get_position() and Time.get_ticks_msec() / 1000.0 - clickTime < 0.25:
				queue_free()
