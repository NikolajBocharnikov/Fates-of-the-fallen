extends SpringArm3D

@export var PLAYER:Node3D

var Camera_pos_y:float = 2.5

func _ready() -> void:
	position = PLAYER.position
	position.y = Camera_pos_y

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	position = PLAYER.position + (Vector3.UP * Camera_pos_y)
