class_name PlayerStateAttack
extends PlayerState



func enter() -> void:
	pass

func exit() -> void:
	pass

func handleInput(event: InputEvent) -> PlayerState:
	return nextState

func process(delta: float) -> PlayerState:
	return nextState

func physics_process(delta: float) -> PlayerState:
	return nextState
