extends Sprite2D

@export var speed : float = 300

var rect : Rect2 

func _ready() -> void:
	rect = self.region_rect


func _process(delta: float) -> void:
	region_rect.position += Vector2(0, -speed * delta)
	pass
