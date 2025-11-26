extends CanvasLayer

@onready var button_save: Button = $Control/VBoxContainer/Button_Save
@onready var button_load: Button = $Control/VBoxContainer/Button_Load
@onready var button_spells: Button = $Control/VBoxContainer/Button_Spells
@onready var button_stats: Button = $Control/VBoxContainer/Button_Stats

@onready var stats: Node = $Control/Stats
@onready var xp_label: Label = $Control/Stats/ExpCont/Label2
@onready var hp_label: Label = $Control/Stats/HpCont/Label2
@onready var sp_label: Label = $Control/Stats/HpCont2/Label2
@onready var lvl_label: Label = $Control/Stats/LvlCont/Label2
@onready var str_label: Label = $Control/Stats/StatsCont/HBoxContainer3/Label2
@onready var def_label: Label = $Control/Stats/StatsCont/HBoxContainer4/Label2
@onready var spd_label: Label = $Control/Stats/StatsCont/HBoxContainer5/Label2
@onready var spi_label: Label = $Control/Stats/StatsCont/HBoxContainer6/Label2
@onready var wil_label: Label = $Control/Stats/StatsCont/HBoxContainer7/Label2


func _ready() -> void:
	update_stats()
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = true
	get_tree().paused = true
	button_stats.grab_focus()
	set_process(true)
	button_save.pressed.connect(_on_save_pressed)
	button_load.pressed.connect(_on_load_pressed)
	button_stats.pressed.connect(_on_stats_pressed)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		_close_item_menu()


func _close_item_menu() -> void:
	set_process(false)
	get_tree().paused = false
	call_deferred("queue_free")
	
	
	
func _on_save_pressed() -> void:
	var equipment_menu_scene = load("res://GUI/pause_menu/equipment/equipment_menu.tscn")
	var equipment_menu = equipment_menu_scene.instantiate()
	get_tree().root.add_child(equipment_menu)

func _on_stats_pressed() -> void:
	var stats_menu_scene = load("res://GUI/pause_menu/inventory/stats_menu.tscn")
	var stats_menu = stats_menu_scene.instantiate()
	get_tree().root.add_child(stats_menu)
	
	visible = false

func _on_load_pressed() -> void:
	# Open item menu instead of changing the whole scene
	var item_menu_scene = load("res://GUI/pause_menu/inventory/item_menu.tscn")
	var item_menu = item_menu_scene.instantiate()
	get_tree().root.add_child(item_menu)

	# Hide pause menu but KEEP the game scene alive
	visible = false

	


func update_stats() -> void:
	print("update")
	var _p : Player = PlayerManager.player
	lvl_label.text = str(_p.lvl)
	
	if _p.lvl < PlayerManager.level_requirements.size():
		xp_label.text = str(_p.xp) + "/" + str(PlayerManager.level_requirements[_p.lvl])
	else:
		xp_label.text = "Max"
	str_label.text = str(_p.str)
	def_label.text = str(_p.def)
	spd_label.text = str(_p.spd)
	hp_label.text = str(_p.max_value)
	sp_label.text = str(_p.sp)
	spi_label.text = str(_p.spi)
	wil_label.text = str(_p.wil)
	
