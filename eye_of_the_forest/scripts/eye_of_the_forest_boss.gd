class_name EyeOfTheForestBoss extends Node2D

const ENERGY_EXPLOSION_SCENE : PackedScene = preload("res://eye_of_the_forest/energy_explosion.tscn")
const SLASH_SCENE: PackedScene = preload("res://eye_of_the_forest/realslash.tscn")
const FIRE_STREAM_SCENE: PackedScene = preload("res://eye_of_the_forest/Slash.tscn")
const FIRE_BALL_SCENE: PackedScene = preload("res://eye_of_the_forest/fire wall.tscn")
const FLAME_WALL_SCENE: PackedScene = preload("res://eye_of_the_forest/flamewall.tscn")
const DRONE_SCENE: PackedScene = preload("res://eye_of_the_forest/drone.tscn")
const ATTACK_DRONE_SCENE: PackedScene = preload("res://Enemies/Goblin/goblin.tscn")
const FLAMETHROWER_SCENE: PackedScene = preload("res://eye_of_the_forest/flamethrower.tscn")
const SUPERFLAMETHROWER_SCENE: PackedScene = preload("res://eye_of_the_forest/superflamethrower.tscn")


@export var max_hp : int = 1000
var hp : int = 10
var xp_reward : float = 500
#var audio_hurt : AudioStream = preload()
#var audio_shoot : AudioStream = preload()




@onready var boss_node: Node2D = $BossNode
@onready var persistent_data_handler: PersistentDataHandler = $PersistentDataHandler
@onready var hurt_box: HurtBox = $BossNode/HurtBox
@onready var hit_box: HitBox = $BossNode/HitBox
@onready var hyperdeath: AudioStreamPlayer2D = $Hyperdeath
@onready var charge_audio: AudioStreamPlayer2D = $ChargeAudio
@onready var slash_pre: AudioStreamPlayer2D = $SlashPre
@onready var monologue_audio: AudioStreamPlayer2D = $MonologueAudio
@onready var boss_music: AudioStreamPlayer2D = $BossMusic


#region /// Positions
@onready var pos1: Sprite2D = $PositionTargets/Sprite2D
@onready var pos2: Sprite2D = $PositionTargets/Sprite2D2
@onready var pos3: Sprite2D = $PositionTargets/Sprite2D3
@onready var pos4: Sprite2D = $PositionTargets/Sprite2D4
@onready var pos5: Sprite2D = $PositionTargets/Sprite2D5
@onready var dronepos1: Sprite2D = $PositionTargets/Sprite2D6
@onready var dronepos2: Sprite2D = $PositionTargets/Sprite2D7
@onready var flamethrower1: Sprite2D = $PositionTargets/Sprite2D8
@onready var flamethrower2: Sprite2D = $PositionTargets/Sprite2D9
@onready var flamethrower3: Sprite2D = $PositionTargets/Sprite2D10
@onready var flamethrower4: Sprite2D = $PositionTargets/Sprite2D11
#endregion


#region /// Mega Flame Thrower Positions
###Left to Right
@onready var mftp: Sprite2D = $"PositionTargets/MFT Left to Right/MFTP"
@onready var mftp_2: Sprite2D = $"PositionTargets/MFT Left to Right/MFTP2"
@onready var mftp_3: Sprite2D = $"PositionTargets/MFT Left to Right/MFTP3"
@onready var mftp_4: Sprite2D = $"PositionTargets/MFT Left to Right/MFTP4"
@onready var mftp_5: Sprite2D = $"PositionTargets/MFT Left to Right/MFTP5"
@onready var mftp_6: Sprite2D = $"PositionTargets/MFT Left to Right/MFTP6"
@onready var mftp_7: Sprite2D = $"PositionTargets/MFT Left to Right/MFTP7"
@onready var mftp_8: Sprite2D = $"PositionTargets/MFT Left to Right/MFTP8"
@onready var mftp_9: Sprite2D = $"PositionTargets/MFT Left to Right/MFTP9"
@onready var mftp_10: Sprite2D = $"PositionTargets/MFT Left to Right/MFTP10"
@onready var mftp_11: Sprite2D = $"PositionTargets/MFT Left to Right/MFTP11"
###Right to Left
@onready var mftpr_11: Sprite2D = $"PositionTargets/MFT Right to Left/MFTP"
@onready var mftpr_10: Sprite2D = $"PositionTargets/MFT Right to Left/MFTP2"
@onready var mftpr_9: Sprite2D = $"PositionTargets/MFT Right to Left/MFTP3"
@onready var mftpr_8: Sprite2D = $"PositionTargets/MFT Right to Left/MFTP4"
@onready var mftpr_7: Sprite2D = $"PositionTargets/MFT Right to Left/MFTP5"
@onready var mftpr_6: Sprite2D = $"PositionTargets/MFT Right to Left/MFTP6"
@onready var mftpr_5: Sprite2D = $"PositionTargets/MFT Right to Left/MFTP7"
@onready var mftpr_4: Sprite2D = $"PositionTargets/MFT Right to Left/MFTP8"
@onready var mftpr_3: Sprite2D = $"PositionTargets/MFT Right to Left/MFTP9"
@onready var mftpr_2: Sprite2D = $"PositionTargets/MFT Right to Left/MFTP10"
@onready var mftpr: Sprite2D = $"PositionTargets/MFT Right to Left/MFTP11"
#endregion

