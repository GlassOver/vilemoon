extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.805, 0.805, 0.805, 1.0))
