extends Node3D

@onready var steps_grass: AudioStreamPlayer3D = $Steps_Grass
@onready var player: CharacterBody3D = $".."

var wind_atk = preload("res://Assets/Sound/Weapon_sounds/8_Atk_Magic_SFX/25_Wind_01.wav")

func play_sound():
	if player.velocity.y == 0:
		steps_grass.pitch_scale = randf_range(0.8,1.2)
		steps_grass.play()

func play_attack_sound():
	var sound_palyer = AudioStreamPlayer3D.new() as AudioStreamPlayer3D
	sound_palyer.volume_db = -12.0
	sound_palyer.stream = wind_atk
	sound_palyer.autoplay = true
	add_child(sound_palyer)
	await  sound_palyer.finished
	sound_palyer.queue_free()