var direction : Vector2
var attack_cooldown : float = 4.0
var attack_cooldown_timer : float = 1
var isAttacking : bool = false
var finalStarted : bool = false
var finalFinished : bool = false
var battleStarted : bool = false
var musicPlaying : bool = false

enum BossState { IDLE, CHOOSING_ATTACK, ATTACKING }

var state: BossState = BossState.IDLE
var current_attack: Callable


func _ready() -> void:
	hp = max_hp
	hit_box.Damaged.connect(damage_taken)
	attack_cooldown_timer = attack_cooldown
#	monologue_audio.play()
#	await monologue_audio.finished
	battleStarted = true
#	if battleStarted == false:
	#audiostreamplayer
	#await
	#battleStarted = true
		
	
	
func _process(delta: float) -> void:
#maybe I put all of this into an if statement?
	#if battleStarted = true:
	attack_cooldown_timer -= delta
	if state == BossState.IDLE and attack_cooldown_timer <= 0 and finalStarted == false and battleStarted == true:
		bossMusic()
		choose_attack()
	if finalFinished == true:
		enable_hit_boxes(true)
	
		
func bossMusic() -> void:
	if battleStarted == true and musicPlaying == false:
		boss_music.play()
		musicPlaying = true
		await boss_music.finished
		musicPlaying = false
		bossMusic()
	


func choose_attack() -> void:
	var distance = (PlayerManager.player.global_position - boss_node.global_position).length()

	var attack_pool = []

	# Close-range pool
	if distance < 320:
		attack_pool.append_array([
			["flamethrower_right", 3], # weighted 3
			["flame_run", 3],
			["shoot_slash", 3],
			["drone_strike", 3],
			["flame_combo", 3],
		])

	# Mid-range
	elif distance > 319:
		attack_pool.append_array([
			["fire_stream", 1],
			["flame_combo", 3],
			["static_firestream", 2],
			["shoot_slash", 2],
			["flamethrower", 1],
			["flamethrower_left", 2],
			["flamethrower_right", 1]
		])
		
	elif distance > 400:
		attack_pool.append_array([
			["flamethrower_left", 3],
			["flamethrower_left", 3],
			["mobility_test", 2],
			["flame_run", 3],
			["call_reinforcements", 1],
			["flame_wall", 1],
			["shoot_slash", 1],
		])

	# Long range aerial punish
		if not PlayerManager.player.is_on_floor():
			attack_pool.append_array([
				["shoot_slash", 3],
				["fire_wall", 2],
				["flame_combo", 2],
				["drone_strike", 2 ],
			])

	if attack_pool.is_empty():
		return

	var selected = pick_weighted(attack_pool)
	run_attack(selected)


func pick_weighted(pool: Array) -> String:
	var total_weight = 0
	for item in pool:
		total_weight += item[1]

	var roll = randi() % total_weight
	var cumulative = 0

	for item in pool:
		cumulative += item[1]
		if roll < cumulative:
			return item[0]

	return pool[0][0]



