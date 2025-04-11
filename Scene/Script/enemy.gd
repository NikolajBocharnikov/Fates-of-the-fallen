extends CharacterBody3D

@export var MOVE_SPEED:float
@export var HEALTH:int
@export var LEVEL:int

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D as NavigationAgent3D
@onready var health_bar: TextureProgressBar = $UI/Health_Bar

var xp_scene:PackedScene = preload("res://Scene/Prefab/xp_orb.tscn")

var player:Node3D
var player_attack:int
var current_health:int

func  _ready() -> void:
	current_health = HEALTH
	health_bar.max_value = HEALTH

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	
	player_attack = SaveLoadG.Player_Statistic["Atack"]
	
	if current_health <= 0 : #Death of enemy
		SaveLoadG.Player_Statistic["Total Killed"] += 1
		var scene = xp_scene.instantiate() #XP_Scene
		add_child(scene)
		queue_free()
	
	if player == null:
		player = get_tree().get_first_node_in_group("Player_node")
	else:
		navigation_agent.set_target_position(player.global_position)
		velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * MOVE_SPEED
		move_and_slide()

func _on_area_area_entered(area: Area3D) -> void:
	#print("yes")
	if area.is_in_group("Bullet") and area.visible:
		var weapon_damage:int = 0
		if area.get_parent().damage != null: weapon_damage = area.get_parent().damage
		current_health -= player_attack + weapon_damage
		health_bar.value = current_health
		#print(current_health)
