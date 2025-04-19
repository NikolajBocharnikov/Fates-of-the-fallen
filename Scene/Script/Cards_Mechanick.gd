extends Panel

var CURRENT_LEVEL:int
var LEVEL:int
var CARD_TYPE:String = " "

var player:Node3D = null

var level_is_up:bool = false

func _ready() -> void:
	CURRENT_LEVEL = GData.GAME_DATA["Level"]
	LEVEL = CURRENT_LEVEL
	player = $"../..".get_parent()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if CURRENT_LEVEL != LEVEL:
		#print(CURRENT_LEVEL)
		#print(LEVEL)
		level_is_up = true
	
	if level_is_up :
		$Card_container/HP_Card_btn.disabled = false
		$Card_container/ATK_Card_btn.disabled = false
		$Card_container/ATK_Speed_Card_btn.disabled = false
		
		if CARD_TYPE != " ":
			if CARD_TYPE == "ATK":
				GData.GAME_DATA["Atack"] += 1
				CURRENT_LEVEL += 1
				CARD_TYPE = " "
			if CARD_TYPE == "HP":
				GData.GAME_DATA["HP"] += 1
				CURRENT_LEVEL += 1
				player.CURRENT_HP += 1.0
				CARD_TYPE = " "
			if CARD_TYPE == "SP":
				GData.GAME_DATA["Atack Speed"] += 0.1
				CURRENT_LEVEL += 1
				CARD_TYPE = " "
			
			$Card_container/HP_Card_btn.disabled = true
			$Card_container/ATK_Card_btn.disabled = true
			$Card_container/ATK_Speed_Card_btn.disabled = true
			level_is_up = false
	
	if $Card_container/HP_Card_btn.disabled == true:$"../Lvl_up_lbl".visible = false
	
	if player.get_parent().is_in_group("City"):$HUB_btn.disabled = true
	else:$HUB_btn.disabled = false

func _on_atk_card_btn_pressed() -> void:
	CARD_TYPE = "ATK"

func _on_hp_card_btn_pressed() -> void:
	CARD_TYPE = "HP"

func _on_atk_speed_card_btn_pressed() -> void:
	CARD_TYPE = "SP"

func _on_hub_btn_pressed() -> void:
	get_tree().paused = false
	$".".visible = false
	$"../../Loading_panel".visible = true
	player.get_parent().get_node("Enemy_spawner").process_mode = Node.PROCESS_MODE_DISABLED
	Global.load_scene(player.get_parent(),"City")

func _on_save_btn_pressed() -> void:
	$"../../FileDialog".visible = !$"../../FileDialog".visible

func _on_exit_btn_pressed() -> void:
	get_tree().quit()

func _on_file_dialog_file_selected(path: String) -> void:
	GData.save(path)
	#print(path)