func run_attack(attack_name: String) -> void:
	state = BossState.ATTACKING
	attack_cooldown_timer = attack_cooldown

	match attack_name:
		"flame_combo":
			await do_attack(flame_combo, 0.1)
		"flame_run":
			await do_attack(flame_run, 0.1)
		"call_reinforcements":
			await do_attack(call_reinforcements, 0.3)
		"static_firestream":
			await do_attack(static_firestream, 0.1)
		"mobility_test":
			await do_attack(mobility_test, 0.3)
		"flame_wall":
			await do_attack(flame_wall, 0.3)
		"flamethrower_left":
			await do_attack(sflamethrower_left, 0.3)
		"drone_strike":
			await do_attack(drone_strike, 0.3)
		"flamethrower":
			await do_attack(flamethrower, 0.1)
		"flamethrower_right":
			await do_attack(sflamethrower_right, 0.1)
		"fire_stream":
			await do_attack(fire_stream, 0.1)
		"fire_wall":
			await do_attack(fire_wall, 0.3)
		"shoot_slash":
			await do_attack(shoot_slash, 0.0)

func do_attack(func_ref: Callable, duration: float) -> void:
	func_ref.call()
	await get_tree().create_timer(duration).timeout
	state = BossState.IDLE



		
		
func idle() -> void:
	if finalStarted == false:
		enable_hit_boxes()
	
	#animation_player.play("cast_spell")
	#await animation_player.animation_finished
	#animation_player.play("idle")
	#await animation_player.animation_finished
	
	pass
	
	
func update_animations() -> void:

	pass


#region Attacks
func shoot_slash() -> void:
	var eb : Node2D = SLASH_SCENE.instantiate()
	slash_pre.play()
	await slash_pre.finished
	eb.global_position = boss_node.global_position + Vector2(0, -34)
	get_parent().add_child.call_deferred(eb)
	#play_audio(audio_shoot)
	
func fire_wall() -> void:
	var fw : Node2D = FIRE_BALL_SCENE.instantiate()
	fw.global_position = pos1.global_position
	get_parent().add_child.call_deferred(fw)
	var fw2 : Node2D = FIRE_BALL_SCENE.instantiate()
	fw2.global_position = pos2.global_position
	get_parent().add_child.call_deferred(fw2)
	var fw3 : Node2D = FIRE_BALL_SCENE.instantiate()
	fw3.global_position = pos3.global_position
	get_parent().add_child.call_deferred(fw3)

func fire_stream() -> void:
	var fs : Node2D = FIRE_STREAM_SCENE.instantiate()
	fs.global_position = pos4.global_position
	get_parent().add_child.call_deferred(fs)
	
func flame_wall() -> void:
	var flw : Node2D = FLAME_WALL_SCENE.instantiate()
	charge_audio.play()
	await charge_audio.finished
	hyperdeath.play()
	flw.global_position = pos5.global_position
	get_parent().add_child.call_deferred(flw)
	
func drone_strike() -> void:
	var d : Node2D = DRONE_SCENE.instantiate()
	d.global_position = dronepos1.global_position
	get_parent().add_child.call_deferred(d)
	var d2 : Node2D = DRONE_SCENE.instantiate()
	d2.global_position = dronepos2.global_position
	get_parent().add_child.call_deferred(d2)
	
func reinforcements() -> void:
	var re : Node2D = ATTACK_DRONE_SCENE.instantiate()
	re.global_position = dronepos1.global_position
	get_parent().add_child.call_deferred(re)
	var re2 : Node2D = ATTACK_DRONE_SCENE.instantiate()
	re2.global_position = dronepos2.global_position
	get_parent().add_child.call_deferred(re2)
	
func flamethrower() -> void:
	var ft : Node2D = FLAMETHROWER_SCENE.instantiate()
	ft.global_position = flamethrower1.global_position
	get_parent().add_child.call_deferred(ft)
	var ft2 : Node2D = FLAMETHROWER_SCENE.instantiate()
	ft2.global_position = flamethrower2.global_position
	get_parent().add_child.call_deferred(ft2)
	var ft3 : Node2D = FLAMETHROWER_SCENE.instantiate()
	ft3.global_position = flamethrower3.global_position
	get_parent().add_child.call_deferred(ft3)
	var ft4 : Node2D = FLAMETHROWER_SCENE.instantiate()
	ft4.global_position = flamethrower4.global_position
	get_parent().add_child.call_deferred(ft4)


