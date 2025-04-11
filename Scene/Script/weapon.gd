extends Node3D

@export var BULLET_PREFAB:PackedScene
@export var PLAYER_NODE:Node3D
@export var SHOOT_POS:Node3D
@export var SHOOT_RATE:float

var WEAPON_TYPE:PackedStringArray = ["Scepters","Swords"]

var root_node:Node3D 
var shoot_timer:float

func _ready() -> void:
	SHOOT_RATE = SaveLoadG.Player_Statistic["Atack Speed"]
	if PLAYER_NODE.get_parent_node_3d() != null:
		root_node = PLAYER_NODE.get_parent_node_3d()

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_switch_weapon"): switch_weapon()

func _physics_process(delta: float) -> void:
	if shoot_timer < (SHOOT_RATE/10):
		shoot_timer += delta
	
	#print(get_node(WEAPON_TYPE[0]).visible)
	
	if Input.is_action_pressed("ui_shoot") and shoot_timer >= (SHOOT_RATE/10):
		if get_node(WEAPON_TYPE[0]).visible:
			fire_bullet()
		if get_node(WEAPON_TYPE[1]).visible:
			melee_atk()

func fire_bullet():
		shoot_timer = 0
		
		var bullet = BULLET_PREFAB.instantiate()
		root_node.add_child(bullet)
		bullet.position = SHOOT_POS.global_position
		
		bullet.bullet_dir = -get_global_transform().basis.z
		$"../Sound".play_attack_sound()

func melee_atk():
	shoot_timer = 0
	$Swords.get_node("AnimationPlayer").play("Sword_ATK")

func switch_weapon():
	get_node(WEAPON_TYPE[0]).visible = !get_node(WEAPON_TYPE[0]).visible
	get_node(WEAPON_TYPE[1]).visible = !get_node(WEAPON_TYPE[1]).visible
