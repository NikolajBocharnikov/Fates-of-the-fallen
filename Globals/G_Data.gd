extends Node

const save_path = "user://GodotSave/Fates_of_the_Fallen/"

var GAME_DATA = {
	"HP":5,
	"XP":0,
	"Level":1,
	"Atack Speed":1.0,
	"Atack":1,
	"Total Killed":0,
	"Coin":0,
	"Crystal":0,
	"Obsidian":0,
	"Ingot":0,
	"Health potion":0,
	"Stamina potion":0,
	"Profile Name":"default",
	"Resolution":Vector2i(1152,648),
	"3d_Scale":float(1.0),
	"Sound_Volume":float(0.0)
}

func save(Profie_Name:String):
	var file = FileAccess.open(Profie_Name,FileAccess.WRITE)
	file.store_var(GAME_DATA.duplicate())
	file.close()
	
func load_data(Profie_Name:String):
	if FileAccess.file_exists(save_path + Profie_Name):
		var file = FileAccess.open(save_path + Profie_Name,FileAccess.READ)
		var data = file.get_var()
		file.close()
		#print(data)
		var save_data = data.duplicate()
		GAME_DATA = save_data
		return 1
	else:
		print("No Save File found")
		return 0
