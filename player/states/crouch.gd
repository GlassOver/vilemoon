class_name PlayerStateCrouch extends PlayerState

@onready var slide_audio: AudioStreamPlayer2D = $"../../SlideAudio"
@onready var crouch_ray: RayCast2D = $"../../CrouchRay"


@export var slide_cooldown : float = 1.0  
@export var deceleration_rate : float = 4
@export var effect_delay : float = 0.005
var k := 1.7

var slideDuration = 0
var slideTimer = 0.01
var slide_cooldown_timer : float = 0.0  
var effect_timer : float = 0

 
   


func init() -> void:
	pass


func enter() -> void:

	if player.isDodging == true:
		exit()

	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false
	player.hit_box.monitorable = false
	player.crouch_hit_box.monitorable = true
	player.isSliding = true
	slideDuration = slideTimer
	effect_timer = 0
	pass


func exit() -> void:
	

	player.slideTimer = player.slideTime
	player.collision_stand.disabled = false
	player.collision_crouch.disabled = true
	player.hit_box.monitorable = true
	player.crouch_hit_box.monitorable = false
	player.isSliding = false
	
	pass


func handleInput(_event : InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump"):
		return jump
	return nextState



func process(_delta: float) -> PlayerState:
	effect_timer -= _delta
	if effect_timer < 0: 
		effect_timer = effect_delay
		spawn_effect()
		
	slideDuration -= _delta
	
	if player.isDodging == true:
		exit()

	if player.direction.y <= 0.5:
		return idle
	return nextState


func physics_process(_delta: float) -> PlayerState:
	if player.isDodging == true:
		exit()
	if slideDuration >= 0:
		slide_audio.play()
		var boosted = k * k
		
		player.velocity.x = player.velocity.x * boosted



	player.velocity.x -= player.velocity.x * deceleration_rate * _delta
	return nextState
	
	

func spawn_effect() -> void:
	var effect : Node2D = Node2D.new()
	player.get_parent().add_child(effect)
	effect.global_position = player.global_position - Vector2(0,0.1)
	effect.modulate = Color(1.5, 0.2, 1.25, 0.25)
	
	var sprite_copy : AnimatedSprite2D = player.sprite.duplicate()
	effect.add_child(sprite_copy)
	
	var tween : Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(effect, "modulate", Color(1,1,1,0), 0.2)
	tween.chain().tween_callback(effect.queue_free)
	pass
