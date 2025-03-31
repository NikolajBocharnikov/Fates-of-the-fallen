extends Control

var camera:Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_tree().get_first_node_in_group("Camera")


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	position = camera.unproject_position(get_parent().global_position)
