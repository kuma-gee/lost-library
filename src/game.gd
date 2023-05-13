extends Node2D

@export var gameover: Control

func _ready():
	gameover.hide()

func _on_player_died():
	gameover.show()

func _on_bite_boss_died():
	print("receive forgotten knowledge")
