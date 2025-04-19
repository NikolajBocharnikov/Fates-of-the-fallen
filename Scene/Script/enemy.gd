extends CharacterBody3D

@export var MOVE_SPEED:float
@export var HEALTH:int
@export var LEVEL:int #Used in different script

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D as NavigationAgent3D
@onready var health_bar: TextureProgressBar = $UI/Health_Bar

var xp_scene:PackedScene = preload("res://Scene/Prefab/xp_orb.tscn")

var player:Node3D = null
var current_health:int = 0
var snaped_to_ground:bool = false

#USED in LimboAI Enemy BT
var patruling:bool = false
var finished_patrole:bool = false
var see_player:bool = false
var in_akt_range:bool = false

func  _ready() -> void:
	current_health = HEALTH
	health_bar.max_value = HEALTH

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if current_health <= 0 : #Death of enemy
		GData.GAME_DATA["Total Killed"] += 1
		var scene = xp_scene.instantiate() #XP_Scene
		add_child(scene)
		queue_free()
	
	if $RayCast3D.is_colliding() and !snaped_to_ground:
		global_position = $RayCast3D.get_collision_point()
		snaped_to_ground = true
	
	move_and_slide()

func patrole(dir:Vector3):
	#print(navigation_agent.is_navigation_finished())
	if navigation_agent.is_navigation_finished():
		patruling = false
		finished_patrole = true
	
	if player == null or self.global_position.distance_to(player.global_position) > 10:
		player = get_tree().get_first_node_in_group("Player_node")
		
		if patruling == false:
			navigation_agent.set_target_position(dir)
		#print(pos_point)
		
		patruling = true
		velocity = self.global_position.direction_to(navigation_agent.get_next_path_position()) * MOVE_SPEED

func move_to_player():
	if !player == null:
		if self.global_position.distance_to(player.global_position) < 10:
			navigation_agent.set_target_position(player.global_position)
			velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * MOVE_SPEED
			#print(self.global_position.distance_to(player.global_position))
		if self.global_position.distance_to(player.global_position) < 2:
			in_akt_range = true
			#print("In ATK Range")
		else:in_akt_range = false

func jump_ATK(vel:Vector3):
	var rand_wait = randf_range(0.3,0.8)
	await get_tree().create_timer(rand_wait).timeout
	velocity = vel * 5 + Vector3.UP
	await get_tree().create_timer(0.4).timeout
	velocity = Vector3.ZERO

func _on_area_area_entered(area: Area3D) -> void:
	var player_attack = GData.GAME_DATA["Atack"]
	#print("yes")
	if area.is_in_group("Bullet") and area.visible:
		var weapon_damage:int = 0
		if area.get_parent().damage != null: weapon_damage = area.get_parent().damage
		current_health -= player_attack + weapon_damage
		health_bar.value = current_health
		#print(current_health)

func _on_visible_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player_node"):
		player = body
		see_player = true

func _on_visible_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player_node"):
		player = body
		see_player = false
