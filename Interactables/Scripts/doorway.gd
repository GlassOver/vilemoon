@tool
class_name Doorway extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var interact_area: Area2D = $Area2D
@onready var enter_label: Label = $Label

@export_file("*.tscn") var level
@export var target_transition_area : String = "LevelTransition"


func _ready() -> void:
	
	if Engine.is_editor_hint():
		return
	interact_area.area_entered.connect(_on_area_enter)	
	interact_area.area_exited.connect(_on_area_exit)	

	pass
	
func player_interact() -> void:
	LevelManager.load_new_level(level, target_transition_area, get_offset())
	pass
	


func get_offset() -> Vector2:
	var offset : Vector2 = Vector2.ZERO
	var player_pos = PlayerManager.player.global_position
	offset.y = player_pos.y
	offset.x = player_pos.x
	return offset



func _on_area_enter(_a : Area2D):
	PlayerManager.interact_pressed.connect(player_interact)
	enter_label.text = "Enter..."
	animation_player.play("enter_text")
	
	pass
	
func _on_area_exit(_a : Area2D):
	PlayerManager.interact_pressed.disconnect(player_interact)
	enter_label.text = ""
	pass
