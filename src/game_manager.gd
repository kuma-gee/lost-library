extends Node

@export var spells: Array[SpellResource]

var lvl = 1
var player_health = 5

var known_spells = []

func next_level():
	lvl += 1
	SceneManager.reload_scene()

func reset():
	player_health = 5
	lvl = 1

func next_random_unknown_spell():
	var unknown = []
	
	if known_spells.size() == spells.size():
		unknown = spells
	else:
		for spell in spells:
			if spell.action in known_spells:
				continue
		
			unknown.append(spell)
	
	var random = unknown.pick_random()
	known_spells.append(random.action)
	
	return random
