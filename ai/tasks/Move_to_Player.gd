extends BTAction

@warning_ignore("unused_parameter")
func _tick(delta: float) -> Status:
	
	if agent.see_player:
		agent.move_to_player()
		if agent.in_akt_range:
			return SUCCESS
		return RUNNING
	else:
		return FAILURE
