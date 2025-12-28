class_name EnemyStateChase extends EnemyState

const PATHFINDER : PackedScene = preload("res://Enemies/pathfinder.tscn")
const AVOID : PackedScene = preload("res://Enemies/avoidpathfinder.tscn")
const SLASH_SCENE: PackedScene = preload("res://eye_of_the_forest/realslash.tscn")
@onready var slashpre: AudioStreamPlayer2D = $"../../Slashpre"


@export var anim_name : String = "chase"
@export var chase_speed : float = 150
@export var turn_rate : float = 0.25

@export_category("AI")
@export var vision_area : VisionArea
@export var attack_area : HurtBox
@export var state_aggro_duration : float = 0.5
@export var avoider_aggro_duration : float = 5
@export var next_state : EnemyState

var _timer : float = 0.0
var _direction : Vector2
var _can_see_player : bool = false
var pathfinder : Pathfinder
var avoidfinder : AvoidPathfinder
var attack_timer: float = 0.0
var attack_cooldown: float = randf_range(2, 5)



func init() -> void:
	if vision_area:
		vision_area.player_entered.connect(_on_player_enter)
		vision_area.player_exited.connect(_on_player_exit)

# What happens when we enter this state?
func enter() -> void:
	enemy.wingsflutter.play()
	if enemy.avoider == false:
		pathfinder = PATHFINDER.instantiate() as Pathfinder
		enemy.add_child(pathfinder)
	elif enemy.avoider == true:
		avoidfinder = AVOID.instantiate() as AvoidPathfinder
		enemy.add_child(avoidfinder)
	if enemy.attacker == true:
		attack_timer = attack_cooldown
	if enemy.avoider == false:
		_timer = state_aggro_duration
	if enemy.avoider == true:
		_timer = avoider_aggro_duration
	#enemy.update_animation(anim_name)
	if attack_area:
		attack_area.monitoring = true
	pass
	

# What happens when we exit this state?
func exit() -> void:
	enemy.wingsflutter.stop()
	if enemy.avoider == false:
		pathfinder.queue_free()
	elif enemy.avoider == true:
		avoidfinder.queue_free()
		
	if attack_area:
		attack_area.monitoring = false
	_can_see_player = false
	pass


# What happens each process tick in this state?
func process(_delta: float) -> EnemyState:
	attack_timer -= _delta

	if enemy.avoider == false:
		_direction = lerp(_direction, pathfinder.move_dir, turn_rate)
		enemy.velocity = _direction * chase_speed
	elif enemy.avoider == true:
		_direction = lerp(_direction, avoidfinder.move_dir, turn_rate)
		enemy.velocity = _direction * chase_speed
	
	if enemy.attacker == true and attack_timer <= 0:
		attack()
		
	if enemy.set_direction(_direction):
		#enemy.update_animation(anim_name)
		pass

	if _can_see_player == false:
		_timer -= _delta
		if _timer <= 0:
			return next_state
	else:
		if enemy.attacker == false: 
			_timer = state_aggro_duration
		if enemy.attacker == true:
			_timer = avoider_aggro_duration
	return null
	
func attack(): 
	attack_timer = attack_cooldown
	var eb : Node2D = SLASH_SCENE.instantiate()
	slashpre.play()
	await slashpre.finished
	eb.global_position = get_parent().get_parent().global_position + Vector2(0, -34)
	get_parent().add_child.call_deferred(eb)

# What happens each physics process tick in this state?
func physics(_delta: float) -> EnemyState:
	return null
	
	
func _on_player_enter() -> void:
	_can_see_player = true
	if state_machine.current_state is EnemyStateStun:
		return
	state_machine.change_state(self)
	pass
	
func _on_player_exit() -> void:
	_can_see_player = false
	pass
