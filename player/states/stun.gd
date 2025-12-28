class_name PlayerStateStun extends PlayerState


@export var knockback_speed : float = 8000.0
@export var decelerate_speed : float = 500.0
@export var invulnerable_duration : float = 1.0



var hurt_box : HurtBox
var direction : Vector2
var gravity_multiplier : float = 0.3

var next_state : PlayerState = null


func init() -> void:
	player.player_damaged.connect(_player_damaged)
	pass
	
	
func _ready():
	pass


func enter() -> void:
	#player.animation_player.animation_finished.connect(_animation_finished)
	print("Stunned")

	direction = player.global_position.direction_to(hurt_box.global_position)
	direction.y = clampf(direction.y, -.5, +.5)
	direction.y /= 100
	player.velocity = direction * -knockback_speed
	
	
	player.make_invulnerable(invulnerable_duration)
	#player.effect_animation_player.play("damaged")
	_animation_finished()
	pass
	
func _animation_finished():
	if player.health == 0:
		SaveManager.load_game()
		return death
	pass
	
func process(_delta : float ) -> PlayerState:
	player.velocity -= player.velocity * decelerate_speed * _delta	
	return next_state

	
# What happens each physics process tick in this state?
func physics_process(_delta: float) -> PlayerState:
	return null
	
func exit() -> void:
	print("exited")
	#player.animation_player.animation_finished.connect(_animation_finished)
	pass

func _player_damaged(_hurt_box : HurtBox) :
	#print("damaged2")
	hurt_box = _hurt_box
	enter()
	return 
	

	
