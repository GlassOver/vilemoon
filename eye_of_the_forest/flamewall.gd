class_name FlameWall extends Node2D

@export var use_timer : bool = false
@export var time_between : float = 3
@onready var hurt_box: HurtBox = $HurtBox
@onready var slash: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var speed : float = 1500



func _ready() -> void:
	if use_timer == true:
		attack_delay()
	pass
	
func _process(delta: float) -> void:
	position -= Vector2(speed * delta, 0)
	pass	


func attack() -> void:
	animation_player.play("attack")
	await animation_player.animation_finished
	animation_player.play("default")
	if use_timer == true:
		attack_delay()
	pass
	
func attack_delay() -> void:
	await get_tree().create_timer(time_between).timeout
	attack()
	pass
