extends Node

@export var spells: Array[SpellResource]

var lvl = 1
var player_health = 5

func next_level():
	lvl += 1
	SceneManager.reload_scene()

func reset():
	player_health = 5
	lvl = 1
