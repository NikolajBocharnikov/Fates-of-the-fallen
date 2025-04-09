extends GridContainer

var Availible_Resolution = {
	"648P":Vector2i(1152,648),
	"HD":Vector2i(1280,720),
	"SHD":Vector2i(1600,900),
	"FullHD":Vector2i(1980,1080)
}

var Availible_Scale = {
	"Full":float(1.0),
	"Half":float(0.5)
}

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	init_saved_settings()

func init_saved_settings():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), SaveLoadG.Player_Statistic["Sound_Volume"])
	get_window().set_size(SaveLoadG.Player_Statistic["Resolution"])
	get_window().set_content_scale_size(SaveLoadG.Player_Statistic["Resolution"])
	get_viewport().scaling_3d_scale = SaveLoadG.Player_Statistic["3d_Scale"]
	

func _on_m_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	SaveLoadG.Player_Statistic["Sound_Volume"] = value
	#print(value)

func _on_res_menu_button_item_selected(index: int) -> void:
	match index:
		0:
			get_window().set_size(Availible_Resolution["648P"])
			get_window().set_content_scale_size(Availible_Resolution["648P"])
			SaveLoadG.Player_Statistic["Resolution"] = Availible_Resolution["648P"]
		1:
			get_window().set_size(Availible_Resolution["HD"])
			get_window().set_content_scale_size(Availible_Resolution["HD"])
			SaveLoadG.Player_Statistic["Resolution"] = Availible_Resolution["HD"]
		2:
			get_window().set_size(Availible_Resolution["SHD"])
			get_window().set_content_scale_size(Availible_Resolution["SHD"])
			SaveLoadG.Player_Statistic["Resolution"] = Availible_Resolution["SHD"]
		3:
			get_window().set_size(Availible_Resolution["FullHD"])
			get_window().set_content_scale_size(Availible_Resolution["FullHD"])
			SaveLoadG.Player_Statistic["Resolution"] = Availible_Resolution["FullHD"]

func _on_scale_option_button_item_selected(index: int) -> void:
	match index:
		0:
			get_viewport().scaling_3d_scale = Availible_Scale["Full"]
			SaveLoadG.Player_Statistic["3d_Scale"] = Availible_Scale["Full"]
		1:
			get_viewport().scaling_3d_scale = Availible_Scale["Half"]
			SaveLoadG.Player_Statistic["3d_Scale"] = Availible_Scale["Half"]
