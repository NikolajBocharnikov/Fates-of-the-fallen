extends Panel

var CURRENT_LEVEL:int
var LEVEL:int
var CARD_TYPE:String = " "

var player:Node3D = null

var level_is_up:bool = false

func _ready() -> void:
	CURRENT_LEVEL = SaveLoadG.Player_Statistic["Level"]
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
				SaveLoadG.Player_Statistic["Atack"] += 1
				CURRENT_LEVEL += 1
				CARD_TYPE = " "
			if CARD_TYPE == "HP":
				SaveLoadG.Player_Statistic["HP"] += 1
				CURRENT_LEVEL += 1
				player.CURRENT_HP += 1.0
				CARD_TYPE = " "
			if CARD_TYPE == "SP":
				SaveLoadG.Player_Statistic["Atack Speed"] += 0.1
				CURRENT_LEVEL += 1
				CARD_TYPE = " "
			
			$Card_container/HP_Card_btn.disabled = true
			$Card_container/ATK_Card_btn.disabled = true
			$Card_container/ATK_Speed_Card_btn.disabled = true
			level_is_up = false
	
	if $Card_container/HP_Card_btn.disabled == true:$"../level_up_btn".visible = false

func _on_atk_card_btn_pressed() -> void:
	CARD_TYPE = "ATK"

func _on_hp_card_btn_pressed() -> void:
	CARD_TYPE = "HP"

func _on_atk_speed_card_btn_pressed() -> void:
	CARD_TYPE = "SP"
