extends SpringArm3D

@export var PLAYER:Node3D

var Camera_pos_y:float = 2.5

func _ready() -> void:
	position = PLAYER.position
	position.y = Camera_pos_y

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	position = PLAYER.position + (Vector3.UP * Camera_pos_y)
	#is_player_visible()

func is_player_visible(): #Use spring arm
	var player_pos = PLAYER.global_position
	var ray_origin = global_position
	
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin,player_pos)
	
	ray_query.collide_with_bodies = true
	
	var space_state = get_world_3d().direct_space_state
	var ray_result = space_state.intersect_ray(ray_query)
	
	if(!ray_result.is_empty()):
		print(ray_result)
