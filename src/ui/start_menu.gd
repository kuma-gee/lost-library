extends Menu

@export var open_door_sound: AudioStreamPlayer
@export var particles: GPUParticles2D

@export var start: Control
@export var options: Control

func _ready():
	particles.emitting = true # in the final build, this does not emit automatically
	change_menu(start)

func _on_start_pressed():
	open_door_sound.play()
	SceneManager.change_scene("res://src/game.tscn", null, 0.5)


func _on_exit_pressed():
	get_tree().quit()


func _on_options_pressed():
	change_menu(options)
