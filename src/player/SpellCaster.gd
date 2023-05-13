class_name SpellCaster
extends Node2D

@export var spark_spell: PackedScene
@export var firerate = 1.0

var can_fire = true

func fire():
	if not can_fire: return
	
	var spark = spark_spell.instantiate()
	spark.global_position = global_position
	spark.global_rotation = global_rotation
	get_tree().current_scene.add_child(spark)
	
	can_fire = false
	await get_tree().create_timer(firerate).timeout
	can_fire = true
