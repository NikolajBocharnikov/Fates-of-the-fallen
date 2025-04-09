extends AnimationTree

@onready var animation_tree: AnimationTree = $"."
@onready var visuals: Node3D = $"../Visuals"

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	
	if visuals == null:
		return
	
	var anim_tree_state = animation_tree["parameters/Idle_to_Run/current_state"]
	var requested_animation
	#print(anim_tree_state)
	
	var direction := -(Vector2i)((Vector2($"..".velocity.x, $"..".velocity.z)).normalized() * 10)
	#print(direction)
	
	var angle = round(rad_to_deg(atan2(direction.x,direction.y)))
	#print(angle)
	
	if direction:
		match angle:
			_:
				requested_animation = "Run"
				visuals.rotation.y = deg_to_rad(angle)
	else:
		requested_animation = "Idle"
	
	if anim_tree_state != requested_animation:
		animation_tree["parameters/Idle_to_Run/transition_request"] = requested_animation
