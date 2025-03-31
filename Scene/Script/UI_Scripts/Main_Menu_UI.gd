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
	Global.load_scene(self,"Main")


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
