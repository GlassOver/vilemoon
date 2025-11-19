class_name Player
extends CharacterBody2D

signal player_damaged(damage: int)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_stand: CollisionShape2D = %CollisionShape2D
@onready var collision_crouch: CollisionShape2D = %CollisionCrouch
@onready var one_way_platform_raycast: RayCast2D = %OneWayPlatformRaycast
@onready var ledge_left: RayCast2D = %LedgeLeft
@onready var hit_box: HitBox = $HitBox



@export var move_speed := 500.0
@export var jump_move_speed := 400.0
@export var dodgeTimer := 0.0
@export var dodgeTime := 1.2
@export var slideTimer := 0.0
@export var slideTime := 0.3

@export var facing_right := true
@export var isAttacking := false

var states: Array[PlayerState]
var currentState: PlayerState:
	get: return states.front()
var previousState: PlayerState:
	get: return states[1]

var direction := Vector2.ZERO
var gravity := 600.0
var gravity_multiplier := 1.0
var invulnerable := false
var min_health := 0
var health := 100
var max_value := 100

func _ready() -> void:
	print("New")
	%Sword_Collider.disabled = true
	initializeStates()
	dodgeTimer = dodgeTime
	slideTimer = slideTime
	hit_box.Damaged.connect(_take_damage)
	#healthbar.init_health(max_value)
	print("Hitbox = ", hit_box)
	print("HitBox script = ", hit_box.get_script())


func _unhandled_input(event: InputEvent) -> void:
	changeState(currentState.handleInput(event))

func _process(delta: float) -> void:
	update_direction()
	changeState(currentState.process(delta))
	dodgeTimer -= delta
	slideTimer -= delta
	

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta * gravity_multiplier
	move_and_slide()
	changeState(currentState.physics_process(delta))

func initializeStates() -> void:
	states = []
	for c in $States.get_children():
		if c is PlayerState:
			states.append(c)
			c.player = self

	if states.is_empty():
		return

	for s in states:
		s.init()

	changeState(currentState)
	currentState.enter()

func changeState(new_state: PlayerState) -> void:
	if new_state == null or new_state == currentState:
		return

	if currentState:
		currentState.exit()

	states.push_front(new_state)
	currentState.enter()
	states.resize(3)

func update_direction() -> void:
	var x = Input.get_axis("move_left", "move_right")
	var y = Input.get_axis("jump", "move_down")
	direction = Vector2(x, y)

	if x > 0:
		facing_right = true
		scale.x = scale.y
	elif x < 0:
		facing_right = false
		scale.x = -scale.y

func _take_damage(damage: int) -> void:
	if invulnerable:
		return

	update_hp(-damage)
	player_damaged.emit(damage)
	


func update_hp(delta: int) -> void:
	health = clampi(health + delta, 0, max_value)
	print("Player HP after update: ", health)
	
