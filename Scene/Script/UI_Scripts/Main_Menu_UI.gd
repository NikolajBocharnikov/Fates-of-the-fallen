extends Node

@onready var loading_circle: TextureRect = $Control/Loading_panel/Loading_circle

var Scene_name = Global.GAME_SCENES
var is_loading:bool = false

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if is_loading:
		loading_circle.rotation_degrees -= 1

func _on_new_game_btn_pressed() -> void:
	$Control/AudioStreamPlayer.play()
	$Control/Loading_panel.visible = true
	is_loading = true
	await $Control/AudioStreamPlayer.finished
	var dir = DirAccess.open("user://")
	if !dir.dir_exists("user://GodotSave/Fates_of_the_Fallen"):
		#print("No")
		dir.make_dir_recursive("GodotSave/Fates_of_the_Fallen")
	
	Global.load_scene(self,"City")

func _on_exit_btn_pressed() -> void:
	$Control/AudioStreamPlayer.play()
	$Control/Loading_panel.visible = true
	is_loading = true
	await $Control/AudioStreamPlayer.finished
	get_tree().quit()


func _on_continue_btn_pressed() -> void:
	$Control/AudioStreamPlayer.play()
	$Control/Loading_panel.visible = true
	is_loading = true
	await $Control/AudioStreamPlayer.finished
	$FileDialog.visible = !$FileDialog.visible

@warning_ignore("unused_parameter")
func _on_file_dialog_file_selected(path: String) -> void:
	$Control/Loading_panel.visible = true
	if SaveLoadG.load_data($FileDialog.current_file) == 1:
		Global.load_scene(self,"City")
	#print($FileDialog.current_file)

func _on_file_dialog_canceled() -> void:
	$Control/Loading_panel.visible = false
