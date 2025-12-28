class_name Enemy extends CharacterBody2D

signal direction_changed(new_direction : Vector2)
signal enemy_damaged(hurt_box : HurtBox)
signal enemy_destroyed(hurt_box : HurtBox)

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
const DIR_2 = [Vector2.RIGHT, Vector2.LEFT]

@onready var wingsflutter: AudioStreamPlayer2D = $Wingsflutter
@onready var damaged_sfx: AudioStreamPlayer2D = $Damaged
@onready var destroyed_sfx: AudioStreamPlayer2D = $Destroyed


@export var hp : int = 30
@export var xp_reward : int = 1
@export var wander_speed : float = 150
@export var avoider : bool = false
@export var attacker : bool = false
@export var wanderer : bool = false
var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invunlerable : bool = false

#@onready var animation_player : AnimationPlayer = $AnimationPlayer 
@onready var sprite : Sprite2D = $Sprite2D
@onready var hit_box : HitBox = $HitBox
@onready var wall_detect: RayCast2D = $WallDetect
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine



func _ready():
	state_machine.initialize(self)
	player = PlayerManager.player
	hit_box.Damaged.connect(_take_damage)
	pass


func _physics_process(_delta: float):
	move_and_slide()
	
func set_direction(_new_direction : Vector2) -> bool:
	direction = _new_direction
	if direction == _new_direction:
		return false
	
	var direction_id : int = int(round(
			(direction + cardinal_direction * 0.1).angle()
			/ TAU * DIR_4.size()
	))
	var new_dir = DIR_4[direction_id]
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	direction_changed.emit(new_dir)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true
	
#func update_animation (state : String) -> void:
#		animation_player.play(state + "_" + anim_direction())
#		pass
		
#func anim_direction() -> String:
#	if cardinal_direction == Vector2.DOWN:
#		return "down"
#	elif cardinal_direction == Vector2.UP:
#		return "up"
#	else:
#		return "side"

func _take_damage(hurt_box : HurtBox) -> void:
	if invunlerable == true:
		return
	hp-= hurt_box.damage
	EffectManager.damage_text(hurt_box.damage, global_position + Vector2(0,-36))
	if hp > 0:
		enemy_damaged.emit(hurt_box)
		damaged_sfx.play()
	else:
		
		enemy_destroyed.emit(hurt_box)
		
	
	
	
	
	
	
	
