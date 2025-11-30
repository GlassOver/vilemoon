class_name Drone extends Node2D

const DRONE_EXPLOSION_SCENE : PackedScene = preload("res://eye_of_the_forest/drone_explosion.tscn")
@onready var drone: Drone = $"."

@export var speed : float = 1000
@export var shoot_audio : AudioStream
@export var hit_audio : AudioStream

var direction : Vector2 = Vector2.DOWN

@onready var hurt_box: HurtBox = $HurtBox
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var explosion_hurt_box: HurtBox = $ExplosionHurtBox
@onready var ground_detection: RayCast2D = $RayCast2D

func _ready() -> void:
	hurt_box.did_damage.connect(explode)
	#play_audio(shoot_audio)
	get_tree().create_timer(5).timeout.connect(destroy)
	direction = global_position.direction_to(PlayerManager.player.global_position)
	explosion_hurt_box.monitorable = false
	flicker()
	pass
	
func _process(delta: float) -> void:
	position += direction * speed * delta
	if ground_detection.is_colliding():
		explode()
	pass
	
	
func flicker() -> void:
	modulate.a = randf() * 0.7 + 1
	await get_tree().create_timer(0.05).timeout
	flicker()
	pass
	
func explode(_p : Vector2 = Vector2.ZERO) -> void:
	explosion_hurt_box.monitorable = true
	var e : Node2D = DRONE_EXPLOSION_SCENE.instantiate()
	e.global_position = drone.global_position
	get_parent().add_child.call_deferred(e)
	queue_free()
	pass
	
func hit_player() -> void:
	
	pass
	
	
func play_audio(_a : AudioStream) -> void:
	#audio_stream_player_2d.stream = _a
	#audio_stream_player_2d.play()
	pass
	
func destroy() -> void:
	queue_free()
