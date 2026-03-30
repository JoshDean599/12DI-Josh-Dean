extends Control

var score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().get_parent().connect("IncrimentScore", IncrimentScore)
	
func IncrimentScore(incr: int):
	score += incr
	$CanvasLayer/ScoreLabel.text = str(score) + " pts"
