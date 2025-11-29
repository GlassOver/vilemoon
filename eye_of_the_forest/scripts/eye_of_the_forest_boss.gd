class_name EyeOfTheForestBoss extends Node2D

const ENERGY_EXPLOSION_SCENE : PackedScene = preload("res://eye_of_the_forest/energy_explosion.tscn")
const SLASH_SCENE: PackedScene = preload("res://eye_of_the_forest/realslash.tscn")
const FIRE_STREAM_SCENE: PackedScene = preload("res://eye_of_the_forest/Slash.tscn")
const FIRE_BALL_SCENE: PackedScene = preload("res://eye_of_the_forest/fire wall.tscn")


@export var max_hp : int = 500
var hp : int = 10
#var audio_hurt : AudioStream = preload()
#var audio_shoot : AudioStream = preload()

var current_position : int = 0
var positions : Array[Vector2]
var Stream_Attacks : Array[SlashAttack]

@onready var boss_node: Node2D = $BossNode
@onready var persistent_data_handler: PersistentDataHandler = $PersistentDataHandler
@onready var hurt_box: HurtBox = $BossNode/HurtBox
@onready var hit_box: HitBox = $BossNode/HitBox
@onready var pos1: Sprite2D = $PositionTargets/Sprite2D
@onready var pos2: Sprite2D = $PositionTargets/Sprite2D2
@onready var pos3: Sprite2D = $PositionTargets/Sprite2D3
@onready var pos4: Sprite2D = $PositionTargets/Sprite2D4



func _ready() -> void:
	hp = max_hp
	
	hit_box.Damaged.connect(damage_taken)
	
	for c in $PositionTargets.get_children(): 
		positions.append(c.global_position)
	print(positions)
	$PositionTargets.visible = false
	
	for b in $StreamAttacks.get_children():
		Stream_Attacks.append(b)
	
	
	
func idle() -> void:
	print("idle")
	enable_hit_boxes()
	
	#animation_player.play("cast_spell")
	#await animation_player.animation_finished
	#animation_player.play("idle")
	#await animation_player.animation_finished
	
	#create an attack pattern somehow?
	shoot_slash()
	fire_wall()
	fire_stream()
	
	pass
	

	
func update_animations() -> void:

	pass


func shoot_slash() -> void:
	var eb : Node2D = SLASH_SCENE.instantiate()
	eb.global_position = boss_node.global_position + Vector2(0, -34)
	get_parent().add_child.call_deferred(eb)
	print("Shot")
	#play_audio(audio_shoot)
	
func fire_wall() -> void:
	var fw : Node2D = FIRE_BALL_SCENE.instantiate()
	fw.global_position = pos1.global_position
	get_parent().add_child.call_deferred(fw)
	var fw2 : Node2D = FIRE_BALL_SCENE.instantiate()
	fw2.global_position = pos2.global_position
	get_parent().add_child.call_deferred(fw2)
	var fw3 : Node2D = FIRE_BALL_SCENE.instantiate()
	fw3.global_position = pos3.global_position
	get_parent().add_child.call_deferred(fw3)

func fire_stream() -> void:
	var fs : Node2D = FIRE_STREAM_SCENE.instantiate()
	fs.global_position = pos4.global_position
	get_parent().add_child.call_deferred(fs)

func damage_taken(_hurt_box : HurtBox) -> void:
		#if animation_player_damaged.current_animation == "damaged" or _hurt_box.damage == 0:
			#return
		#play_audio(audio_hurt)
		hp = clampi(hp - _hurt_box.damage, 0, max_hp)
		EffectManager.damage_text(hp, global_position + Vector2(0,-36) )
		#animation_player_damaged.play("damaged")
		#animation_player_damaged.seek(0)
		#animation_player_damaged.queue("default")
		if hp < 1:
			defeat()
		else: idle()
		pass
	
#func play_audio(_a : AudioStream) -> void:
	#audio.stream = _a
	#audio.play()
	
	
func defeat() -> void:
	#animation_player.play("destroy)
	enable_hit_boxes(false)
	persistent_data_handler.set_value()
	explosion()
	#await animation_player.animation_finished

	
func enable_hit_boxes(_v : bool = true) -> void:
	hit_box.set_deferred("monitorable", _v)
	hurt_box.set_deferred("monitoring", _v)
	
func explosion(_p : Vector2 = Vector2.ZERO) -> void:
	var e : Node2D = ENERGY_EXPLOSION_SCENE.instantiate()
	e.global_position = boss_node.global_position + _p
	get_parent().add_child.call_deferred(e)
	#call this in defeat animation later
	pass
	
