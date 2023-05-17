class_name Spell
extends HitBox

@export var anim: AnimationPlayer
@export var player_hit_box: HitBox

func _ready():
	anim.animation_finished.connect(func(n): queue_free())
	anim.play("fire")
	super._ready()
