class_name MinionSpawner
extends Timer

#@export var walls: TileMap
@export var minion: PackedScene
@export var count = 5

var can_spawn = true

func _ready():
	timeout.connect(func(): can_spawn = true)
	
func spawn():
	if not can_spawn: return []
	
	var nodes = []
	can_spawn = false
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
		get_tree().current_scene.add_child(enemy)
		nodes.append(enemy)
	
	start()
	return nodes
