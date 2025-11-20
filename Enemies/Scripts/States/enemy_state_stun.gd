class_name EnemyStateStun extends EnemyState

@export var anim_name : String = "stun"
@export var knockback_speed : float = 3000.0
@export var decelerate_speed : float = 1800.0

@export_category("AI")
@export var next_state : EnemyState

var _animation_finished := false
var _damage_position : Vector2
var _direction := Vector2.ZERO

func init() -> void:
	enemy.enemy_damaged.connect(_on_enemy_damage)

func enter() -> void:
	enemy.invunlerable = true
	_animation_finished = false
	

	_direction = (enemy.global_position - _damage_position).normalized()
	enemy.velocity = _direction * knockback_speed

	# Start animation if needed
	# enemy.update_animation(anim_name)
	#enemy.animation_player.animation_finished.connect(_on_animation_finished)

	_on_animation_finished() # or wait for real animation

func exit() -> void:
	enemy.invunlerable = false
	#enemy.animation_player.animation_finished.disconnect(_on_animation_finished)

func process(_delta: float) -> EnemyState:
	if _animation_finished:
		return next_state
	return null

func physics(_delta: float) -> EnemyState:
	# Smooth deceleration
	enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, decelerate_speed * _delta)
	return null

func _on_enemy_damage(hurt_box : HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.change_state(self)

func _on_animation_finished() -> void:
	_animation_finished = true
	
