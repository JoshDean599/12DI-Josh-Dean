extends Node

var SelectedMap = ""
var SelectedDifficulty = ""

var Scores = {
	Perfect = {
		min = .05,
		max = .05,
		score = 100
	},
	Good = {
		min = 0.1,
		max = 0.1,
		score = 50
	},
	Ok = {
		min = 0.2,
		max = 0.2,
		score = 25
	},
	Bad = {
		min = 0.3,
		max = 0.3,
		score = 10
	}
}
