class_name MiniMap
extends TileMap

@export var accel := 200
@export var camera: Camera2D
@export var main_camera: Camera2D
@export var tileMap: DungeonMap

const SOURCE = 1
const ATLAS = Vector2(13, 8)

const SOURCE_LAYER = 0
const TARGET_LAYER = 0

@onready var camera_scale := Vector2(tile_set.tile_size) / Vector2(tileMap.tile_set.tile_size)

func _ready():
	tileMap.tiles_updated.connect(_update)
	_update()

func _update():
	clear()
	for cell in tileMap.get_used_cells(SOURCE_LAYER):
		var data = tileMap.get_cell_tile_data(SOURCE_LAYER, cell)
		if DungeonMap.is_ground_type(data):
			set_cell(TARGET_LAYER, cell, SOURCE, ATLAS)

func _process(delta):
	var dest = main_camera.global_position * Vector2(camera_scale)
	camera.global_position = dest #camera.global_position.move_toward(dest, accel * delta)
