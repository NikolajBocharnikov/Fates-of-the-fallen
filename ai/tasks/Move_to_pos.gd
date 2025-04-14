extends BTAction

@export var target_pos:= &"dir"

@export var tolerance = 1

@warning_ignore("unused_parameter")
func _tick(delta: float) -> Status:
	var target:Vector3 = blackboard.get_var(target_pos)
	
	if agent.finished_patrole:
		agent.finished_patrole = false
		agent.velocity = Vector3.ZERO
		#print("fin")
		return SUCCESS
	else:
		#print("on the way")
		agent.patrole(target)
		return RUNNING
