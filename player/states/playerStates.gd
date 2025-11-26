class_name PlayerState extends Node

var player : Player
var nextState : PlayerState
var signalled_state : PlayerState = null

#region /// state references 
	#reference to all other states
#endregion 
@onready var idle: PlayerStateIdle = %Idle
@onready var run: PlayerStateRun = %Run
@onready var jump: PlayerStateJump = %Jump
@onready var fall: PlayerStateFall = %Fall
@onready var crouch: PlayerStateCrouch = %Crouch
@onready var ledgegrab: PlayerStateLedgeGrab = %LedgeGrab
@onready var dodge: PlayerStateDodge = %Dodge
@onready var attack: PlayerStateAttack = %Attack
@onready var stun: PlayerStateStun = %Stun



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
	pass
	

# What happens when we exit this state?
func exit() -> void:
	pass


# What happens when an input is pressed?
func handleInput( _event : InputEvent ) -> PlayerState:
	return nextState


# What happens each process tick in this state?
func process(_delta: float) -> PlayerState:
	return nextState
	

# What happens each physics process tick in this state?
func physics_process(_delta: float) -> PlayerState:
	return nextState
