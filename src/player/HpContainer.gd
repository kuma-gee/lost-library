extends Control

@export var health: HealthBox
@export var hp_icon: Texture2D

func _ready():
	for i in range(health.health):
		var tex = TextureRect.new()
		tex.texture = hp_icon
		add_child(tex)
	
	health.hit.connect(func(x): _hit())

func _hit():
	if get_child_count() > 0:
		remove_child(get_child(0))