func sflamethrower_left() -> void:
	var sftl : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl.global_position = mftp.global_position
	get_parent().add_child.call_deferred(sftl)
	await get_tree().create_timer(0.1).timeout 
	var sftl2 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl2.global_position = mftp_2.global_position
	get_parent().add_child.call_deferred(sftl2)
	await get_tree().create_timer(0.1).timeout 
	var sftl3 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl3.global_position = mftp_3.global_position
	get_parent().add_child.call_deferred(sftl3)
	await get_tree().create_timer(0.1).timeout 
	var sftl4 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl4.global_position = mftp_4.global_position
	get_parent().add_child.call_deferred(sftl4)
	await get_tree().create_timer(0.1).timeout 
	var sftl5 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl5.global_position = mftp_5.global_position
	get_parent().add_child.call_deferred(sftl5)
	await get_tree().create_timer(0.1).timeout 
	var sftl6 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl6.global_position = mftp_6.global_position
	get_parent().add_child.call_deferred(sftl6)
	await get_tree().create_timer(0.1).timeout 
	var sftl7 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl7.global_position = mftp_7.global_position
	get_parent().add_child.call_deferred(sftl7)
	await get_tree().create_timer(0.1).timeout 	
	var sftl8 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl8.global_position = mftp_8.global_position
	get_parent().add_child.call_deferred(sftl8)
	await get_tree().create_timer(0.1).timeout 
	var sftl9 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl9.global_position = mftp_9.global_position
	get_parent().add_child.call_deferred(sftl9)
	await get_tree().create_timer(0.1).timeout 
	var sftl10 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl10.global_position = mftp_10.global_position
	get_parent().add_child.call_deferred(sftl10)
	await get_tree().create_timer(0.1).timeout 
	var sftl11 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl11.global_position = mftp_11.global_position
	get_parent().add_child.call_deferred(sftl11)
	
	
func sflamethrower_right() -> void:
	var sftl : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl.global_position = mftpr.global_position
	get_parent().add_child.call_deferred(sftl)
	await get_tree().create_timer(0.1).timeout 
	var sftl2 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl2.global_position = mftpr_2.global_position
	get_parent().add_child.call_deferred(sftl2)
	await get_tree().create_timer(0.1).timeout 
	var sftl3 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl3.global_position = mftpr_3.global_position
	get_parent().add_child.call_deferred(sftl3)
	await get_tree().create_timer(0.1).timeout 
	var sftl4 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl4.global_position = mftpr_4.global_position
	get_parent().add_child.call_deferred(sftl4)
	await get_tree().create_timer(0.1).timeout 
	var sftl5 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl5.global_position = mftpr_5.global_position
	get_parent().add_child.call_deferred(sftl5)
	await get_tree().create_timer(0.1).timeout 
	var sftl6 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl6.global_position = mftpr_6.global_position
	get_parent().add_child.call_deferred(sftl6)
	await get_tree().create_timer(0.1).timeout 
	var sftl7 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl7.global_position = mftpr_7.global_position
	get_parent().add_child.call_deferred(sftl7)
	await get_tree().create_timer(0.1).timeout 	
	var sftl8 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl8.global_position = mftpr_8.global_position
	get_parent().add_child.call_deferred(sftl8)
	await get_tree().create_timer(0.1).timeout 
	var sftl9 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl9.global_position = mftpr_9.global_position
	get_parent().add_child.call_deferred(sftl9)
	await get_tree().create_timer(0.1).timeout 
	var sftl10 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl10.global_position = mftpr_10.global_position
	get_parent().add_child.call_deferred(sftl10)
	await get_tree().create_timer(0.1).timeout 
	var sftl11 : Node2D = SUPERFLAMETHROWER_SCENE.instantiate()
	sftl11.global_position = mftpr_11.global_position
	get_parent().add_child.call_deferred(sftl11)
#endregion


func flame_combo() -> void:
	fire_stream()
	await get_tree().create_timer(1.3).timeout
	fire_wall()
	await get_tree().create_timer(1).timeout
	flame_wall()
	
