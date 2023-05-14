extends Control

@export var health: HealthBox
@export var hp_icon: Texture2D

func _ready():
	health.hp_change.connect(func(hp): _update_hp(hp))

func _update_hp(hp: int):
	var diff = hp - get_child_count()
	if diff < 0:
		for i in range(0, -diff):
			if get_child_count() > 0:
				remove_child(get_child(0))
	elif diff > 0:
		for i in range(0, diff):
			var tex = TextureRect.new()
			tex.texture = hp_icon
			add_child(tex)
			
