class_name PlayerStateAttack
extends PlayerState



func enter() -> void:
	pass

func exit() -> void:
	pass

func handleInput(_event: InputEvent) -> PlayerState:
	return nextState

func process(_delta: float) -> PlayerState:
	return nextState

func physics_process(_delta: float) -> PlayerState:
	return nextState
