extends Timer

@export var walls: TileMap
@export var enemies: Array[PackedScene]

func _ready():
	timeout.connect(_spawn)
	
func _spawn():
	var enemy = enemies.pick_random().instantiate()
	var rect = walls.get_used_rect()
	var start = walls.map_to_local(rect.position)
	var end = walls.map_to_local(rect.end)
	
	var radius = (end - start).length() / 2
	var dir = Vector2.UP.rotated(TAU * randf())
	
	var spawn_pos = walls.map_to_local(rect.get_center()) + dir * radius
	enemy.global_position = spawn_pos
	get_tree().current_scene.add_child(enemy)
