extends BTAction

@export var patrole_radius:float = 5.0

@export var dir_point:StringName = &"dir"

@warning_ignore("unused_parameter")
func _tick(delta: float) -> Status:
	@warning_ignore("unused_variable")
	var dir = rand_dir()
	#print(dir)
	if agent.see_player:return FAILURE
	else:return SUCCESS

func rand_dir():
	var rand_angle = randf_range(0,PI * 2)
	var dir = agent.global_position + (Vector3.RIGHT * sin(rand_angle) + Vector3.FORWARD * cos(rand_angle)) * patrole_radius
	
	blackboard.set_var(dir_point,dir)
	return dir
