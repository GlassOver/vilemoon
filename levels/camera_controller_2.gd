extends Node2D
#camera 2
# --- Node references ---
@onready var camera: Camera2D = $Camera2D
@onready var player: Node2D = $"../Player"
@onready var ground: TileMap = $"../TileMap"

# --- Dead zone settings ---
@export var horizontal_dead_zone := 80.0
@export var vertical_dead_zone := 80.0
@export var follow_speed := 9.0  # interpolation speed

# --- Directional look-ahead ---
@export var look_ahead_distance := 100.0
@export var look_ahead_speed := 6.0
@export var look_ahead_threshold := 10.0  # min player velocity to trigger lookahead

# --- Map bounds ---
@export var extra_vertical_margin := 1000.0

var limit_left := 0.0
var limit_right := 0.0
var limit_top := 0.0
var limit_bottom := 0.0

# Internal state
var camera_target := Vector2.ZERO
var deadzone_offset := Vector2.ZERO

func _ready():
	if not camera:
		push_error("Camera2D node not found as child of CameraController!")
	else:
		camera.make_current()  # activate camera

	if not player:
		push_error("Player node not found!")
	else:
		position = player.global_position
		camera_target = position

	if not ground:
		push_error("TileMap node not found!")
		return

	setup_camera_limits()

func _physics_process(delta):
	if not player:
		return

	var cam_pos = position
	var player_pos = player.global_position

	# --- 1️⃣ directional look-ahead ---
	var player_vel = Vector2.ZERO
	if "velocity" in player:
		player_vel = player.velocity
	elif "linear_velocity" in player:
		player_vel = player.linear_velocity

	var desired_offset_x = 0.0
	if abs(player_vel.x) > look_ahead_threshold:
		desired_offset_x = sign(player_vel.x) * look_ahead_distance

	# smoothly interpolate deadzone offset
	deadzone_offset.x = lerp(deadzone_offset.x, desired_offset_x, clamp(look_ahead_speed * delta, 0.0, 1.0))
	deadzone_offset.y = 0  # vertical look-ahead optional

	# --- 2️⃣ compute dead zone rectangle in world space ---
	var left = cam_pos.x - horizontal_dead_zone + deadzone_offset.x
	var right = cam_pos.x + horizontal_dead_zone + deadzone_offset.x
	var top = cam_pos.y - vertical_dead_zone + deadzone_offset.y
	var bottom = cam_pos.y + vertical_dead_zone + deadzone_offset.y

	# --- 3️⃣ update camera target only if player leaves dead zone ---
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

	# --- 4️⃣ smoothly move camera parent ---
	position = position.lerp(camera_target, clamp(follow_speed * delta, 0.0, 1.0))

	# --- 5️⃣ clamp camera to map bounds manually ---
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
