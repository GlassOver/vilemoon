class_name Player extends CharacterBody2D

signal player_damaged(hurt_box: HurtBox)

#region /// On Ready Variables
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_stand: CollisionShape2D = %CollisionShape2D
@onready var collision_crouch: CollisionShape2D = %CollisionCrouch
@onready var one_way_platform_raycast: RayCast2D = %OneWayPlatformRaycast
@onready var ledge_left: RayCast2D = %LedgeLeft
@onready var hit_box: HitBox = $HitBox
@onready var crouch_hit_box: HitBox = $CrouchHitBox

#endregion

#region /// Export Variables
@export var move_speed := 500.0
@export var jump_move_speed := 400.0
@export var dodgeTimer := 0.0
@export var dodgeTime := 0.7
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
var currentsp = sp
@warning_ignore("shadowed_global_identifier")
var str : int = 10 :
	set(v):
		str = v
		update_damage_values()
var def : int = 10
var def_bonus : int = 0
var spi : int = 10
var wil : int = 10
var spd : int = 10

var buff_multiplier : float = 1.3
var debuff_multiplier : float = 1.2
var bd_time : float = 25
var bd_timer : float = 0
var bd_freeze_time : float = 3
var bd_freeze_timer : float = 0
var buffed : float = 0
var d_buffed : float = 0
var maxbuff : float = 3

var str_buff_value = 0
var buff_1 : float = 0
var buff_2 : float = 0

var def_buff_value = 0
var d_buff_1 : float = 0
var d_buff_2 : float = 0

var canMove : bool = true

#When you press LB your player will begin casting.
#You will freeze for two seconds, and if you are uninterrupted
#And you didn't just cast, and your buffed variable is less than 3 
#The buff code runs. 
#Once the buff code runs it will start a duration timer
#In this duratiion timer code it adds +1 to your buffed variable

#if input.is_action_just_pressed() & bd_freeze_time <=0 & buffed != maxbuff
#Await 2 seconds
#run buff

#in buff:
#increases player str
#increases the buffed count by 1
#starts the duration timer
#in process there will be a function that says
#if duration <= 0 & buffed >= 1
#run unbuff
#unbuff will simply subtract 1 from buffed

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
	bd_freeze_timer = bd_freeze_time
	bd_timer = bd_time
	hit_box.Damaged.connect(_take_damage)
	crouch_hit_box.Damaged.connect(_take_damage)
	update_hp(9999)
	update_damage_values()
	PlayerManager.player_leveled_up.connect(update_damage_values)
	PlayerManager.INVENTORY_DATA.equipment_changed.connect(_on_equipment_changed)
	#healthbar.init_health(max_value)
#	player_damaged.connect(PlayerState._ready)
	
func getOriginalStr() -> void:
	if buffed == 0:
		str_buff_value = str
	if d_buffed == 0:
		def_buff_value = def



func _unhandled_input(event: InputEvent) -> void:
	changeState(currentState.handleInput(event))

func _process(delta: float) -> void:
	update_direction()
	getOriginalStr()
	changeState(currentState.process(delta))
	dodgeTimer -= delta
	slideTimer -= delta
	attackTimer-= delta
	bd_freeze_timer -= delta
	bd_timer -= delta
	
	
	if Input.is_action_just_pressed("left_magic") and bd_freeze_timer <= 0 and buffed < 3 and currentsp >= 12:
		bd_freeze_timer = bd_freeze_time
		canMove = false
		await get_tree().create_timer(2).timeout 
		canMove = true
		buffed += 1
		currentsp -= 12
		buff()
	if bd_timer <= 0 and buffed >= 1:
		unbuff()
		
	if Input.is_action_just_pressed("right_magic") and bd_freeze_timer <= 0 and d_buffed < 3 and currentsp >= 12:
		bd_freeze_timer = bd_freeze_time
		canMove = false
		await get_tree().create_timer(2).timeout 
		canMove = true
		d_buffed += 1
		currentsp -= 12
		d_buff()
	if bd_timer <= 0 and d_buffed >= 1:
		d_unbuff()
		

#region ### Defense Buff	
func d_buff() -> void:
	if d_buffed == 1:
		@warning_ignore("narrowing_conversion")
		def = def*buff_multiplier
		bd_timer = bd_time
		d_buff_1 = def
		
	if d_buffed == 2:
		@warning_ignore("narrowing_conversion")
		def = def*buff_multiplier
		bd_timer = bd_time
		d_buff_2 = def
		
	if d_buffed == 3:
		@warning_ignore("narrowing_conversion")
		def = def*buff_multiplier
		bd_timer = bd_time
		
		
		
func d_unbuff() -> void:
	if d_buffed == 1:
		d_buffed -= 1
		@warning_ignore("narrowing_conversion")
		def = def_buff_value

		
	if d_buffed == 2:
		d_buffed -= 1
		@warning_ignore("narrowing_conversion")
		def = d_buff_1

	if d_buffed == 3:
		d_buffed -= 1
		@warning_ignore("narrowing_conversion")
		def = d_buff_2

#endregion	

#region ###Strength Buff
func buff() -> void:
	if buffed == 1:
		@warning_ignore("narrowing_conversion")
		str = str*buff_multiplier
		bd_timer = bd_time
		buff_1 = str
		
		print("buff 1")
	if buffed == 2:
		@warning_ignore("narrowing_conversion")
		str = str*buff_multiplier
		bd_timer = bd_time
		buff_2 = str
		print("buffed 2")
		
	if buffed == 3:
		@warning_ignore("narrowing_conversion")
		str = str*buff_multiplier
		bd_timer = bd_time
		print("buffed 3")
#unfreeze movement.

func unbuff() -> void:
	if buffed == 1:
		buffed -= 1
		@warning_ignore("narrowing_conversion")
		str = str_buff_value
		print("debuff 1")
		print(currentsp)
		
	if buffed == 2:
		buffed -= 1
		@warning_ignore("narrowing_conversion")
		str = buff_1
		print("debuff 2")

	if buffed == 3:
		buffed -= 1
		@warning_ignore("narrowing_conversion")
		str = buff_2
		print("debuff 3")
#endregion

func _physics_process(delta: float) -> void:
	if not canMove:
		velocity = Vector2.ZERO
		return

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
			@warning_ignore("narrowing_conversion")
			dmg = clampi(dmg - def - def_bonus, 1, dmg)
			
		
		@warning_ignore("narrowing_conversion")
		update_hp(-dmg)
		EffectManager.damage_text(health, global_position + Vector2(0,-36))
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
	var damage_value : int = str + PlayerManager.INVENTORY_DATA.get_attack_bonus()
	$HurtBox.damage = damage_value
	
	
	pass
	
	
func _on_equipment_changed() -> void:
	update_damage_values()
	def_bonus = PlayerManager.INVENTORY_DATA.get_defense_bonus()
