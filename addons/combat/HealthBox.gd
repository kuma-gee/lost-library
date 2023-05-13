class_name HealthBox
extends Area2D

signal died()
signal hit(knockback)

@export var health: int

func damage(dmg: int, knockback: Vector2):
	health -= dmg
	if health <= 0:
		set_deferred("monitorable", false)
		died.emit()
		
	hit.emit(knockback)
