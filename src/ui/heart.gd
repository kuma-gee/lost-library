extends Control

@export var anim_sprite: AnimatedSprite2D
@export var anim: AnimationPlayer

func _ready():
	anim_sprite.stop()
	anim_sprite.frame = 0
	
	anim_sprite.animation_finished.connect(func(): queue_free())
	anim.play("enter")

func kill():
	anim_sprite.play()

func pulse():
	anim.play("pulse")
