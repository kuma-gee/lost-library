extends Node

signal lose_hp(hp)

@export var spells: Array[SpellResource]
@export var warp_sound: AudioStreamPlayer

var lvl = 1
var player_health = 5

var known_spells = []

func reduce_hp(hp):
	player_health -= hp
	lose_hp.emit(hp)

func is_first_level():
	return lvl == 1

func next_level():
	lvl += 1
	warp_sound.play()
	SceneManager.reload_scene()

func reset():
	player_health = 5
	lvl = 1

func next_random_unknown_spell():
	var unknown = []
	for spell in spells:
		if spell.action in known_spells:
			continue
	
		unknown.append(spell)

	var random
	if unknown.size() == 0:
		random = spells.pick_random()
	else:
		random = unknown.pick_random()
		known_spells.append(random.action)
	
	return random

func frame_freeze(time_scale: float, duration: float):
	$FrameFreeze.freeze(time_scale, duration)
