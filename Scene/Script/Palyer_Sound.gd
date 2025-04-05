extends Node3D

@onready var steps_grass: AudioStreamPlayer3D = $Steps_Grass
@onready var player: CharacterBody3D = $".."

func play_sound():
	if player.velocity.y == 0:
		steps_grass.pitch_scale = randf_range(0.8,1.2)
		steps_grass.play()
