class_name MinionSpawner
extends Timer

@export var minion: PackedScene
@export var count = 5

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
		var walls = get_tree().get_first_node_in_group("walls")
		var enemy = minion.instantiate()
		var rect = walls.get_used_rect()
		var start = walls.map_to_local(rect.position)
		var end = walls.map_to_local(rect.end)
		
		var radius = (end - start).length() / 2
		var dir = Vector2.UP.rotated(TAU * randf())
		
		var spawn_pos = walls.map_to_local(rect.get_center()) + dir * radius
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
