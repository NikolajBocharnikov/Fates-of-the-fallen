extends Node3D

@export var ENEMY_PREFAB:PackedScene
@export var MAX_ENEMIS_ON_SCREEN:int
@export var SPANW_RATE:float

var root_node:Node3D
var curent_num_of_enemis:int = 0
var spawn_timer: float = 0.0

func _ready() -> void:
	root_node = get_parent_node_3d()
	spawn_timer = SPANW_RATE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if spawn_timer < SPANW_RATE:
		spawn_timer += delta
	
	curent_num_of_enemis = get_tree().get_nodes_in_group("Enemy").size()
	
	if curent_num_of_enemis >= MAX_ENEMIS_ON_SCREEN:
		return
	#print(get_tree().get_nodes_in_group("Enemy").size())
	
	if spawn_timer >= SPANW_RATE:
		spawn_timer = 0
		var enemy = ENEMY_PREFAB.instantiate()
		var rand_angle = randf_range(0,PI * 2)
		if root_node !=null:
			enemy.position = root_node.global_position + (Vector3.RIGHT * sin(rand_angle) + Vector3.FORWARD * cos(rand_angle)) * 20
			add_child(enemy)
