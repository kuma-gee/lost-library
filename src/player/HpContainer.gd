extends Control

@export var health: HealthBox
@export var hp_icon: PackedScene

func _ready():
	GameManager.lose_hp.connect(func(hp): _lose_hp(hp))
	for i in range(0, GameManager.player_health):
		var node = hp_icon.instantiate()
		add_child(node)

func _lose_hp(hp: int):
	for i in range(1, hp + 1):
		var idx = get_child_count() - i
		if idx < 0:
			break
		
		var heart = get_child(idx)
		if heart:
			heart.kill()
	
	if GameManager.player_health == 1:
		for child in get_children():
			if child.killed: continue
			
			child.pulse()
			break
