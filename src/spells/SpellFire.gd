class_name SpellFire
extends HitBox

@export var anim: AnimationPlayer
@export var speed := 200

var hit = false

func _ready():
	anim.animation_finished.connect(_on_anim_finished)
	
	anim.play("prepare")
	super._ready()

func _physics_process(delta):
	if hit: return
	translate(Vector2.RIGHT.rotated(rotation) * speed * delta)

func _on_anim_finished(anim_name: String):
	if anim_name == "prepare":
		anim.play("fire")
	elif anim_name == "impact":
		queue_free()

func _on_area_entered(area):
	hit = true
	if anim.has_animation("impact"):
		anim.play("impact")
	super._on_area_entered(area)

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
