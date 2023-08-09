extends Node2D

@export var pause: Control
@export var idle_music: AudioStreamPlayer
@export var dungeon: DungeonMap
@export var player: Node2D

func _ready():
	randomize()
	
	player.global_position = dungeon.random_leaf()

func _on_player_died():
	pause.game_over()


func _on_bite_boss_died():
	var tween = create_tween()
	idle_music.volume_db = -50
	idle_music.play()
	tween.tween_property(idle_music, "volume_db", -20, 1.0)
