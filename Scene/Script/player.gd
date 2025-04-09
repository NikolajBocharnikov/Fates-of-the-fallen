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

func _ready() -> void:
	CURRENT_HP = float(SaveLoadG.Player_Statistic["HP"])

func _physics_process(delta: float) -> void:
	if !is_alive:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_go_right", "ui_go_left", "ui_backward", "ui_forward")
	var direction := CAMERA.transform.basis * (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		go_to_obj = false
	elif is_on_floor() and !go_to_obj:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	elif $Player_nav.distance_to_target() < 2.0:
		go_to_obj = false
	
	#print(self.rotation.y)
	
	move_and_slide()
	look_at_mouse()
	go_to_interactible_obj()
	#print($Player_nav.distance_to_target())


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
			WEAPON.look_at(ray_result.collider.get_node_or_null("Area").global_position)
			#print(ray_result.collider.get_node_or_null("Area").global_position)
		else:
			WEAPON.look_at(ray_result.position)
		#WEAPON.rotation = WEAPON.rotation_degrees.clamp(Vector3(-25.0,0.0,0.0),Vector3(50.0,0.0,0.0))
		#print(WEAPON.rotation)
		#print(ray_result.collider.position)
		#self.rotation = self.rotation * Vector3(0,1,1)
		#print(ray_result.position)


func go_to_interactible_obj():
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_origin = CAMERA.project_ray_origin(mouse_pos)
	var ray_dir = ray_origin + CAMERA.project_ray_normal(mouse_pos) * 500
	
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin,ray_dir)
	
	ray_query.collide_with_bodies = true
	
	var space_state = get_world_3d().direct_space_state
	var ray_result = space_state.intersect_ray(ray_query)
	
	if Input.is_action_just_pressed("interact_btn"):
		go_to_obj = true
	
	if(!ray_result.is_empty() and go_to_obj):
		var hit_node = ray_result.collider.get_parent().get_node_or_null("Area") as Node3D
		#print(hit_node)
		if hit_node == null:return
		if hit_node.is_in_group("Interacteble"):
			$Player_nav.set_target_position(hit_node.global_position)
			velocity = global_position.direction_to($Player_nav.get_next_path_position()) * SPEED

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
