extends Sprite2D

@onready var fallingKey = preload("res://Objects/falling_key.tscn")
@export var keyName: String = ""

var fallingKeyQueue = []

var scores = {
	ok = {
		lower = 0,
		upper = 400,
		score = 50
	},
	perfect = {
		lower = 30,
		upper = 60,
		score = 200
	},
}

func _ready() -> void:
	Signals.CreateFallingKey.connect(create_falling_key)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed(keyName):
		var arrayNum = 0
		if keyName == "button_F":
			arrayNum = 1
		elif keyName == "button_J":
			arrayNum = 2
		elif keyName == "button_K":
			arrayNum = 3
		Signals.KeyListenerPress.emit(keyName, arrayNum)
	
	
	# Make sure there's a falling key to check for this given key
	if fallingKeyQueue.size() > 0:
		# If that falling key has passed, remove it from the queue
		if fallingKeyQueue.front().hasPassed:
			fallingKeyQueue.pop_front()
		# If key is pressed, pop from the queue and calculate score
		if Input.is_action_just_pressed(keyName):
			visible = false
			var keyToPop = fallingKeyQueue.pop_front()
			var distanceFromPass = abs(keyToPop.passedPosition - keyToPop.global_position.y)
			# Get score type
			var scoreType = "miss"
			for i in scores:
				if distanceFromPass > scores[i].lower and distanceFromPass < scores[i].upper:
					scoreType = i
			
			if scoreType != "miss":
				Signals.IncrimentScore.emit(scores[scoreType].score)
			
			keyToPop.queue_free()
	
	if Input.is_action_just_released(keyName):
		visible = true
	

func create_falling_key(buttonName: String):
	if buttonName == keyName:
		var fkInstance = fallingKey.instantiate()
		get_tree().get_root().call_deferred("add_child", fkInstance)
		fkInstance.setup(position.x)
		
		fallingKeyQueue.push_back(fkInstance)


func _on_random_spawn_timer_timeout() -> void:
	#create_falling_key()
	$RandomSpawnTimer.wait_time = randf_range(0.4, 3)
	$RandomSpawnTimer.start()
