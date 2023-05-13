extends CharacterBody2D

@export var speed := 30
@export var bite_distance := 50

@export var anim: SpriteAnimTool
@export var body: Node2D

func _physics_process(delta):
	var player = get_tree().get_first_node_in_group("player")
	var dir = global_position.direction_to(player.global_position)
	
	
	var dist = global_position.distance_squared_to(player.global_position)
	if dist < bite_distance * bite_distance:
		body.scale.x = -1 if dir.x < 0 else 1
		anim.start_play("open")
	else:
		anim.start_play("move")
	
	velocity = dir * speed
	move_and_slide()
