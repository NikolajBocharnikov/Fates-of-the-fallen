extends Node3D

@export var BULLET_SPEED:float 

var bullet_dir:Vector3
var damage:int = 0

func _ready() -> void:
	$Timer.connect("timeout",queue_free)
	$Timer.start()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	position += bullet_dir * BULLET_SPEED
