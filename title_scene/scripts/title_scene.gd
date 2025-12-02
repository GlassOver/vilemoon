extends Node2D

const START_LEVEL : String = "res://levels/base_level.tscn"

@onready var button_new: Button = %ButtonNew
@onready var button_continue: Button = %ButtonContinue


func _ready() -> void:
	get_tree().paused = true
	
	setup_title_screen()
	
	LevelManager.level_load_started.connect(exit_title_screen)
	pass

func setup_title_screen() -> void:
	button_new.pressed.connect(start_game)
	pass
	
func start_game() -> void:
	LevelManager.load_new_level(START_LEVEL, "", Vector2.ZERO)
	pass


func exit_title_screen() -> void:
	PlayerManager.player.visible = true
	
	self.queue_free()
	pass
