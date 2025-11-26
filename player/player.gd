class_name Player extends CharacterBody2D

signal player_damaged(hurt_box: HurtBox)

#region /// On Ready Variables
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_stand: CollisionShape2D = %CollisionShape2D
@onready var collision_crouch: CollisionShape2D = %CollisionCrouch
@onready var one_way_platform_raycast: RayCast2D = %OneWayPlatformRaycast
@onready var ledge_left: RayCast2D = %LedgeLeft
@onready var hit_box: HitBox = $HitBox
@onready var hp_label: Label = $CanvasLayer/HP

#endregion

#region /// Export Variables
@export var move_speed := 500.0
@export var jump_move_speed := 400.0
@export var dodgeTimer := 0.0
@export var dodgeTime := 1.0
@export var attackTimer := 0.0
@export var attackCooldown := 0.3
@export var slideTimer := 0.0
@export var slideTime := 0.3
@export var stopMoving := 0

@export var facing_right := true
@export var isAttacking := false
@export var isSliding:= false
@export var isDodging:= false
#endregion

#region /// Player Statistics

var lvl : int = 1
var xp : int = 0

var min_health := 0
var health := 100
var max_value := 100

var sp : int = 100
@warning_ignore("shadowed_global_identifier")
var str : int = 10 :
	set(v):
		str = v
		update_damage_values()
var def : int = 10
var spi : int = 10
var wil : int = 10
var spd : int = 10



#endregion


var states: Array[PlayerState]
var currentState: PlayerState:
	get: return states.front()
var previousState: PlayerState:
	get: return states[1]

var direction := Vector2.ZERO
var gravity := 600.0
var gravity_multiplier := 1.0
var invulnerable : bool = false
var signalled_state : PlayerState = null


func _ready() -> void:
	PlayerManager.player = self
	initializeStates()
	dodgeTimer = dodgeTime
	slideTimer = slideTime
	attackTimer = attackCooldown
	hit_box.Damaged.connect(_take_damage)
	update_hp(9999)
	update_damage_values()
	PlayerManager.player_leveled_up.connect(update_damage_values)
	#healthbar.init_health(max_value)
#	player_damaged.connect(PlayerState._ready)
	
	


func _unhandled_input(event: InputEvent) -> void:
	changeState(currentState.handleInput(event))

func _process(delta: float) -> void:
	update_direction()
	changeState(currentState.process(delta))
	dodgeTimer -= delta
	slideTimer -= delta
	attackTimer-= delta
	

func _physics_process(delta: float) -> void:
	hp_label.text = str(health)
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



func _take_damage(hurt_box : HurtBox) -> void:
	if invulnerable == true:
		return
	
	if health >= 0:
		var dmg : float = hurt_box.damage
		
		if dmg > 0:
			dmg = clampi(dmg - def, 1, dmg)
		
		update_hp(-dmg)
		player_damaged.emit(hurt_box)
		
	else:
		player_damaged.emit(hurt_box)
		update_hp(9999)
	pass
	

func update_hp(delta: int) -> void:
	health = clampi(health + delta, 0, max_value)
	print("Player HP after update: ", health)
	

func make_invulnerable(_duration : float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer(_duration).timeout
	
	invulnerable = false
	hit_box.monitoring = true
	pass
	
	
	
func update_damage_values() -> void:
	$HurtBox.damage = str 
	
	
	pass
