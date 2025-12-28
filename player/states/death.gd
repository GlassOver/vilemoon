class_name PlayerStateDeath extends PlayerState

@export var exhaust_audio : AudioStream
#@onready var audio: AudioStreamPlayer2D = 

# What happens when this state is initialized?
func init() -> void: 
	pass
	
	
#func _ready():
#	player.player_damaged.connect(_on_player_stunned)
	
	
#func _on_player_stunned():
#	if not signalled_state:
#		signalled_state = stun


	
# What happens when we enter this state?
func enter() -> void:
	print("YOU DIED")
#	player.animation_player.play("death")
#	audio.stream = exhaust_audio
#	audio.play()
	#trigger game over UI
#	AudioManager.play_music(null)
	pass
	

# What happens when we exit this state?
func exit() -> void:
	pass


# What happens when an input is pressed?
func handleInput( _event : InputEvent ) -> PlayerState:
	return nextState


# What happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	player.velocity = Vector2.ZERO
	return nextState
	

# What happens each physics process tick in this state?
func physics_process(_delta: float) -> PlayerState:
	return nextState
