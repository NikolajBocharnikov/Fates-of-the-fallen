extends Node

var is_loading:bool = false
var new_scene
var this_scene

const GAME_SCENES := {
	"Main": "res://Scene/main.tscn",
	"City": "res://Scene/city_preview.tscn"
}

func load_scene(current_scene:Variant,next_scene:Variant) -> void:
	new_scene = GAME_SCENES[next_scene]
	this_scene = current_scene
	ResourceLoader.load_threaded_request(new_scene)
	is_loading = true
	#get_parent().add_child(new_scene)
	#current_scene.queue_free()

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if !is_loading:
		return
	
	if ResourceLoader.load_threaded_get_status(new_scene) == ResourceLoader.THREAD_LOAD_LOADED:
		var map = ResourceLoader.load_threaded_get(new_scene).instantiate()
		await get_tree().create_timer(1.0).timeout
		get_parent().add_child(map)
		this_scene.queue_free()
		is_loading = false
