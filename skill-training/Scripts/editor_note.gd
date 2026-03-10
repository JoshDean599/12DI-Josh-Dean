extends Sprite2D

const GRID_SIZE: Vector2 = Vector2(100, 100)
var dragging = false
var draggedOffset = Vector2.ZERO #Offset

const doubleClickThreshold = 0.2
var lastClickTime = 0.0
var openMenu = false
@onready var clickTimer = $ClickDetector/Timer
@onready var menu = $Menu
@onready var SPINBOX = $Menu/MarginContainer/VBoxContainer/HBoxContainer/SpinBox

func _ready() -> void:
	menu.visible = false

func _process(delta: float) -> void:
	if dragging:
		if Input.is_action_pressed("spaceBarPressed"):
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
	if openMenu:
		openMenu = false
		menu.visible = !menu.visible

func _on_click_detector_button_down() -> void:
	dragging = true
	draggedOffset  = get_global_mouse_position() - global_position
	
	var currentTime = Time.get_ticks_msec() / 1000.0
	if currentTime - lastClickTime <= doubleClickThreshold:
		clickTimer.stop()
		openMenu = true
	else:
		clickTimer.start(doubleClickThreshold)
	lastClickTime = currentTime

func _on_click_detector_button_up() -> void:
	dragging = false
