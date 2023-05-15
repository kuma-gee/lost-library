class_name Spell
extends HitBox

@export var anim: AnimationPlayer
@export var player_hit_box: HitBox

func _ready():
	anim.animation_finished.connect(func(n): queue_free())
	anim.play("fire")
	
	# In case the enemy hitbox is too big, be nice to the player
	if player_hit_box:
		player_hit_box.damage = damage
	
	super._ready()
