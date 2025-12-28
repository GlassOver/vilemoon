extends Area2D


@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var checkpoint: Sprite2D = $Sprite2D



func _ready() -> void:
	body_entered.connect(_player_entered)
		
	pass
	
	

func _player_entered(_p : Node2D) -> void:
	SceneTransition.fade_out()
	_place_player()
	pass
	
	
func _place_player() -> void:
	if PlayerManager.player.health > 10:
		await get_tree().create_timer(0.8).timeout
		PlayerManager.player.global_position = checkpoint.global_position
		SceneTransition.fade_in()
		await SceneTransition.fade_in()
		PlayerManager.player.update_hp(-10)
	else:
		SaveManager.load_game()
	pass
	

	

	
	
	
	
	
