extends Node3D

@export var BULLET_PREFAB:PackedScene
@export var PLAYER_NODE:Node3D
@export var SHOOT_POS:Node3D
@export var SHOOT_RATE:float

var root_node:Node3D 
var shoot_timer:float

func _ready() -> void:
	SHOOT_RATE = SaveLoadG.Player_Statistic["Atack Speed"]
	if PLAYER_NODE.get_parent_node_3d() != null:
		root_node = PLAYER_NODE.get_parent_node_3d()
	#print(root_node)

func _physics_process(delta: float) -> void:
	if shoot_timer < (SHOOT_RATE/10):
		shoot_timer += delta
	
	if Input.is_action_pressed("ui_shoot") and shoot_timer >= (SHOOT_RATE/10):
		
		shoot_timer = 0
		
		var bullet = BULLET_PREFAB.instantiate()
		root_node.add_child(bullet)
		bullet.position = SHOOT_POS.global_position
		
		bullet.bullet_dir = -get_global_transform().basis.z
		
