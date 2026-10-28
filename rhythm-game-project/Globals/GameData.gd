extends Node

var SelectedMap = ""
var SelectedDifficulty = ""

var Scores = {
	Perfect = {
		min = .06,
		max = .06,
		score = 100
	},
	Good = {
		min = 0.15,
		max = 0.15,
		score = 50
	},
	Ok = {
		min = 0.25,
		max = 0.25,
		score = 25
	},
	Bad = {
		min = 0.5,
		max = 0.5,
		score = 10
	},
	Miss = {
		min = 1,
		max = 1,
		score = 0
	}
}
