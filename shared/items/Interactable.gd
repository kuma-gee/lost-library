class_name Interactable
extends Area2D

signal interacted

const OUTLINE = preload("res://shared/items/sprite_outline.tres")

@export var sprite: Sprite2D


func highlight():
	if sprite and not sprite.material:
		sprite.material = OUTLINE


func unhighlight():
	if sprite and sprite.material:
		sprite.material = null


func interact():
	emit_signal("interacted")


func _on_interacted():
	SceneManager.reload_scene()
