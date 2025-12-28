class_name FlamePillarProp extends Node2D


@export var use_timer : bool = false
@export var time_between_attacks : float = 3
@export var stutter_time : bool = false
@export var double_time : bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if use_timer == true:
		attack_delay()
	pass

func attack() -> void:
	animation_player.play("attack")
	await animation_player.animation_finished
	animation_player.play("default")
	if use_timer == true:
		attack_delay()
	
func attack_delay() -> void:
	if stutter_time == false and double_time == false:
		await get_tree().create_timer(time_between_attacks).timeout
		attack()
	elif stutter_time == true: 
		await get_tree().create_timer(2).timeout
		attack()
	elif double_time == true:
		await get_tree().create_timer(1.5).timeout
		attack()	
