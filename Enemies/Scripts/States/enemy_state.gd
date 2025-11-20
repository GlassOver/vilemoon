class_name EnemyState extends Node

## Stores a reference to the enemy that this state belongs to

var enemy : Enemy
var state_machine : EnemyStateMachine



# What happens when this state is initialized?
func init() -> void: 
	pass
	
	
	
# What happens when we enter this state?
func enter() -> void:
	pass
	

# What happens when we exit this state?
func exit() -> void:
	pass


# What happens each process tick in this state?
func process(_delta: float) -> EnemyState:
	return null
	

# What happens each physics process tick in this state?
func physics_process(_delta: float) -> EnemyState:
	return null
