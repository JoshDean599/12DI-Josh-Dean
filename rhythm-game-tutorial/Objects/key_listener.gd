extends Sprite2D

@onready var fallingKey = preload("res://Objects/falling_key.tscn")
@export var keyName: String = ""

var fallingKeyQueue = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_released(keyName):
		visible = true
	
	if fallingKeyQueue.size() > 0:
		if fallingKeyQueue.front().hasPassed:
			fallingKeyQueue.pop_front()
		if Input.is_action_just_pressed(keyName):
			visible = false
			#create_falling_key()

func create_falling_key():
	var fkInstance = fallingKey.instantiate()
	get_tree().get_root().call_deferred("add_child", fkInstance)
	fkInstance.setup(position.x)
	
	fallingKeyQueue.push_back(fkInstance)


func _on_random_spawn_timer_timeout() -> void:
	create_falling_key()
	$RandomSpawnTimer.wait_time = randf_range(0.4, 3)
	$RandomSpawnTimer.start()
