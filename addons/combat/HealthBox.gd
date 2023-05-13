class_name HealthBox
extends Area2D

signal died()
signal hit()

@export var health: int

func damage(dmg: int):
	health -= dmg
	if health <= 0:
		died.emit()
	hit.emit()
