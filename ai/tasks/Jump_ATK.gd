extends BTAction

@warning_ignore("unused_parameter")
func _tick(delta: float) -> Status:
	var vel
	vel = agent.velocity
	agent.velocity = Vector3.ZERO
	agent.jump_ATK(vel)
	return SUCCESS
