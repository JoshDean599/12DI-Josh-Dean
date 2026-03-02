extends Sprite2D

var dragging = false
var of = Vector2.ZERO #Offset

var lastClickTime = 0.0
var openMenu = false
@export var doubleClickThreshold = 0.2
@onready var clickTimer = $ClickDetector/Timer
@onready var menu = $Menu

var currentName = "New Note :D"
@onready var timeValue = $Menu/MarginContainer/VBoxContainer/HBoxContainer/SpinBox


func _ready() -> void:
	menu.visible = false

func _process(delta: float) -> void:
	if dragging:
		position = get_global_mouse_position() - of
	if openMenu:
		openMenu = false
		menu.visible = !menu.visible
	

func _on_click_detector_button_down() -> void:
	dragging = true
	of  = get_global_mouse_position() - global_position
	
	var currentTime = Time.get_ticks_msec() / 1000.0
	print(currentTime)
	print(lastClickTime)
	print(doubleClickThreshold)
	if currentTime - lastClickTime <= doubleClickThreshold:
		clickTimer.stop()
		openMenu = true
	else:
		clickTimer.start(doubleClickThreshold)
	lastClickTime = currentTime or 0.0
	

func _on_click_detector_button_up() -> void:
	dragging = false
