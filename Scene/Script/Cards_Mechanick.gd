extends Panel

var CURRENT_LEVEL:int
var CARD_TYPE:String = " "

var level_is_up:bool = false

func _ready() -> void:
	CURRENT_LEVEL = SaveLoadG.Player_Statistic["Level"]

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if CURRENT_LEVEL != SaveLoadG.Player_Statistic["Level"]:
		level_is_up = true
		CURRENT_LEVEL = SaveLoadG.Player_Statistic["Level"]
		$Level_Panel.visible = !$Level_Panel.visible
	
	if level_is_up :
		if Input.is_action_just_pressed("ui_shoot") and CARD_TYPE != " ":
			if CARD_TYPE == "ATK":
				SaveLoadG.Player_Statistic["Atack"] += 1
			if CARD_TYPE == "HP":
				SaveLoadG.Player_Statistic["HP"] += 1
			if CARD_TYPE == "SP":
				SaveLoadG.Player_Statistic["Atack Speed"] += 0.1
			level_is_up = false
			$Level_Panel.visible = !$Level_Panel.visible

func _on_attack_card_mouse_entered() -> void:
	CARD_TYPE = "ATK"

func _on_health_card_mouse_entered() -> void:
	CARD_TYPE = "HP"

func _on_atk_speed_card_mouse_entered() -> void:
	CARD_TYPE = "SP"
