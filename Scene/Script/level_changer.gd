extends Node3D

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if Global.is_loading:
		if ResourceLoader.load_threaded_get_status(Global.new_scene) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				$Loading_Panel.visible = true
				$Loading_Panel/HBoxContainer/ProgressBar.value = lerpf($Loading_Panel/HBoxContainer/ProgressBar.value,99,1)
		if ResourceLoader.load_threaded_get_status(Global.new_scene) == ResourceLoader.THREAD_LOAD_LOADED:
			if $Loading_Panel != null: $Loading_Panel/HBoxContainer/ProgressBar.value = 100

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player_node"):
		Global.load_scene($"..","Main")
