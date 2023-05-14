extends CharacterBody2D

enum {
	MOVE,
	SPAWN,
	DEAD,
}

@export var anim: SpriteAnimTool
@export var spawner: MinionSpawner
@export var scroll_scene: PackedScene

@export var move_distance := 30
@export var move_speed := 100

var can_move = true
var target_pos
var state = MOVE

func _process(delta):
	match state:
		MOVE: _set_move_target()
		SPAWN: _spawn_minions()
		
func _spawn_minions():
	if spawner.can_spawn():
		await get_tree().create_timer(1).timeout
		anim.play("shout")
		spawner.spawn()

func _set_move_target():
	if not can_move: return
	
	if spawner.can_spawn():
		state = SPAWN
	else:
		can_move = false
		var player = get_tree().get_first_node_in_group("player")
		var dir = global_position.direction_to(player.global_position)
		target_pos = global_position + dir * move_distance
		anim.play("move")

func _physics_process(delta):
	if target_pos:
		var dir = target_pos - global_position
		if dir.length() < 5: # prevent overshooting target
			dir = Vector2.ZERO
			target_pos = null
		
		velocity = dir.normalized() * move_speed
		move_and_slide()
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "move":
		can_move = true
	elif anim_name == "shout":
		state = MOVE


func _on_health_died():
	state = DEAD
	anim.play("died")
	spawner.kill_all()
	await anim.animation_finished
	
	var scroll = scroll_scene.instantiate()
	scroll.global_position = global_position
	get_tree().current_scene.add_child(scroll)
	
	queue_free()
