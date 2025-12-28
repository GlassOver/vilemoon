class_name PlayerStateRun extends PlayerState

@onready var audio_stream_player: AudioStreamPlayer2D = $"../../RunAudio"

# What happens when this state is initialized?
func init() -> void: 
	pass
	


	
# What happens when we enter this state?
func enter() -> void:
	audio_stream_player.play()
	pass
	

# What happens when we exit this state?
func exit() -> void:
	audio_stream_player.stop()
	pass


# What happens when an input is pressed?
func handleInput(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("interact"):
		PlayerManager.interact_pressed.emit()
		
	if Input.is_action_just_pressed("attack") and player.attackTimer <= 0:
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
#	if signalled_state:
#		var state_transition: PlayerState = signalled_state
#		signalled_state = null
#		return state_transition
		
	player.velocity.x = player.direction.x * player.move_speed
	if player.is_on_floor() == false:
		return fall
	return nextState
