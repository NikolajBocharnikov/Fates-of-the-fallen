extends Node

const save_path = "user://GodotSave/Fates_of_the_Fallen/"

signal Kill_count_changed

var Player_Statistic = {
	"HP":5,
	"XP":0,
	"Level":1,
	"Atack Speed":1.0,
	"Atack":1,
	"Total Killed":0,
	"Profile Name":"default"
}

var kill_count:int = 0

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if Player_Statistic["Total Killed"] != kill_count:
		emit_signal("Kill_count_changed")
		kill_count += 1


func save(Profie_Name:String):
	var file = FileAccess.open(Profie_Name,FileAccess.WRITE)
	file.store_var(Player_Statistic.duplicate())
	file.close()
	
func load_data(Profie_Name:String):
	if FileAccess.file_exists(save_path + Profie_Name):
		var file = FileAccess.open(save_path + Profie_Name,FileAccess.READ)
		var data = file.get_var()
		file.close()
		#print(data)
		var save_data = data.duplicate()
		Player_Statistic = save_data
		kill_count = save_data["Total Killed"]
		return 1
	else:
		print("No Save File found")
		return 0
