extends CharacterBody3D

@export var MOVE_SPEED:float
@export var HEALTH:int

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D as NavigationAgent3D
@onready var health_bar: TextureProgressBar = $UI/Health_Bar

var player:Node3D
var current_health:int

func  _ready() -> void:
	current_health = HEALTH
	health_bar.max_value = HEALTH

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if current_health <= 0 :
		queue_free()
	
	if player == null:
		player = get_tree().get_first_node_in_group("Player_node")
	else:
		navigation_agent.set_target_position(player.global_position)
		velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * MOVE_SPEED
		move_and_slide()

func _on_area_area_entered(area: Area3D) -> void:
	#print("yes")
	if area.is_in_group("Bullet"):
		current_health -= 1
		health_bar.value = current_health
		#print(current_health)
