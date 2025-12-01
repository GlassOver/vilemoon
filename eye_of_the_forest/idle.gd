extends State
@onready var eye_of_the_forest: EyeOfTheForestBoss = $"../../.."

func enter():
	super.enter()
	owner.set_physics_process(true)
	
func transition():
	var distance = eye_of_the_forest.direction.length()
	
	if distance < 30: 
		get_parent().change_state("s_flamethrower_right")
	
	
