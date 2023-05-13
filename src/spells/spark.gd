extends Area2D

@export var damage = 1
@export var anim: AnimationPlayer

func _ready():
	anim.animation_finished.connect(func(n): queue_free())
	anim.play("fire")
