class_name TeleportCast
extends RayCast2D

@export var body: Node2D
@export var teleport_sound: AudioStreamPlayer
@export var effect: PackedScene

func teleport():
	var effect_node = effect.instantiate()
	effect_node.global_position = body.global_position
	get_tree().current_scene.add_child(effect_node)
	
	if is_colliding():
		var target = get_collision_point()
#		var dir = body.global_position.direction_to(target)
		var dir = get_collision_normal()
		body.global_position = target + dir * 5 # make sure player does not get stuck in wall
	else:
		var target = target_position
		target = target.rotated(global_rotation)
		body.global_position += target
	
	teleport_sound.play()
