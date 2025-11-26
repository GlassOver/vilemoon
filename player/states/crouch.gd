class_name PlayerStateCrouch extends PlayerState

@export var slide_cooldown : float = 1.0  
@export var deceleration_rate : float = 4
var k := 1.7

var slideDuration = 0
var slideTimer = 0.01
var slide_cooldown_timer : float = 0.0  


 
   


func init() -> void:
	pass


func enter() -> void:

	if player.isDodging == true:
		exit()
	player.collision_stand.disabled = true
	player.collision_crouch.disabled = false
	player.isSliding = true
	slideDuration = slideTimer
	pass


func exit() -> void:
	
	player.slideTimer = player.slideTime
	player.collision_stand.disabled = false
	player.collision_crouch.disabled = true
	player.isSliding = false
	
	pass


func handleInput(_event : InputEvent) -> PlayerState:
	if _event.is_action_pressed("jump"):
		return jump
	return nextState


func process(_delta: float) -> PlayerState:
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
		var boosted = k * k
		player.velocity.x = player.velocity.x * boosted


	player.velocity.x -= player.velocity.x * deceleration_rate * _delta
	return nextState
