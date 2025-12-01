class_name State extends Node

@onready var player = PlayerManager.PLAYER

func _ready() -> void:
	set_physics_process(false)
	
func enter():
	set_physics_process(false)
	
func exit():
	set_physics_process(false)
	
func transition():
	pass

func _physics_process(delta: float) -> void:
	transition()
