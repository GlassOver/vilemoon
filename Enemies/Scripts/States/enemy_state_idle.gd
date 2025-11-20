class_name EnemyStateIdle extends EnemyState


@export var anim_name : String = "idle"

@export_category("AI")
@export var state_duration_min : float = 0.2
@export var state_duration_max : float = 0.7
@export var after_idle_state : EnemyState



var _timer : float = 0.0



# What happens when we enter this state?
func enter() -> void:
	enemy.velocity = Vector2.ZERO
	_timer = randf_range(state_duration_min, state_duration_max)
	#enemy.update_animation(anime_name)
	pass
	

# What happens when we exit this state?
func exit() -> void:
	pass


# What happens each process tick in this state?
func process(_delta: float) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return after_idle_state
	return null
	

# What happens each physics process tick in this state?
func physics(_delta: float) -> EnemyState:
	return null
