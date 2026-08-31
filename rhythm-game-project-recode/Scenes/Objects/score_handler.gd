extends Node2D

var score = 0

@export var gameScoreLabel : Label
@export var endCardScoreLabel : Label

func incriment_score(amount) -> void:
	score += amount
	if gameScoreLabel:
		gameScoreLabel.text = "Score: " + str(score)
	if endCardScoreLabel:
		endCardScoreLabel.text = "Score: " + str(score)
