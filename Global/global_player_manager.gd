extends Node

const PLAYER = preload("res://Global/player.tscn")
const INVENTORY_DATA : InventoryData = preload("res://GUI/pause_menu/inventory/scripts/player_inventory.tres")

signal player_leveled_up


var player: Player
var player_spawned : bool = true
var level_requirements = [0, 100, 140, 180, 220, 260, 299, 339, 378, 417, 456]

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
	
	
func reward_xp(_xp : int) -> void:
	player.xp += _xp
	check_for_level_advance()
	player_leveled_up.emit()


		
	#check for level advancement
func check_for_level_advance()-> void:
	if player.lvl >= level_requirements.size():
		return
	if player.xp >= level_requirements[player.lvl]:
		player.lvl += 1
		player.max_value += 10
		player.sp += randf_range(0,5)
		player.str += randf_range(0,5)
		player.def += randf_range(0,5)
		player.spd += randf_range(0,5)
		player.spi += randf_range(0,5)
		player.wil += randf_range(0,5)
		check_for_level_advance()
	pass
