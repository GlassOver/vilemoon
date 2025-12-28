class_name PlayerStateLedgeGrab extends PlayerState

@onready var mantle_audio: AudioStreamPlayer2D = $"../../MantleAudio"


@export var regular_jump_velocity: float = 600
@export var boosted_jump_velocity: float = 600   
@export var super_jump_speed_multiplier: float = 6  
@export var jump_buffer_time: float = 0.2
var jump_buffer_timer: float = 0.0

func init() -> void:
	pass

func enter() -> void:
	player.velocity = Vector2.ZERO
	player.gravity_multiplier = 0.0
	pass

func exit() -> void:
	player.gravity_multiplier = 1.0
	pass

func handleInput(event : InputEvent) -> PlayerState:
	if event.is_action_pressed("move_down"):
		return fall
	return nextState

func process(_delta: float) -> PlayerState:
	return nextState

func physics_process(_delta: float) -> PlayerState:
	if not player.ledge_left.is_colliding():
		player.gravity_multiplier = 1.0
		if jump_buffer_timer > 0.0:
			jump_buffer_timer = 0.0
			return jump
		return fall

	player.velocity = Vector2.ZERO
	player.gravity_multiplier = 0.0

	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
		if jump_buffer_timer > 0.0:
			jump_buffer_timer = 0.0
			if Input.is_action_pressed("up"):
				mantle_audio.play()
				jump.jump_velocity_override = boosted_jump_velocity
				jump.fixed_jump = true
				jump.super_speed_multiplier = super_jump_speed_multiplier
			else:
				jump.jump_velocity_override = regular_jump_velocity
				jump.fixed_jump = false
				jump.super_speed_multiplier = 1.0

			return jump

	jump_buffer_timer -= _delta
	return nextState
