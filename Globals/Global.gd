extends Node

var is_loading:bool = false
var new_scene
var this_scene

const GAME_SCENES := {
	"Main": "res://Scene/main.tscn",
	"City": "res://Scene/city_preview.tscn",
	"New_City":"res://Scene/Locations/city_block_out.tscn",
	"Clay_Hills":"res://Scene/Locations/Clay_Hills.tscn",
	"Level_2":"res://Scene/Locations/Level_2.tscn",
	"Level_3":"res://Scene/Locations/Level_3.tscn",
	"Level_4":"res://Scene/Locations/Level_4.tscn",
	"Level_5":"res://Scene/Locations/Level_5.tscn",
	"Level_6":"res://Scene/Locations/Level_6.tscn",
	"Level_7":"res://Scene/Locations/Level_7.tscn",
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
