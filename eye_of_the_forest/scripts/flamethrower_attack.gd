class_name FlameThrower extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	attack()
	pass
	
	
func attack() -> void:
	animation_player.play("attack")
	await animation_player.animation_finished
	animation_player.play("default")
