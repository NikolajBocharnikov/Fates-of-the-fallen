extends Node3D

@export var ORE_PREFAB:PackedScene
@export var MAX_AMOUNT:int

var root_node:Node3D
var curent_amount:int = 0
var stop_spawn:bool = false

func _ready() -> void:
	root_node = get_parent_node_3d()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	add_ore()

func add_ore():
	if stop_spawn:return
	
	curent_amount = get_tree().get_nodes_in_group("Interacteble").size()
	if curent_amount >= MAX_AMOUNT: stop_spawn = true
	
	var ore = ORE_PREFAB.instantiate()
	
	var rand_angle = randf_range(0,PI * 2)
	
	if root_node !=null:
		$RayCast3D.position = root_node.global_position + (Vector3.RIGHT * sin(rand_angle) + Vector3.FORWARD * cos(rand_angle)) * randf_range(5,100)
		#print ($RayCast3D.position)
	
	if $RayCast3D.is_colliding():
		add_child(ore)
		#print($RayCast3D.get_collision_point())
		ore.global_position = $RayCast3D.get_collision_point()
