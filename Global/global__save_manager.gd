extends Node


const SAVE_PATH = "user://"



signal game_loaded
signal game_saved


var current_save : Dictionary = {
	scene_path = "",
	player = {
		lvl = 1,
		xp = 0,
		#hp = 1,
		max_value = 100,
		sp = 100,
		str = 1,
		def = 1,
		spd = 1,
		spi = 1,
		wil = 1,
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	persistence = [],
	quests = [],
}

func save_game() -> void:
	update_player_data()
	update_scene_path()
	update_item_data()
	var file := FileAccess.open( SAVE_PATH + "save.sav", FileAccess.WRITE )
	var save_json = JSON.stringify( current_save )
	file.store_line(save_json)
	game_saved.emit()
	print("Save_game")
	pass
	
	
func get_save_file() -> FileAccess:
	return FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)

	
	
func load_game() -> void:
	var file := get_save_file()
	var json := JSON.new()
	json.parse(file.get_line())
	var save_dict : Dictionary = json.get_data() as Dictionary
	current_save = save_dict
	
	LevelManager.load_new_level(current_save.scene_path, "", Vector2.ZERO)
	
	await LevelManager.level_load_started
	
	PlayerManager.set_player_position(Vector2(current_save.player.pos_x, current_save.player.pos_y))
	#PlayerManager.set_health(current_save.player.hp, current_save.player.max_hp)
	
	
	PlayerManager.INVENTORY_DATA.parse_save_data(current_save.items)
	var p : Player = PlayerManager.player
	p.max_value = current_save.player.max_value
	p.sp = current_save.player.sp
	p.lvl = current_save.player.lvl
	p.xp = current_save.player.xp
	p.str = current_save.player.str
	p.def = current_save.player.def
	p.spd = current_save.player.spd
	p.spi = current_save.player.spi
	p.wil = current_save.player.wil
	p.update_hp(p.max_value)
	
	await LevelManager.level_loaded
	
	game_loaded.emit()
	

	
	PlayerManager.INVENTORY_DATA.parse_save_data(current_save.items)
	
	await LevelManager.level_loaded
	
	game_loaded.emit()
	
	
	pass
	
func update_player_data() -> void:
	var p : Player = PlayerManager.player
	current_save.player.max_value = p.max_value
	current_save.player.sp = p.sp
	current_save.player.lvl = p.lvl
	current_save.player.xp = p.xp
	current_save.player.str = p.str
	current_save.player.def = p.def
	current_save.player.spd = p.spd
	current_save.player.spi = p.spi
	current_save.player.wil = p.wil
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y
	
	
func update_scene_path() -> void:
	var p : String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			p = c.scene_file_path
	current_save.scene_path = p
	
	
func update_item_data() -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()
	
func add_persistent_value(value : String) -> void:
	if check_persistent_value(value) == false:
		current_save.persistence.append(value)
	pass
	
func check_persistent_value(value : String) -> bool:
	var p = current_save.persistence as Array
	return p.has(value)
