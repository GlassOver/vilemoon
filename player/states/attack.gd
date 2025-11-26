class_name PlayerStateAttack extends PlayerState

#@onready var animation_player : AnimationPlayer = $".../.../AnimationPlayer"
@onready var sword_collider: CollisionShape2D = %Sword_Collider
@export_range(1,20,0.5) var decelerate_speed : float = 1.01

var attacking : bool = false
var tempAttackTime : float = 0.0
var tempAttackTimer : float = 0.05        



func enter() -> void:
	#player.UpdateAnimation("attack")
	#animation_player.animation_finished.connect(EndAttack)
	%Sword_Collider.disabled = false
	attacking = true
	tempAttackTime = tempAttackTimer
	
	pass

func exit() -> void:
	#animation_player.animation_finished.disconnect(EndAttack)
	attacking = false
	player.attackTimer = player.attackCooldown
	%Sword_Collider.disabled = true

	pass

func handleInput(_event: InputEvent) -> PlayerState:
	return nextState

func process(_delta: float) -> PlayerState:
	tempAttackTime -= _delta

	
	EndAttack()
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return run
	return nextState

func physics_process(_delta: float) -> PlayerState:
	return nextState

func EndAttack() -> void:
	if tempAttackTime <= 0:
		attacking = false
