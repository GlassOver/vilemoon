class_name EnemyStateWander extends EnemyState

const DIR_2 = [Vector2.RIGHT, Vector2.LEFT]

@export var anim_name : String = "walk"
@export_category("AI")
@export var state_animation_duration : float = 0.5
@export var state_cycles_min : int = 1
@export var state_cycles_max : int = 3

@export var next_state : EnemyState

var _timer : float = 0.0
var _direction : Vector2



# What happens when we enter this state?
func enter() -> void:
	enemy.wingsflutter.play()
	if enemy.wanderer == false:
		_timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration
		var rand = randi_range(0,3)
		_direction = enemy.DIR_4[rand]
		enemy.velocity = _direction * enemy.wander_speed
		enemy.set_direction(_direction)
	else:
		_timer = randi_range(state_cycles_min, state_cycles_max) * state_animation_duration
		var rand = randi_range(0,1)
		_direction = DIR_2[rand]
		enemy.velocity = _direction * enemy.wander_speed
		enemy.set_direction(_direction)
	#enemy.update_animation(anim_name)
	pass
	

# What happens when we exit this state?
func exit() -> void:
	enemy.wingsflutter.stop()
	pass


# What happens each process tick in this state?
func process(_delta: float) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return next_state
	return null
	

# What happens each physics process tick in this state?
func physics(_delta: float) -> EnemyState:
	# If we are not moving even though we should be, pick a new direction
	if enemy.velocity.length() < 1.0:
		_pick_new_direction()

	return null


func _pick_new_direction():
	if enemy.wanderer == false:
		var rand = randi_range(0, enemy.DIR_4.size() - 1)
		_direction = enemy.DIR_4[rand]
		enemy.velocity = _direction * enemy.wander_speed
		enemy.set_direction(_direction)
	else:
		var rand = randi_range(0,1)
		_direction = DIR_2[rand]
		enemy.velocity = _direction * enemy.wander_speed
		enemy.set_direction(_direction)
		
