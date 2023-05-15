class_name HitBox
extends Area2D

@export var damage = 1
@export var knockback_force = 0

func _ready():
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_area_entered)

func _on_area_entered(area):
	if area is Node2D and area.has_method("damage"):
		var knockback_dir =  global_position.direction_to(area.global_position)
		area.damage(damage, knockback_dir * knockback_force)

