extends Control

@onready var player_ui: Control = $"."
@onready var health: Label = $Info_panel/Container/Health
@onready var level: Label = $Info_panel/Container/Level
@onready var atack_speed: Label = $Info_panel/Container/Atack_speed
@onready var kill_count: Label = $Info_panel/Container/Kill_Count

var CURRENT_HEALTH:float

var kill_count_var:int = 0
var screen_size
var panel_is_opened:bool = false
var lvl_up_btn_is_visible = false

func _ready() -> void:
	
	screen_size = $Info_panel.size
	
	SaveLoadG.connect("Kill_count_changed",enemy_is_killed)
	
	health.text = health.text + str(SaveLoadG.Player_Statistic["HP"])
	level.text = level.text + str(SaveLoadG.Player_Statistic["Level"])
	atack_speed.text = atack_speed.text + str(SaveLoadG.Player_Statistic["Atack Speed"])
	kill_count.text = kill_count.text + str(SaveLoadG.Player_Statistic["Total Killed"])
	kill_count_var = SaveLoadG.Player_Statistic["Total Killed"]
	
	hp_sp_init()

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_Exit"):
		$Info_panel/Container.visible = !$Info_panel/Container.visible
		$Info_panel/Menu.visible = !$Info_panel/Menu.visible
		if $Info_panel/Menu.visible: get_tree().paused = true
		else :get_tree().paused = false
	
	if Input.is_action_just_pressed("ui_TAB"):
		$Panel/Cards_Panel.visible = !$Panel/Cards_Panel.visible
		if $Panel/Cards_Panel.visible: get_tree().paused = true
		else: get_tree().paused = false

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	$Info_panel/XP_Bar/XP_Label.text = str(SaveLoadG.Player_Statistic["XP"]) + "/" + str(snappedf(pow(SaveLoadG.Player_Statistic["Level"],1.8) * 100,0.1))
	$Info_panel/XP_Bar.value = SaveLoadG.Player_Statistic["XP"]
	
	if $Panel/Cards_Panel.visible == false: $Info_panel.top_level = true
	else: $Info_panel.top_level = false
	
	if level_up() == 1:
		level.text = "Level: " + str(SaveLoadG.Player_Statistic["Level"])
		$Info_panel/XP_Bar.max_value = pow(SaveLoadG.Player_Statistic["Level"],1.8) * 100
		$Panel/level_up_btn.visible = true
		$Panel/Cards_Panel.LEVEL = SaveLoadG.Player_Statistic["Level"]
		#print($Panel/Cards_Panel.LEVEL)
		#print($Panel/Cards_Panel.CURRENT_LEVEL)
	
	var player = player_ui.get_parent()
	
	if player.HIT:
		#print(player.HIT)
		hp_sp_update()

func enemy_is_killed():
	#print("Yes")
	kill_count_var += 1
	kill_count.text = "Kill Count:" + str(kill_count_var)

func level_up():
	if SaveLoadG.Player_Statistic["XP"] > (snappedf(pow(SaveLoadG.Player_Statistic["Level"],1.8) * 100,0.1)):
		SaveLoadG.Player_Statistic["XP"] = 0
		SaveLoadG.Player_Statistic["Level"] += 1
		return 1
	return 0

func hp_sp_init():
	CURRENT_HEALTH = float(SaveLoadG.Player_Statistic["HP"])
	$Info_panel/Health_Panel.material.set("shader_parameter/height",CURRENT_HEALTH/CURRENT_HEALTH)
	$Info_panel/Stamina_Panel.material.set("shader_parameter/height",1.0)

func hp_sp_update():
	var player = player_ui.get_parent()
	player.HIT = false
	CURRENT_HEALTH = player.CURRENT_HP / float(SaveLoadG.Player_Statistic["HP"]) 
	#print(CURRENT_HEALTH)
	if player.CURRENT_HP > 0:
		$Info_panel/Health_Panel.material.set("shader_parameter/height",CURRENT_HEALTH)
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

func _on_save_btn_pressed() -> void:
	$FileDialog.visible = !$FileDialog.visible

func _on_exit_btn_pressed() -> void:
	get_tree().quit()

func _on_file_dialog_file_selected(path: String) -> void:
	SaveLoadG.save(path)
	#print(path)

func _on_level_up_btn_pressed() -> void:
	get_tree().paused = !get_tree().paused
	$Panel/Cards_Panel.visible = true


func _on_close_btn_pressed() -> void:
	get_tree().paused = !get_tree().paused
	$Panel/Cards_Panel.visible = false


func _on_hp_card_btn_pressed() -> void:
	var player = player_ui.get_parent()
	player.HIT = false
	await get_tree().create_timer(0.1).timeout
	CURRENT_HEALTH = player.CURRENT_HP / float(SaveLoadG.Player_Statistic["HP"])
	if player.CURRENT_HP > 0:
		$Info_panel/Health_Panel.material.set("shader_parameter/height",CURRENT_HEALTH) 
