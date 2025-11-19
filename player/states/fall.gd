class_name PlayerStateFall extends PlayerState

@export var fall_gravity_multiplier : float = 5.165
@export var coyote_time : float = 0.125
@export var jump_buffer_time : float = 0.2 #This is the glitch

var buffer_timer : float = 0
var coyote_timer : float = 0



# What happens when this state is initialized?
func init() -> void: 
	pass
	
	
	
# What happens when we enter this state?
func enter() -> void:
	
	player.gravity_multiplier = fall_gravity_multiplier
	if player.previousState == jump:
		coyote_timer = 0
	else: 
		coyote_timer = coyote_time
	pass
	

# What happens when we exit this state?
func exit() -> void:
	player.gravity_multiplier = 1.0
	pass


# What happens when an input is pressed?
func handleInput( _event : InputEvent ) -> PlayerState:
	if Input.is_action_just_pressed("attack"):
		return attack


	if _event.is_action_pressed("jump"):
		if coyote_timer > 0:
			return jump
		else:
			buffer_timer = jump_buffer_time
			
	if Input.is_action_just_pressed("dodge") and player.dodgeTimer <= 0:
		return dodge
		
	return nextState


# What happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	coyote_timer -= _delta
	buffer_timer -= _delta
	return nextState
	

# What happens each physics process tick in this state?
func physics_process(_delta: float) -> PlayerState:
	if player.is_on_floor():
		if buffer_timer > 0:
			return jump
		return idle
	
	if player.ledge_left.is_colliding() and player.velocity.y > 0:
		return ledgegrab
		
	player.velocity.x = player.direction.x * player.jump_move_speed
	return nextState
