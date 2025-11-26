extends CanvasLayer

@onready var button_save: Button = $Control/VBoxContainer/Button_Save
@onready var button_load: Button = $Control/VBoxContainer/Button_Load
@onready var button_spells: Button = $Control/VBoxContainer/Button_Spells
@onready var button_stats: Button = $Control/VBoxContainer/Button_Stats

@onready var item_description: Label = $Control/ItemDescription
@onready var item_name: Label = $Control/ItemName
@onready var item_quality: Label = $Control/ItemQuality
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer



func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = true
	get_tree().paused = true
	button_load.grab_focus()
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
	
	
func update_item_description (new_text : String) -> void:
	item_description.text = new_text
	
func update_item_name (new_text : String) -> void:
	item_name.text = new_text
	
func update_item_quality (new_text : String) -> void:
	item_quality.text = new_text
	
func play_sound(audio: AudioStream) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()



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
