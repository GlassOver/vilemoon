class_name PlayerStateJump extends PlayerState

@export var jump_velocity : float = 600
@export var jump_gravity_multiplier : float = 2.5
@export var jump_velocity_override: float = 0

var super_speed_multiplier: float = 1.0  
var fixed_jump: bool = false

func init() -> void:
	pass

func enter() -> void:
	player.gravity_multiplier = 1.0

	if jump_velocity_override != 0:
		player.velocity.y = -jump_velocity_override * super_speed_multiplier
		jump_velocity_override = 0
	else:
		player.velocity.y = -jump_velocity * super_speed_multiplier
	
	if player.previousState == fall and not Input.is_action_pressed("jump"):
		await get_tree().physics_frame
		player.velocity.y *= 0.5
		player.changeState(fall)
		pass
		

func exit() -> void:
	# Reset everything to safe defaults
	player.gravity_multiplier = 1.0
	fixed_jump = false
	super_speed_multiplier = 1.0

func handleInput(event : InputEvent) -> PlayerState:
	if Input.is_action_just_pressed("attack"):
		return attack

	if not fixed_jump and event.is_action_released("jump"):
		player.velocity.y *= 0.5
		return fall
		
	if Input.is_action_just_pressed("dodge") and player.dodgeTimer <= 0:
		return dodge
	
	return nextState

func process(_delta: float) -> PlayerState:
	return nextState

func physics_process(_delta: float) -> PlayerState:
	var k := super_speed_multiplier
	var scaled_base := 1.0 * k * k

	if player.velocity.y < 0:
		if not fixed_jump and Input.is_action_pressed("jump"):
			player.gravity_multiplier = jump_gravity_multiplier * k * k
		else:
			player.gravity_multiplier = scaled_base
	else:
		player.gravity_multiplier = 1.0

	# State transitions
	if player.ledge_left.is_colliding() and player.velocity.y > 0:
		return ledgegrab
	if player.is_on_floor():
		return idle
	elif player.velocity.y >= 0:
		return fall

	# Horizontal control while jumping
	player.velocity.x = player.direction.x * player.jump_move_speed
	return nextState
