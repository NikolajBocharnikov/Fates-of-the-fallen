extends Node3D

var ENEMY:Node3D
var XP_Drop:float

func _ready() -> void:
	ENEMY = get_parent()
	XP_Drop = ENEMY.LEVEL
	self.reparent(ENEMY.get_parent())
	#print(1 * snappedf(pow(XP_Drop,1.8),0.1))

func _on_pick_up_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player_node"):
		#print("Picked")
		GData.GAME_DATA["XP"] += (1 * snappedf(pow(XP_Drop,1.8),0.1))
		queue_free()
