class_name TeleportCast
extends RayCast2D

@export var body: Node2D
@export var teleport_sound: AudioStreamPlayer

func teleport():
	if is_colliding():
		var target = get_collision_point()
		var dir = body.global_position.direction_to(target)
		body.global_position = target - dir * 3 # make sure player does not get stuck in wall
	else:
		var target = target_position
		target = target.rotated(global_rotation)
		body.global_position += target
	
	teleport_sound.play()
