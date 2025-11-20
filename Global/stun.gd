class_name PlayerStateStun extends PlayerState


@export var knockback_speed : float = 5000.0
@export var decelerate_speed : float = 500.0
@export var invulnerable_duration : float = 1.0

var hurt_box : HurtBox
var direction : Vector2
var gravity_multiplier : float = 0.3

var next_state : PlayerState = null


func init() -> void:
	player.player_damaged.connect(_player_damaged)
	pass


func enter() -> void:
	#player.update_animation("stun")
	#player.animation_player.animation_finished.connect(_animation_finished)
	print("Stunned")
	direction = player.global_position.direction_to(hurt_box.global_position)
	player.velocity = direction * -knockback_speed
	
	player.make_invulnerable(invulnerable_duration)
	#player.effect_animation_player.play("damaged")
	_animation_finished()
	pass
	

# What happens when we exit this state?
func exit() -> void:
	print("exited")
	next_state = null
	#player.animation_player.animation_finished.connect(_animation_finished)
	pass


# What happens when an input is pressed?
func handleInput(_event: InputEvent) -> PlayerState:
	return nextState


# What happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	return nextState
	

# What happens each physics process tick in this state?
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor() == false:
		return fall
	return nextState
	

func _player_damaged(_hurt_box : HurtBox) :
	print("damaged2")
	hurt_box = _hurt_box
	enter()
	return 
	
func _animation_finished():
	print("erm")
	return idle
	
