extends Control

@onready var player_ui: Control = $"."
@onready var health: Label = $Info_panel/Container/Health
@onready var level: Label = $Info_panel/Container/Level
@onready var atack_speed: Label = $Info_panel/Container/Atack_speed
@onready var kill_count: Label = $Info_panel/Container/Kill_Count

var kill_count_var:int = 0
var screen_size
var panel_is_opened:bool = false

func _ready() -> void:
	
	screen_size = $Info_panel.size
	
	SaveLoadG.connect("Kill_count_changed",enemy_is_killed)
	
	health.text = health.text + str(SaveLoadG.Player_Statistic["HP"])
	level.text = level.text + str(SaveLoadG.Player_Statistic["Level"])
	atack_speed.text = atack_speed.text + str(SaveLoadG.Player_Statistic["Atack Speed"])
	kill_count.text = kill_count.text + str(SaveLoadG.Player_Statistic["Total Killed"])
	kill_count_var = SaveLoadG.Player_Statistic["Total Killed"]

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_Exit"):
		$Info_panel/Menu.visible = !$Info_panel/Menu.visible
		$Info_panel/Container.visible = !$Info_panel/Container.visible
		get_tree().paused = !get_tree().paused
	
	if Input.is_action_just_pressed("ui_TAB"):
		if $Panel.position.y > -$Panel/level_up_btn.size.y:
			$Panel.position.y -= ($Panel.size.y + $Panel/level_up_btn.size.y)
			panel_is_opened = true
		else:
			$Panel.position.y += ($Panel.size.y + $Panel/level_up_btn.size.y)
			panel_is_opened = false

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	$Info_panel/XP_Bar/XP_Label.text = str(SaveLoadG.Player_Statistic["XP"]) + "/" + str(pow(SaveLoadG.Player_Statistic["Level"],1.8) * 100)
	$Info_panel/XP_Bar.value = SaveLoadG.Player_Statistic["XP"]
	
	if level_up() == 1:
		level.text = "Level: " + str(SaveLoadG.Player_Statistic["Level"])
		$Info_panel/XP_Bar.max_value = pow(SaveLoadG.Player_Statistic["Level"],1.8) * 100
		$Panel.position.y -= $Panel/level_up_btn.size.y
	

func enemy_is_killed():
	#print("Yes")
	kill_count_var += 1
	kill_count.text = "Kill Count:" + str(kill_count_var)

func level_up():
	if SaveLoadG.Player_Statistic["XP"] > (pow(SaveLoadG.Player_Statistic["Level"],1.8) * 100):
		SaveLoadG.Player_Statistic["XP"] = 0
		SaveLoadG.Player_Statistic["Level"] += 1
		return 1
	return 0

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
	pass # Replace with function body.


func _on_close_btn_pressed() -> void:
	pass # Replace with function body.


func _on_panel_resized() -> void:
	if panel_is_opened:
		$Panel.position.y = $Panel/level_up_btn.position.y - $Panel/level_up_btn.size.y
