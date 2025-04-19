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
	if get_window().has_node("Main_menu"):
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), GData.GAME_DATA["Sound_Volume"])
		get_window().set_size(GData.GAME_DATA["Resolution"])
		get_window().set_content_scale_size(GData.GAME_DATA["Resolution"])
		get_window().move_to_center()
		get_viewport().scaling_3d_scale = GData.GAME_DATA["3d_Scale"]
	
	$Music_Volume/M_Slider.value = GData.GAME_DATA["Sound_Volume"]
	
	var selected_res:int = 0
	for i in Availible_Resolution:
		if Availible_Resolution[i] == GData.GAME_DATA["Resolution"]:
			$Res_MenuButton.select(selected_res)
			#print(selected)
		selected_res += 1
	
	var selected_scale:int = 0
	for i in Availible_Scale:
		if Availible_Scale[i] == GData.GAME_DATA["3d_Scale"]:
			$Scale_OptionButton.select(selected_scale)
		selected_scale += 1

func _on_m_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)
	GData.GAME_DATA["Sound_Volume"] = value
	#print(value)

func _on_res_menu_button_item_selected(index: int) -> void:
	match index:
		0:
			get_window().set_size(Availible_Resolution["648P"])
			get_window().set_content_scale_size(Availible_Resolution["648P"])
			get_window().move_to_center()
			GData.GAME_DATA["Resolution"] = Availible_Resolution["648P"]
		1:
			get_window().set_size(Availible_Resolution["HD"])
			get_window().set_content_scale_size(Availible_Resolution["HD"])
			get_window().move_to_center()
			GData.GAME_DATA["Resolution"] = Availible_Resolution["HD"]
		2:
			get_window().set_size(Availible_Resolution["SHD"])
			get_window().set_content_scale_size(Availible_Resolution["SHD"])
			get_window().move_to_center()
			GData.GAME_DATA["Resolution"] = Availible_Resolution["SHD"]
		3:
			get_window().set_size(Availible_Resolution["FullHD"])
			get_window().set_content_scale_size(Availible_Resolution["FullHD"])
			get_window().move_to_center()
			GData.GAME_DATA["Resolution"] = Availible_Resolution["FullHD"]

func _on_scale_option_button_item_selected(index: int) -> void:
	match index:
		0:
			get_viewport().scaling_3d_scale = Availible_Scale["Full"]
			GData.GAME_DATA["3d_Scale"] = Availible_Scale["Full"]
		1:
			get_viewport().scaling_3d_scale = Availible_Scale["Half"]
			GData.GAME_DATA["3d_Scale"] = Availible_Scale["Half"]
