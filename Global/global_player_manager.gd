extends Node

const PLAYER = preload("res://Global/player.tscn")
const INVENTORY_DATA : InventoryData = preload("res://GUI/pause_menu/inventory/scripts/player_inventory.tres")

signal player_leveled_up
signal interact_pressed

var player: Player
var player_spawned : bool = false
var level_requirements = [0, 100, 240, 380, 420, 560, 699, 739, 878, 917, 1056]

func _ready():
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true
	
	

func add_player_instance():
	player = PLAYER.instantiate()
	add_child(player)
	pass
	
#func set_health(hp: int, max_hp: int) -> void:
#	player.max_hp = max_hp
#	player.hp = hp
#	player.update_hp(0)
	
	
func set_player_position(_new_pos: Vector2):
	player.global_position = _new_pos
	pass
	
func set_as_parent(_p : Node2D) -> void:
	if player.get_parent():
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
		player.sp += randi_range(0,5)
		player.str += randi_range(0,3)
		player.def += randi_range(0,3)
		player.spd += randi_range(0,3)
		player.spi += randi_range(0,3)
		player.wil += randi_range(0,3)
		check_for_level_advance()
	pass
