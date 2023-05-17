extends Node2D

@export var gameover: Control

func _ready():
	randomize()
	gameover.hide()

func _on_player_died():
	gameover.show()
