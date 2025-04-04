extends Node

const GAME_SCENES := {
	"Main": "res://Scene/main.tscn",
	"City": "res://Scene/city_preview.tscn"
}

func load_scene(current_scene:Variant,next_scene:Variant) -> void:
	var new_scene = load(GAME_SCENES[next_scene]).instantiate()
	get_parent().add_child(new_scene)
	current_scene.queue_free()
