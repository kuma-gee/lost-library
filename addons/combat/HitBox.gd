class_name HitBox
extends Area2D

@export var damage = 1

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area.has_method("damage"):
		area.damage(damage, global_position)
