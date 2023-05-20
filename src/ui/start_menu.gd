extends Control

@export var open_door_sound: AudioStreamPlayer
@export var particles: GPUParticles2D

func _ready():
	particles.emitting = true # in the final build, this does not emit automatically

func _on_start_pressed():
	open_door_sound.play()
	SceneManager.change_scene("res://src/game.tscn", null, 0.5)


func _on_exit_pressed():
	get_tree().quit()
