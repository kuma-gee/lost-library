class_name Portal
extends Interactable

@export var anim: AnimationPlayer

func _ready():
	anim.play("spawn")
	await anim.animation_finished
	anim.play("idle")
