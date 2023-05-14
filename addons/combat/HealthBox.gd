class_name HealthBox
extends Area2D

signal died()
signal hit(knockback)
signal hp_change(hp)

@export var health: int : set = _set_health

func _set_health(hp):
	health = hp
	hp_change.emit(hp)
	
	if health <= 0:
		set_deferred("monitorable", false)
		died.emit()

func damage(dmg: int, knockback: Vector2):
	self.health -= dmg
	hit.emit(knockback)
