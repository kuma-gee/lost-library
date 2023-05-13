class_name HealthBox
extends Area2D

signal died()
signal hit(knockback)

@export var health: int

func damage(dmg: int, pos: Vector2):
	health -= dmg
	if health <= 0:
		died.emit()
		
	var knockback = pos.direction_to(global_position)
	hit.emit(knockback)
