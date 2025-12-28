@tool
class_name Save_Object extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: Area2D = $Area2D
@onready var save_label: Label = $Label


func _ready() -> void:
	
	
	if Engine.is_editor_hint():
		return
	interact_area.area_entered.connect(_on_area_enter)	
	interact_area.area_exited.connect(_on_area_exit)	

	pass
	
func player_interact() -> void:
	SaveManager.save_game()
	animation_player.play("saved")
	pass
	
func _on_area_enter(_a : Area2D):
	PlayerManager.interact_pressed.connect(player_interact)
	save_label.text = "Save"
	animation_player.play("save_text")
	
	pass
	
func _on_area_exit(_a : Area2D):
	PlayerManager.interact_pressed.disconnect(player_interact)
	save_label.text = ""
	pass
