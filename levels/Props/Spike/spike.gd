class_name Spike extends Node2D

func _ready():
	$HitBox.Damaged.connect(TakeDamage)
	pass
	
func TakeDamage (_damage: int) -> void:
	
	pass
