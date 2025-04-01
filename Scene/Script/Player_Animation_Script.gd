extends AnimationTree

@onready var animation_tree: AnimationTree = $"."

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	
	var anim_tree_state = animation_tree["parameters/Idle_to_Run/current_state"]
	var requested_animation
	#print(anim_tree_state)
	
	var input_dir := Input.get_vector("ui_go_right", "ui_go_left", "ui_backward", "ui_forward")
	#print(input_dir)
	
	var direction := (Vector2i)((Vector2(input_dir.x, input_dir.y)).normalized() * 10)
	#print(direction)
	
	if direction:
		match direction:
			Vector2i(0,-10): #Forward
				requested_animation = "Run"
			Vector2i(0,10): #Backward
				requested_animation = "Run"
			Vector2i(10,0): #Left
				requested_animation = "Left_Strafe" 
			Vector2i(-10,0): #Right
				requested_animation = "Right_Strafe"  
			Vector2i(7,7):pass #Left_up
			Vector2i(-7,7):pass #Right_up
			Vector2i(7,-7):pass #Left_down
			Vector2i(-7,-7):pass #Right_Down
	else:
		requested_animation = "Idle"
	
	if anim_tree_state != requested_animation:
		animation_tree["parameters/Idle_to_Run/transition_request"] = requested_animation
	
