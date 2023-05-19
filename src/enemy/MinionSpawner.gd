class_name MinionSpawner
extends Timer

@export var minion: PackedScene
@export var count = 5
@export var spawn_radius = 250

var timed_out = true
var all_died = true
var alive = 0

func can_spawn():
	return all_died and timed_out

func _ready():
	timeout.connect(func(): timed_out = true)
	
func spawn():
	if not can_spawn(): return
	
	timed_out = false
	all_died = false
	alive = count
	for i in range(0, count):
		var enemy = minion.instantiate()
		var center = Vector2.ZERO
		var dir = Vector2.UP.rotated(TAU * randf())
		
		var spawn_pos = center  + dir * spawn_radius
		enemy.global_position = spawn_pos
		enemy.died.connect(_on_enemy_died)
		get_tree().current_scene.add_child(enemy)
	
	start()

func _on_enemy_died():
	alive -= 1
	if alive <= 0:
		all_died = true
		
func kill_all():
	for minion in get_tree().get_nodes_in_group("minion"):
		minion.die()
