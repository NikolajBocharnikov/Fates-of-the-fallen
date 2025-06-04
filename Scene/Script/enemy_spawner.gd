extends Node3D

@export var ENEMY_PREFAB:Array[PackedScene]
@export_category("Constants")
@export var MAX_ENEMIS_ON_SCREEN:int
@export var MAX_ENEMY_WAVES:int
@export_category("Rates")
@export var TIMER:Timer
@export var WAVE_LENGHT:float = 20.0
@export var SPAWN_RATE:float = 5.0
@export_category("Spawn Type")
@export_enum("Random","Point") var SPAWNER_TYPE:String

var root_node:Node3D
var curent_num_of_enemis:int = 0
var spawn_timer: float = 0.0
var current_wave:int = 0

func _ready() -> void:
	root_node = get_parent_node_3d()
	spawn_timer = SPAWN_RATE

func _physics_process(delta: float) -> void:
	if spawn_timer < SPAWN_RATE:
		spawn_timer += delta
	
	curent_num_of_enemis = get_tree().get_nodes_in_group("Enemy").size()
	
	if curent_num_of_enemis >= MAX_ENEMIS_ON_SCREEN:
		return
	#print(get_tree().get_nodes_in_group("Enemy").size())
	
	if spawn_timer >= SPAWN_RATE:
		spawn_timer = 0
		if ENEMY_PREFAB[current_wave] == null: current_wave -= 1
		var enemy = ENEMY_PREFAB[current_wave].instantiate()
		var rand_angle = randf_range(0,PI * 2)
		if root_node != null:
			match SPAWNER_TYPE:
				"Random":
					var offset:Vector3 = (Vector3.RIGHT * sin(rand_angle) + Vector3.FORWARD * cos(rand_angle)) * 20
					enemy.position = root_node.global_position + offset
					#print("Random")
				"Point":
					var offset:Vector3 = (Vector3.RIGHT * sin(rand_angle) + Vector3.FORWARD * cos(rand_angle)) * 2
					enemy.position = root_node.get_node("Enemy_Spawn_Point").global_position + offset
					#print("Point")
			add_child(enemy)
	
	enemy_wave(MAX_ENEMY_WAVES)

func enemy_wave(num_of_wave:int):
	if TIMER.is_stopped():
		if self.get_child_count() > 0:
			for i in self.get_child_count():
				if self.get_child(i) is CharacterBody3D:
					self.get_child(i).current_health = 0
		
		if current_wave <= (num_of_wave - 1) and (ENEMY_PREFAB.size() - 1) > current_wave:
			current_wave += 1
		TIMER.start(WAVE_LENGHT)
		#print(current_wave)
