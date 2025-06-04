extends CharacterBody3D

@export var SPEED = 5.0
@export var CAMERA:Camera3D
@export var VISUALS:Node3D
@export var WEAPON:Node3D

const JUMP_VELOCITY = 4.5

var CURRENT_HP:float
var HIT:bool = false

var is_alive:bool = true
var go_to_obj:bool = false
var hit_node:Node3D = null
var prev_hit_node:Node3D = null
var ray_result_buffer
var dash:bool = false
var dash_time:float = 0.0

func _ready() -> void:
	CURRENT_HP = float(GData.GAME_DATA["HP"])

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact_btn"):
		if !ray_result_buffer.collider.get_parent().has_node("Area"): go_to_obj=false
		else: go_to_obj = true

func _physics_process(delta: float) -> void:
	if !is_alive:
		return
	
	if not is_on_floor():
		#print(velocity.y)
		velocity += get_gravity() * delta # Add the gravity.
		$Visuals/Steps_Smoke_L.visible = false
		$Visuals/Steps_Smoke_R.visible = false
	
	if is_on_floor():
		$Visuals/Steps_Smoke_L.visible = true
		$Visuals/Steps_Smoke_R.visible = true
	
	if Input.is_action_just_pressed("ui_jump") and is_on_floor(): 
		velocity.y = JUMP_VELOCITY # Handle jump.

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("ui_go_right", "ui_go_left", "ui_backward", "ui_forward")
	var direction := CAMERA.transform.basis * (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if dash:
			velocity.x = direction.x * SPEED * 5
			velocity.z = direction.z * SPEED * 5
			dash_time += snappedf(delta,0.001)
		else:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		
		#print(snappedf(delta,0.001))
		if dash_time >=0.2:
			#print(dash_time)
			dash = false
			dash_time = 0
		
		go_to_obj = false
	
	elif is_on_floor() and !go_to_obj:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	elif $Player_nav.distance_to_target() < 2.0:
		if hit_node != null: #Mesh Outline On/Off
			if prev_hit_node != hit_node:
				if prev_hit_node != null and prev_hit_node.has_node("MeshInstance3D"):
					prev_hit_node.get_node("MeshInstance3D").visible = false
					#print(prev_hit_node)
				prev_hit_node = hit_node
			if hit_node.has_node("MeshInstance3D"): hit_node.get_node("MeshInstance3D").visible = true
		
		#print($Player_nav.get_final_position())
		var fin_pos = Vector3(snappedf($Player_nav.get_final_position().x,0.1),0.0,snappedf($Player_nav.get_final_position().z,0.1))
		var pl_pos = Vector3(snappedf(self.global_position.x,0.1),0.0,snappedf(self.global_position.z,0.1))
		#print(fin_pos,pl_pos)
		if fin_pos == pl_pos and go_to_obj:
			#print("fin")
			go_to_obj = false
		
	#print(self.rotation.y)
	
	move_and_slide()
	look_at_mouse()
	go_to_interactible_obj()
	#print(snappedf($Player_nav.distance_to_target(),0.1))

func look_at_mouse():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = CAMERA.project_ray_origin(mouse_pos)
	var ray_dir = ray_origin + CAMERA.project_ray_normal(mouse_pos) * 500
	
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin,ray_dir)
	
	ray_query.collide_with_bodies = true
	
	var space_state = get_world_3d().direct_space_state
	var ray_result = space_state.intersect_ray(ray_query)
	
	if(!ray_result.is_empty()):
		#self.look_at(ray_result.position)
		if ray_result.collider.position != Vector3.ZERO:
			if ray_result.collider.get_node_or_null("Area") != null:
				WEAPON.look_at(ray_result.collider.get_node_or_null("Area").global_position)
				#print(ray_result.collider.get_node_or_null("Area").global_position)
			else :WEAPON.look_at(ray_result.position)
		else: WEAPON.look_at(ray_result.position)
		#WEAPON.rotation = WEAPON.rotation_degrees.clamp(Vector3(-25.0,0.0,0.0),Vector3(50.0,0.0,0.0))
		#print(WEAPON.rotation)
		#print(ray_result.collider.position)
		#self.rotation = self.rotation * Vector3(0,1,1)
		#print(ray_result.position)

func go_to_interactible_obj():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = CAMERA.project_ray_origin(mouse_pos)
	var ray_dir = ray_origin + CAMERA.project_ray_normal(mouse_pos) * 500
	
	var ray_query_r = PhysicsRayQueryParameters3D.create(ray_origin,ray_dir)
	
	ray_query_r.collide_with_bodies = true
	ray_query_r.hit_from_inside = true
	
	var space_state = get_world_3d().direct_space_state
	var ray_result = space_state.intersect_ray(ray_query_r)
	
	#print(ray_result)
	#if!ray_result.is_empty() : print(ray_result.position)
	
	ray_result_buffer = ray_result
	
	if(!ray_result.is_empty() and Input.is_action_just_pressed("interact_btn")):
		if ray_result.collider.get_parent().has_node("Area"):
			hit_node = ray_result.collider.get_parent() as Node3D
			if hit_node.get_node("Area").selected_scene != null and $"../Level_Changer" != null:
				$"../Level_Changer".next_scene = hit_node.get_node("Area").selected_scene
				if hit_node.has_node("Rotate_point"):
					if hit_node.has_method("look_at_player"):
						hit_node.look_at_player(self)
			#print("yes")
		#print(hit_node)
		#print(ray_result.collider.get_parent().has_node("Area"))
		#print(ray_result.collider.get_parent())
	
	if go_to_obj:
		if hit_node.get_node("Area").is_in_group("Interacteble"):
			$Player_nav.set_target_position(hit_node.get_node("Rotate_point").get_child(0).global_position)
			velocity.x = global_position.direction_to($Player_nav.get_next_path_position()).x * SPEED
			velocity.z = global_position.direction_to($Player_nav.get_next_path_position()).z * SPEED
			if_stuck()

var current_pos:Vector2 = Vector2(0,0)
var buffer_pos:Vector2 = Vector2(0,0)

func if_stuck(): #Works good, can worck better, redo if needed
	current_pos.x = global_position.x
	current_pos.y = global_position.z
	if current_pos == buffer_pos and buffer_pos != Vector2(0,0):
		#print(current_pos,buffer_pos)
		velocity.y = JUMP_VELOCITY
	buffer_pos = current_pos

func _on_area_body_entered(body: Node3D) -> void:
	if !is_on_floor():
		velocity.x = move_toward(velocity.x, 0, .5)
		velocity.z = move_toward(velocity.z, 0, .5)
	
	if body.is_in_group("Enemy"):
		CURRENT_HP -= 1.0
		HIT = true
		
		var z:int = randi_range(-1,1)
		if z == 0: z = 1
		
		velocity = Vector3(randf_range(5,10) * z,0,randf_range(5,10) * z)
		velocity.y = JUMP_VELOCITY
		
		if CURRENT_HP == 0.0:
			is_alive = false
			if VISUALS != null:
				VISUALS.visible = false
		await get_tree().create_timer(100).timeout
