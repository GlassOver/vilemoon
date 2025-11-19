extends CanvasLayer

@onready var button_save: Button = $Control/VBoxContainer/Button_Save
@onready var button_load: Button = $Control/VBoxContainer/Button_Load
@onready var item_description: Label = $Control/ItemDescription
@onready var item_name: Label = $Control/ItemName
@onready var item_quality: Label = $Control/ItemQuality
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer



func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	visible = true
	get_tree().paused = true
	button_load.grab_focus()
	set_process(true)


func _process(delta: float) -> void:
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
