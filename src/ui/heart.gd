extends Control

@export var anim_sprite: AnimatedSprite2D
@export var anim: AnimationPlayer

var killed = false
var pulsing = false

func _ready():
	anim_sprite.stop()
	anim_sprite.frame = 0
	
	anim_sprite.animation_finished.connect(func(): queue_free())
	anim.play("enter")
	anim.animation_finished.connect(func(_n): if pulsing: pulse())

func kill():
	killed = true
	anim_sprite.play()

func pulse():
	pulsing = true
	if not anim.is_playing():
		anim.play("pulse")
