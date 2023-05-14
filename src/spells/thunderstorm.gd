extends Node2D

@export var thunder_scene: PackedScene
@export var firerate: Timer

@export var firerate_mean = 1.0
@export var firerate_deviation = 0.5

@onready var radius = $CollisionShape2D.shape.radius

func _on_lifetime_timeout():
	queue_free()


func _on_firerate_timeout():
	var thunder = thunder_scene.instantiate()
	var dir = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
	var pos = global_position + dir
	thunder.global_position = pos
	get_tree().current_scene.add_child(thunder)
	
	firerate.start(randfn(firerate_mean, firerate_deviation))
