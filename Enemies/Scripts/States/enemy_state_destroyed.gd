class_name EnemyStateDestroy extends EnemyState

@export var anim_name : String = "destroy"
@export var knockback_speed : float = 3000.0
@export var decelerate_speed : float = 1800.0

@export_category("AI")


var _damage_position : Vector2
var _direction := Vector2.ZERO

func init() -> void:
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)

func enter() -> void:
	enemy.invunlerable = true
	_direction = (enemy.global_position - _damage_position).normalized()
	enemy.velocity = _direction * knockback_speed
	# Start animation if needed
	# enemy.update_animation(anim_name)
	_on_animation_finished() # or wait for real animation

func exit() -> void:
	pass
	
	
func process(_delta: float) -> EnemyState:
	return 

func physics(_delta: float) -> EnemyState:
	# Smooth deceleration
	enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, decelerate_speed * _delta)
	return null

func _on_enemy_destroyed(hurt_box : HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.change_state(self)

func _on_animation_finished() -> void:
	enemy.queue_free()
	
