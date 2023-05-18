extends CharacterBody2D

enum {
	MOVE,
	SPAWN,
	DEAD,
	JUMP,
}

@export var anim: SpriteAnimTool
@export var spawner: MinionSpawner
@export var scroll_scene: PackedScene
@export var health: HealthBox

@export var move_distance := 30
@export var move_speed := 100

@export var jump_timer: Timer
@export var follow_player_speed := 200

var can_move = true
var target_pos
var state = MOVE
var speed = move_speed
var can_jump = false

func _ready():
	health.health = min(50, GameManager.lvl * 10)

func _process(delta):
	match state:
		MOVE: _set_move_target()
		SPAWN: _spawn_minions()
		JUMP: _follow_player()
		
func _follow_player():
	if not can_jump: return
	
	speed = follow_player_speed
	var player = get_tree().get_first_node_in_group("player")
	target_pos = player.global_position
	anim.start_play("jump")

func stop_follow():
	can_jump = false
	target_pos = null

func _spawn_minions():
	if spawner.can_spawn():
		anim.play("shout")

func _set_move_target():
	if not can_move: return
	
	if spawner.can_spawn():
		state = SPAWN
	elif can_jump:
		state = JUMP
	else:
		speed = move_speed
		can_move = false
		var player = get_tree().get_first_node_in_group("player")
		var dir = global_position.direction_to(player.global_position)
		target_pos = global_position + dir * move_distance
		anim.play("move")

func _physics_process(delta):
	if target_pos:
		var dir = target_pos - global_position
		var len = dir.length()
		if len < 5 and speed == move_speed: # prevent overshooting target
			dir = Vector2.ZERO
			target_pos = null

		var speed_multiplier = 1.0
		if speed == follow_player_speed:
			# don't reach the target pos so it will be smoother if the player keeps moving
			if len < 10:
				speed_multiplier = max(0.1, speed_multiplier * len/10)
		
		velocity = dir.normalized() * speed * speed_multiplier
		move_and_slide()
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "move":
		can_move = true
	elif anim_name == "jump":
		jump_timer.start()
		state = MOVE
	elif anim_name == "shout":
		state = MOVE


func _on_health_died():
	GameManager.frame_freeze(0.05, 1)
	state = DEAD
	anim.play("died")
	spawner.kill_all()
	await anim.animation_finished
	spawner.kill_all() # make sure they are really killed
	
	var scroll = scroll_scene.instantiate()
	scroll.global_position = global_position
	get_tree().current_scene.add_child(scroll)
	
	queue_free()


func _on_high_jump_timer_timeout():
	can_jump = true
