class_name Spell
extends HitBox

@export var anim: AnimationPlayer

func _ready():
	anim.animation_finished.connect(func(n): queue_free())
	anim.play("fire")
	super._ready()
