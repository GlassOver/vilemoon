class_name PlayerStateRun extends PlayerState



# What happens when this state is initialized?
func init() -> void: 
	pass
	
	
	
# What happens when we enter this state?
func enter() -> void:
	pass
	

# What happens when we exit this state?
func exit() -> void:
	pass


# What happens when an input is pressed?
func handleInput(_event: InputEvent) -> PlayerState:
	if Input.is_action_just_pressed("attack"):
		return attack

		
	if _event.is_action_pressed("jump"):
		return jump
	if Input.is_action_just_pressed("dodge") and player.dodgeTimer <= 0:
		return dodge
	return nextState


# What happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	if player.direction.x == 0:
		return idle
	elif player.direction.y > 0.5 and player.slideTimer <= 0:
		return crouch
	return nextState
	

# What happens each physics process tick in this state?
func physics_process(_delta: float) -> PlayerState:
	player.velocity.x = player.direction.x * player.move_speed
	if player.is_on_floor() == false:
		return fall
	return nextState
