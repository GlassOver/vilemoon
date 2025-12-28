extends Area2D


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var checkpoint: Sprite2D = $Sprite2D



func _ready() -> void:
	body_entered.connect(_player_entered)
		
	pass
	
	

func _player_entered(_p : Node2D) -> void:
	_place_player()
	pass
	
	
func _place_player() -> void:
	SaveManager.save_game()
	queue_free()
	pass
	
	
	
	

	
	

	

	
	
	
	
	
