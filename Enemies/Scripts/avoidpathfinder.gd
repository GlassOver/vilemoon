class_name AvoidPathfinder extends Node2D

@export var desired_distance := 370.0
@export var distance_strength := 3.0
@export var obstacle_strength := 4.0
@export var max_force := 1.0
@export var smoothing := 8.0

var rays: Array[RayCast2D] = []
var move_dir := Vector2.ZERO
var target_move_dir := Vector2.ZERO   # NEW

@onready var timer: Timer = $Timer


func _ready() -> void:
	for c in get_children():
		if c is RayCast2D:
			rays.append(c)

	timer.timeout.connect(_update_path)
	_update_path()


func _process(delta: float) -> void:
	# Smoothly rotate toward computed steering direction
	move_dir = move_dir.lerp(target_move_dir, smoothing * delta)


func _update_path() -> void:
	var target = PlayerManager.player.global_position
	var to_player = global_position.direction_to(target)
	var dist = global_position.distance_to(target)

	var steering := Vector2.ZERO

	# 1. Distance-keeping force
	var dead_zone : float = 10.0
	var dist_error : float = dist - desired_distance
	
	if abs(dist_error) > dead_zone:
		var norm : float = (abs(dist_error) - dead_zone) / desired_distance
		var strength : float = clamp(norm, 0.0, 1.0)
		strength = strength * strength
		
		var dir = to_player
		if dist_error < 0:
			dir = -dir
		steering += dir * strength * distance_strength


	# 2. Obstacle avoidance
	for ray in rays:
		if ray.is_colliding():
			var away = -(ray.target_position.normalized())
			steering += away * obstacle_strength

	# Clamp steering
	if steering.length() > max_force:
		steering = steering.normalized() * max_force

	target_move_dir = steering.normalized()
