extends Node2D


@onready var camera: Camera2D = $Camera2D
@onready var ground: TileMap = $"../TileMap"


@export var horizontal_dead_zone := 50.0
@export var vertical_dead_zone := 80.0
@export var follow_speed := 9.0  


@export var look_ahead_distance := 100.0
@export var look_ahead_speed := 6.0
@export var look_ahead_threshold := 10.0  


@export var extra_vertical_margin := 1000.0



var limit_left := 0.0
var limit_right := 0.0
var limit_top := 0.0
var limit_bottom := 0.0
var is_player_bound := false

var camera_target := Vector2.ZERO
var deadzone_offset := Vector2.ZERO

func _ready():
	setup_camera_limits()

func _check_for_player():
	var player = PlayerManager.player
	if player:
		_on_player_bound()

func _on_player_bound():
	var player = PlayerManager.player
	is_player_bound = true
	print("Player found and bound to camera")
	print(player.global_position.x)
	position = player.global_position
	camera_target = position

func _physics_process(delta):
	var player := PlayerManager.player
	
	if not is_player_bound:
		_check_for_player()
		return
	
	var cam_pos = position
	var player_pos = player.global_position
	var player_vel = Vector2.ZERO
	
	if "velocity" in player:
		player_vel = player.velocity
	elif "linear_velocity" in player:
		player_vel = player.linear_velocity

	var desired_offset_x = 0.0
	if abs(player_vel.x) > look_ahead_threshold:
		desired_offset_x = sign(player_vel.x) * look_ahead_distance

	deadzone_offset.x = lerp(deadzone_offset.x, desired_offset_x, clamp(look_ahead_speed * delta, 0.0, 1.0))
	deadzone_offset.y = -60 


	var left = cam_pos.x - horizontal_dead_zone + deadzone_offset.x
	var right = cam_pos.x + horizontal_dead_zone + deadzone_offset.x
	var top = cam_pos.y - vertical_dead_zone + deadzone_offset.y
	var bottom = cam_pos.y + vertical_dead_zone + deadzone_offset.y
	var target = cam_pos
	
	if player_pos.x < left:
		target.x = player_pos.x + horizontal_dead_zone - deadzone_offset.x
	elif player_pos.x > right:
		target.x = player_pos.x - horizontal_dead_zone - deadzone_offset.x

	if player_pos.y < top:
		target.y = player_pos.y + vertical_dead_zone - deadzone_offset.y
	elif player_pos.y > bottom:
		target.y = player_pos.y - vertical_dead_zone - deadzone_offset.y

	camera_target = target
	position = position.lerp(camera_target, clamp(follow_speed * delta, 0.0, 1.0))

	var half_width = camera.get_viewport_rect().size.x / 2
	var half_height = camera.get_viewport_rect().size.y / 2

	position.x = clamp(position.x, limit_left + half_width, limit_right - half_width)
	position.y = clamp(position.y, limit_top + half_height, limit_bottom - half_height)

func setup_camera_limits():
	var used_rect = ground.get_used_rect()
	var cell_size = ground.tile_set.tile_size
	var tile_origin = ground.map_to_local(used_rect.position)
	var map_size = used_rect.size * cell_size
	var origin_global = ground.to_global(tile_origin)

	limit_left = origin_global.x
	limit_top = origin_global.y
	limit_right = origin_global.x + map_size.x
	limit_bottom = origin_global.y + map_size.y + extra_vertical_margin
