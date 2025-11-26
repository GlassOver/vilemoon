class_name PlayerStateDodge extends PlayerState

@export var air_vertical_gravity_multiplier: float = 0.4
@export var vertical_boost: float = 700.0
@export var air_drag: float = 0.60
@export var max_slowfall_speed: float = 120.0
@export var grounded_vertical_boost: float = 500.0
@export var grounded_vertical_speed_k: float = 2.5
@export var horizontal_momentum_keep: float = 0.75
@export var horizontal_momentum_decay: float = 0.90

var vertical_h_momentum: float = 0.0
var vertical_dodge: bool = false
var started_in_air: bool = false

var _dodge_dir: float = 0.0
var dodgeLength: float = 0.1
var dodgeDuration: float = 0
var k: float = 2.0


func enter() -> void:
	
	player.isDodging = true
	if player.isSliding == true:
		exit()
	dodgeDuration = dodgeLength
	started_in_air = not player.is_on_floor()
	vertical_dodge = Input.is_action_pressed("up")

	if vertical_dodge:
		if player.is_on_floor():
			player.velocity.y = -grounded_vertical_boost
			vertical_h_momentum = player.velocity.x * grounded_vertical_speed_k
			player.velocity.x = vertical_h_momentum
		else:
			player.velocity.y = -vertical_boost
			vertical_h_momentum = player.velocity.x * horizontal_momentum_keep
			player.velocity.x = vertical_h_momentum
			player.gravity_multiplier = air_vertical_gravity_multiplier

		return

	if abs(player.direction.x) > 0.01:
		_dodge_dir = sign(player.direction.x)
	else:
		_dodge_dir = 1.0 if player.facing_right else -1.0


func physics_process(delta):
	dodgeDuration -= delta
	
	if player.isSliding == true:
		exit()

	if vertical_dodge:
		if started_in_air and player.velocity.y > max_slowfall_speed:
			player.velocity.y = max_slowfall_speed

		vertical_h_momentum *= horizontal_momentum_decay
		player.velocity.x = vertical_h_momentum

		if dodgeDuration <= 0:
			return fall if started_in_air else idle

		return nextState

	var boosted := player.move_speed * k * k + 100
	player.velocity.x = _dodge_dir * boosted

	if not player.is_on_floor():
		player.velocity.x *= air_drag

	if dodgeDuration <= 0.0:
		if not player.is_on_floor():
			return fall
		return run

	return nextState


func exit() -> void:

	player.isDodging = false
	player.dodgeTimer = player.dodgeTime
	player.gravity_multiplier = 1.0
	vertical_dodge = false
	started_in_air = false
	vertical_h_momentum = 0.0
	_dodge_dir = 0.0
