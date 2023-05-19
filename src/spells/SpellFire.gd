class_name SpellFire
extends HitBox

@export var anim: AnimationPlayer
@export var speed := 200

var did_hit = false

func _ready():
	anim.animation_finished.connect(_on_anim_finished)
	
	anim.play("prepare")
	super._ready()

func _physics_process(delta):
	if did_hit: return
	translate(Vector2.RIGHT.rotated(rotation) * speed * delta)

func _on_anim_finished(anim_name: String):
	if anim_name == "prepare":
		anim.play("fire")
	elif anim_name == "impact" or anim_name == "fade_out":
		queue_free()

func _on_area_entered(area):
	did_hit = true
	if anim.has_animation("impact"):
		anim.play("impact")
	super._on_area_entered(area)

func _on_visible_on_screen_notifier_2d_screen_exited():
	anim.play("fade_out")
