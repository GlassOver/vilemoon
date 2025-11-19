extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

#variables
@export var gravity : int = 3000
var jumpGrav = 100
@export var speed : int = 2000
@export var maxHspeed : int = 400
@export var slowDownspeed : int = 6000
@export var jump : int = -650
@export var hJumpspeed : int = 500
@export var maxJumpspeed : int = 350


enum State { Idle, Run, Jump }
var currentState : State


#void start
func _ready():
	currentState = State.Idle
	
	
#void update
func _physics_process(delta : float):
	player_falling(delta)
	player_idle(delta)
	player_run(delta)
	player_jump(delta)
	
	move_and_slide()
	
	playerAnimations()
		
		
func player_falling(delta : float):
	if !is_on_floor(): 
		velocity.y += gravity * delta


func player_idle(delta : float):
	if is_on_floor():
		currentState = State.Idle
		
#player movement
func player_run(delta : float):
	var direction = inputMovement()
	
	if direction:
		velocity.x += direction * speed
		velocity.x = clamp(velocity.x, -maxHspeed, maxHspeed)
	else:
		velocity.x = move_toward(velocity.x, 0, slowDownspeed * delta)

	if direction != 0:
		currentState = State.Run
		

func player_jump(delta : float):
	if Input.is_action_just_pressed("jump"):
		velocity.y = jump 
		currentState = State.Jump

		
	if !is_on_floor() and currentState == State.Jump:
		var direction = inputMovement()
		velocity.x += direction * hJumpspeed * delta
		velocity.x = clamp(velocity.x, -maxJumpspeed, maxJumpspeed)

#animations
func playerAnimations():
	if currentState == State.Idle:
		animated_sprite_2d.play("standinIdle")
	elif currentState == State.Run:
		animated_sprite_2d.play("standinRun")


func inputMovement():
	var direction : float = Input.get_axis("move_left", "move_right")
	
	return direction
