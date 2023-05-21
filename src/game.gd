extends Node2D

@export var pause: Control
@export var idle_music: AudioStreamPlayer

func _ready():
	randomize()

func _on_player_died():
	pause.game_over()


func _on_bite_boss_died():
	var tween = create_tween()
	idle_music.volume_db = -50
	idle_music.play()
	tween.tween_property(idle_music, "volume_db", -20, 1.0)