func flame_run() -> void:
	sflamethrower_right()
	await get_tree().create_timer(2).timeout
	sflamethrower_left()
	
func call_reinforcements() -> void:
	reinforcements()
	await get_tree().create_timer(2).timeout
	reinforcements()
	await get_tree().create_timer(5).timeout
	
func static_firestream() -> void:
	flamethrower()
	await get_tree().create_timer(1).timeout
	fire_stream()
	
func slash_flamethrower() -> void:
	flamethrower()
	await get_tree().create_timer(0.3).timeout
	shoot_slash()
	await get_tree().create_timer(0.3).timeout
	shoot_slash()

func mobility_test() -> void:
	fire_wall()
	await get_tree().create_timer(0.8).timeout
	fire_stream()
	await get_tree().create_timer(1).timeout
	fire_wall()
	await get_tree().create_timer(1.3).timeout
	drone_strike()
	

#region Final Attack
func final_attack() -> void:
	sflamethrower_right()
	await get_tree().create_timer(2).timeout 
	sflamethrower_left()
	await get_tree().create_timer(2.5).timeout 
	shoot_slash()
	await get_tree().create_timer(0.3).timeout 
	shoot_slash()
	await get_tree().create_timer(0.8).timeout 
	fire_wall()
	await get_tree().create_timer(0.9).timeout 
	fire_stream()
	await get_tree().create_timer(0.2).timeout
	flamethrower() 
	await get_tree().create_timer(0.8).timeout 
	shoot_slash()
	await get_tree().create_timer(0.3).timeout 
	shoot_slash()
	await get_tree().create_timer(2.7).timeout 
	flame_wall()
	await get_tree().create_timer(1.8).timeout 
	drone_strike()
	await get_tree().create_timer(1).timeout
	drone_strike()
	await get_tree().create_timer(1).timeout
	sflamethrower_left()
	await get_tree().create_timer(2).timeout 
	sflamethrower_right()
	await get_tree().create_timer(1.2).timeout
	flame_wall()
	await get_tree().create_timer(1).timeout
	drone_strike()
	await get_tree().create_timer(1).timeout
	drone_strike()
	await get_tree().create_timer(1.8).timeout
	drone_strike()
	await get_tree().create_timer(2.5).timeout
	drone_strike()
	await get_tree().create_timer(4).timeout
	drone_strike()
	await get_tree().create_timer(7).timeout
	drone_strike()
	await get_tree().create_timer(5).timeout
	drone_strike()
	finalFinished = true
	hp = 1
#endregion


func damage_taken(_hurt_box : HurtBox) -> void:
		#if animation_player_damaged.current_animation == "damaged" or _hurt_box.damage == 0:
			#return
		#play_audio(audio_hurt)
		hp = clampi(hp - _hurt_box.damage, 0, max_hp)
		EffectManager.damage_text(hp, global_position + Vector2(0,-36) )
		#animation_player_damaged.play("damaged")
		#animation_player_damaged.seek(0)
		#animation_player_damaged.queue("default")
		if hp < 40:
			final_config()
		if hp < 1:
			defeat()
		
	
#func play_audio(_a : AudioStream) -> void:
	#audio.stream = _a
	#audio.play()
	
func final_config():
	finalStarted = true
	print("final started")
	enable_hit_boxes(false)
	final_attack()
	
func defeat() -> void:
	#animation_player.play("destroy)
	enable_hit_boxes(false)
	persistent_data_handler.set_value()
	explosion()
	#await animation_player.animation_finished

	
func enable_hit_boxes(_v : bool = true) -> void:
	hit_box.set_deferred("monitorable", _v)
	hurt_box.set_deferred("monitoring", _v)
	
	
	
func explosion(_p : Vector2 = Vector2.ZERO) -> void:
	var e : Node2D = ENERGY_EXPLOSION_SCENE.instantiate()
	e.global_position = boss_node.global_position + _p
	get_parent().add_child.call_deferred(e)
	PlayerManager.reward_xp(xp_reward)
	queue_free()
	await get_tree().create_timer(10).timeout
	get_tree().quit()
	#call this in defeat animation later
	pass
	
