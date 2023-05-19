extends Node2D

@export var hit_sound: AudioStreamPlayer
@export var max_hit_effect = 3
@export var frames: SpriteFrames
@export var max_offset = 15
@export var min_offset = 5
@export var max_offset_y = 10

const HIT_ANIM_COUNT = 2

var count = 0
var finished = 0

func _ready():
	hit_sound.play()
	count = randi_range(2, max_hit_effect)
	var pos = []
	var first_sign = 0
	for i in range(0, count):
		var x = randf_range(-max_offset, max_offset)
		if abs(x) < min_offset:
			x = min_offset * sign(x)
		if first_sign != 0 and first_sign == sign(x):
			x *= -1
			first_sign = 0
		
		var y = randf_range(-max_offset_y, -3)
		pos.append(Vector2(x, y))
		
		if first_sign == 0:
			first_sign = sign(x)
		
	for i in range(0, pos.size()):
		var p = pos[i]
		_random_hit(p, i)

func _random_hit(pos: Vector2, hit_anim: int):
	var sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = frames
	add_child(sprite)
	
	sprite.position = pos
	sprite.flip_h = pos.x > 0
	
	var hit = "hit_%s" % [(hit_anim % HIT_ANIM_COUNT) + 1] #+ str(randi_range(1, HIT_ANIM_COUNT))
	sprite.play(hit)
	sprite.animation_finished.connect(_on_finished)

func _on_finished():
	count += 1
	if finished == count:
		queue_free()

func _random_offset():
	var offset = randf_range(-max_offset, max_offset)
	
