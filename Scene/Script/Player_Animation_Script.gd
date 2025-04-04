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
	
	var input_dir := Input.get_vector("ui_go_right", "ui_go_left", "ui_backward", "ui_forward")
	#print(input_dir)
	
	var direction := (Vector2i)((Vector2(input_dir.x, input_dir.y)).normalized() * 10)
	#print(direction)
	
	if direction:
		match direction:
			Vector2i(0,-10): #Backward
				requested_animation = "Run"
				visuals.rotation.y = deg_to_rad(180)
			Vector2i(0,10): #Forward
				requested_animation = "Run"
				visuals.rotation.y = deg_to_rad(0)
			Vector2i(10,0): #Left
				requested_animation = "Run"
				visuals.rotation.y = deg_to_rad(90)
			Vector2i(-10,0): #Right
				requested_animation = "Run"
				visuals.rotation.y = deg_to_rad(-90)
			Vector2i(7,7): #Left_up
				requested_animation = "Run"
				visuals.rotation.y = deg_to_rad(45)
			Vector2i(-7,7): #Right_up
				requested_animation = "Run"
				visuals.rotation.y = deg_to_rad(315)
			Vector2i(7,-7): #Left_down
				requested_animation = "Run"
				visuals.rotation.y = deg_to_rad(135)
			Vector2i(-7,-7): #Right_down
				requested_animation = "Run"
				visuals.rotation.y = deg_to_rad(225)
	else:
		requested_animation = "Idle"
	
	if anim_tree_state != requested_animation:
		animation_tree["parameters/Idle_to_Run/transition_request"] = requested_animation
	
