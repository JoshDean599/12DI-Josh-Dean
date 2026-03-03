extends Sprite2D

var dragging = false
var draggedOffset = Vector2.ZERO #Offset

const doubleClickThreshold = 0.2
var lastClickTime = 0.0
var openMenu = false
@onready var clickTimer = $ClickDetector/Timer
@onready var menu = $Menu

var currentName = "New Note :D"
var timeValue = 0.0


func _ready() -> void:
	menu.visible = false
	print($Menu/MarginContainer/VBoxContainer/HBoxContainer/SpinBox.value)

func _process(delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() - draggedOffset
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

func _on_spin_box_value_changed(value: float) -> void:
	timeValue = value

func set_time(newTime):
	print(newTime)
	pass
