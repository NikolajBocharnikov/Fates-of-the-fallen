extends Control

@onready var player_ui: Control = $"."
@onready var health: Label = $Info_panel/Container/Health
@onready var level: Label = $Info_panel/Container/Level
@onready var atack_speed: Label = $Info_panel/Container/Atack_speed
@onready var kill_count: Label = $Info_panel/Container/Kill_Count

#var CURRENT_HEALTH:float
var PLAYER:Node3D

var screen_size:Vector2
var panel_is_opened:bool = false
var lvl_up_btn_is_visible = false

func _ready() -> void:
	screen_size = $Info_panel.size
	PLAYER = player_ui.get_parent()
	
	update_text()
	update_hp_sp()

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_TAB") or Input.is_action_just_pressed("ui_Exit"):
		$Info_panel/Container.visible = !$Info_panel/Container.visible
		$Panel/Cards_Panel.visible = !$Panel/Cards_Panel.visible
		if $Panel/Cards_Panel.visible: get_tree().paused = true
		else: get_tree().paused = false

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	$Info_panel/XP_Bar/XP_Label.text = str(GData.GAME_DATA["XP"]) + "/" + str(snappedf(pow(GData.GAME_DATA["Level"],1.8) * 100,0.1))
	$Info_panel/XP_Bar.value = GData.GAME_DATA["XP"]
	
	if $Panel/Cards_Panel.visible == false: $Info_panel.top_level = true
	else: $Info_panel.top_level = false
	
	update_btn_property()
	update_text()
	on_level_up()
	update_hp_sp()

func update_btn_property():
	if $Panel/Cards_Panel.visible:
		$Info_panel/Item_Panel/Btn_Container/Heal_me_btn.disabled = true
		$Info_panel/Item_Panel/Btn_Container/Stamina_me_btn.disabled = true
		$Info_panel/Ability_Panel/Btn_Container/Dash_btn.disabled = true
		$Info_panel/Ability_Panel/Btn_Container/Blast_btn.disabled = true
	else:
		$Info_panel/Item_Panel/Btn_Container/Heal_me_btn.disabled = false
		$Info_panel/Item_Panel/Btn_Container/Stamina_me_btn.disabled = false
		$Info_panel/Ability_Panel/Btn_Container/Dash_btn.disabled = false
		$Info_panel/Ability_Panel/Btn_Container/Blast_btn.disabled = false

func update_text():
	health.text = "Health:" + str(GData.GAME_DATA["HP"])
	level.text = "Level:" + str(GData.GAME_DATA["Level"])
	atack_speed.text = "Attack Speed:" + str(GData.GAME_DATA["Atack Speed"])
	kill_count.text = "Kill Count:" + str(GData.GAME_DATA["Total Killed"])

func on_level_up():
	if GData.GAME_DATA["XP"] > (snappedf(pow(GData.GAME_DATA["Level"],1.8) * 100,0.1)):
		GData.GAME_DATA["XP"] = 0
		GData.GAME_DATA["Level"] += 1
		$Info_panel/XP_Bar.max_value = pow(GData.GAME_DATA["Level"],1.8) * 100
		$Panel/Lvl_up_lbl.visible = true
		$Panel/Cards_Panel.LEVEL = GData.GAME_DATA["Level"]
		#print($Panel/Cards_Panel.LEVEL)
		#print($Panel/Cards_Panel.CURRENT_LEVEL)

func update_hp_sp():
	#CURRENT_HEALTH = PLAYER.CURRENT_HP / float(GData.GAME_DATA["HP"])
	#print(CURRENT_HEALTH)
	if PLAYER.CURRENT_HP > 0:
		$Info_panel/Health_Panel.material.set("shader_parameter/height",PLAYER.CURRENT_HP / float(GData.GAME_DATA["HP"]))
	else:
		$Info_panel/Health_Panel.material.set("shader_parameter/height",0.0)

func _on_container_resized() -> void:
	
	var con_scale
	#print(screen_size)
	
	if screen_size == null:
		return
	
	if screen_size != $Info_panel.size:
		#print($Info_panel.size)
		if screen_size < $Info_panel.size:
			con_scale = $Info_panel.size / screen_size
			$Info_panel/Container.scale = con_scale
		else:
			con_scale = $Info_panel.size / screen_size
			$Info_panel/Container.scale = clamp(con_scale,Vector2(1.0,1.0),Vector2(1.0,1.0))
		
		screen_size = $Info_panel.size

func _on_close_btn_pressed() -> void:
	get_tree().paused = !get_tree().paused
	$Panel/Cards_Panel.visible = false

func _on_hp_card_btn_pressed() -> void:
	PLAYER.HIT = false
	await get_tree().create_timer(0.1).timeout
	#CURRENT_HEALTH = PLAYER.CURRENT_HP / float(GData.GAME_DATA["HP"])
	if PLAYER.CURRENT_HP > 0:
		$Info_panel/Health_Panel.material.set("shader_parameter/height",PLAYER.CURRENT_HP / float(GData.GAME_DATA["HP"])) 

func _on_dash_btn_pressed() -> void:
	PLAYER.dash = true
