class_name PlayerStateAttack extends PlayerState

#@onready var animation_player : AnimationPlayer = $".../.../AnimationPlayer"
@onready var sword_collider: CollisionShape2D = %Sword_Collider
@onready var sword_collider_up: CollisionShape2D = %Sword_Collider2
@onready var sword_audio: AudioStreamPlayer2D = $"../../SwordAudio"
@onready var horiz_slash: Sprite2D = $"../../HurtBox/HorizSlash"
@onready var vert_slash: Sprite2D = $"../../HurtBox/VertSlash"


@export_range(1,20,0.5) var decelerate_speed : float = 1.01

var attacking : bool = false
var tempAttackTime : float = 0.0
var tempAttackTimer : float = 0.05        



func enter() -> void:
	sword_audio.play()
	#player.UpdateAnimation("attack")
	#animation_player.animation_finished.connect(EndAttack)
	if not Input.is_action_pressed("up"):
		%Sword_Collider.disabled = false
		horiz_slash.visible = true
	else:
		%Sword_Collider2.disabled = false
		vert_slash.visible = true
	attacking = true
	tempAttackTime = tempAttackTimer
	
	pass

func exit() -> void:
	#animation_player.animation_finished.disconnect(EndAttack)
	%Sword_Collider.disabled = true
	horiz_slash.visible = false
	%Sword_Collider2.disabled = true
	vert_slash.visible = false
	attacking = false
	player.attackTimer = player.attackCooldown
	

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
