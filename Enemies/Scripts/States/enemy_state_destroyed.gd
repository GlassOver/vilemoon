class_name EnemyStateDestroy extends EnemyState

const PICKUP = preload("res://items/item_pickup/item_pickup.tscn")


@export var anim_name : String = "destroy"
@export var knockback_speed : float = 3000.0
@export var decelerate_speed : float = 1800.0

@export_category("AI")

@export_category("Item Drops")
@export var drops : Array[DropData]

var _damage_position : Vector2
var _direction := Vector2.ZERO



func init() -> void:
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)

func enter() -> void:
	enemy.invunlerable = true
	_direction = (enemy.global_position - _damage_position).normalized()
	enemy.velocity = _direction * knockback_speed
	# Start animation if needed
	# enemy.update_animation(anim_name)
	drop_items()
	PlayerManager.reward_xp(enemy.xp_reward)
	disable_hurt_box()
	_on_animation_finished() # or wait for real animation

func exit() -> void:
	pass
	
	
func process(_delta: float) -> EnemyState:
	return 

func physics(_delta: float) -> EnemyState:
	# Smooth deceleration
	enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, decelerate_speed * _delta)
	return null

func _on_enemy_destroyed(hurt_box : HurtBox) -> void:
	_damage_position = hurt_box.global_position
	state_machine.change_state(self)

func _on_animation_finished() -> void:
	enemy.queue_free()
	
func disable_hurt_box() -> void:
	var hurt_box : HurtBox = enemy.get_node_or_null("HurtBox")
	if hurt_box:
		hurt_box.monitoring = false
		
		

func drop_items() -> void:
	if drops.size() == 0:
		return
	
	for i in drops.size():
		if drops[i] == null or drops[i].item == null:
			continue
		var drop_count : int = drops[i].get_drop_count()
		for j in drop_count:
			var drop : ItemPickup = PICKUP.instantiate() as ItemPickup
			drop.item_data = drops[i].item
			enemy.get_parent().call_deferred("add_child", drop)
			drop.global_position = enemy.global_position + Vector2(randf() * 16, randf() * 16)
	
	
