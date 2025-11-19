extends Node

const PLAYER = preload("res://Global/player.tscn")
const INVENTORY_DATA : InventoryData = preload("res://GUI/pause_menu/inventory/scripts/player_inventory.tres")

var player: Player
var player_spawned : bool = true

func _ready():
	call_deferred("add_player_instance")
	
	

func add_player_instance():
	player = PLAYER.instantiate()
	get_tree().current_scene.add_child(player)
	
	
#func set_health(hp: int, max_hp: int) -> void:
#	player.max_hp = max_hp
#	player.hp = hp
#	player.update_hp(0)
	
	
func set_player_position(_new_pos: Vector2):
	player.global_position = _new_pos
	pass
	
func set_as_parent(_p : Node2D) -> void:
	if player and player.get_parent():
		player.get_parent().remove_child(player)
		_p.add_child(player)

	
func unparent_player(_p : Node2D) -> void:
	_p.remove_child(player)
	
