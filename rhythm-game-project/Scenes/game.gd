extends Node2D

var Active = false

func _on_visibility_changed() -> void:
	Active = visible
	$GameUI/CanvasLayer.visible = visible
	
	if visible:
		$Camera2D.make_current()
