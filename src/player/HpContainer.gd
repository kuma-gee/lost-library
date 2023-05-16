extends Control

@export var health: HealthBox
@export var hp_icon: Texture2D

func _ready():
	GameManager.health_change.connect(func(hp): _update_hp(hp))
	_update_hp(GameManager.player_health)

func _update_hp(hp: int):
	for child in get_children():
		remove_child(child)
	
	if hp > 0:
		for i in range(0, hp):
			var tex = TextureRect.new()
			tex.texture = hp_icon
			add_child(tex)
