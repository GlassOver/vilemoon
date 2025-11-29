class_name HurtBox extends Area2D

@export var damage : int = 10
signal did_damage

func _ready() -> void:
	area_entered.connect(AreaEntered)
	pass
	
	
func AreaEntered(a : Area2D) -> void:
	if a is HitBox:
		did_damage.emit()
		a.TakeDamage(self)
	pass
