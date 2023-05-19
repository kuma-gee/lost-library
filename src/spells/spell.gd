class_name Spell
extends HitBox

@export var anim: AnimationPlayer
@export var player_hit_box: HitBox
@export var hit_effect: PackedScene

func _ready():
	anim.animation_finished.connect(func(n): queue_free())
	anim.play("fire")
	super._ready()


func _on_hit(area):
	var eff = hit_effect.instantiate()
	eff.global_position = area.global_position
	get_tree().current_scene.add_child(eff)
	
