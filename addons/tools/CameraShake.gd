# https://github.com/scipioceaser/Godot-Camera-Shake
class_name ShakeCamera2D
extends Camera2D

@export var max_offset := 5.0
@export var max_roll := 5.0
@export var shakeReduction := 2.5

var stress : float = 0.0
var shake : float = 0.0

func shake_screen(delta):
	_process_shake(global_transform.origin, 0.0, delta)
	

func _process_shake(center, angle, delta) -> void:
	shake = stress * stress
	rotation_degrees = angle + (max_roll * shake *  _get_noise(randi(), delta))
	
	var o = Vector2()
	o.x = (max_offset * shake * _get_noise(randi(), delta + 1.0))
	o.y = (max_offset * shake * _get_noise(randi(), delta + 2.0))
	
	offset.x = center.x + o.x
	offset.y = center.y + o.y
		
	stress -= (shakeReduction / 100.0)
	stress = clamp(stress, 0.0, 1.0)
	
	
func _get_noise(noise_seed, time) -> float:
	var n = FastNoiseLite.new()
	
	n.seed = noise_seed
	n.octaves = 4
	n.period = 20.0
	n.persistence = 0.8
	
	return n.get_noise_1d(time)
	
	
func add_stress(amount : float) -> void:
	stress += amount
	stress = clamp(stress, 0.0, 1.0)
