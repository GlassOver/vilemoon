extends CanvasLayer

@onready var button_save: Button = $VBoxContainer/Button_Save
@onready var button_load: Button = $VBoxContainer/Button_Load
@onready var button_stats: Button = $VBoxContainer/Button_Stats

signal shown
signal hidden
signal preview_stats_changed(item : ItemData)

var is_open := false

func _ready() -> void:
	visible = false
	button_save.pressed.connect(_on_save_pressed)
	button_load.pressed.connect(_on_load_pressed)
	button_stats.pressed.connect(_on_stats_pressed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_open:
			close_pause_menu()
		else:
			open_pause_menu()
		get_viewport().set_input_as_handled()


func open_pause_menu() -> void:
	visible = true
	is_open = true
	get_tree().paused = true
	button_save.grab_focus()
	shown.emit()


func close_pause_menu() -> void:
	visible = false
	is_open = false
	get_tree().paused = false
	hidden.emit()

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
	
func preview_stats(item : ItemData) -> void:
	preview_stats_changed.emit(item)
