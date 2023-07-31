class_name MiniMap
extends TileMap

@export var tileMap: DungeonMap

const SOURCE = 1
const ATLAS = Vector2(13, 8)

const SOURCE_LAYER = 0
const TARGET_LAYER = 0

func _ready():
	tileMap.tiles_updated.connect(_update)
	_update()

func _update():
	clear()
	for cell in tileMap.get_used_cells(SOURCE_LAYER):
		var data = tileMap.get_cell_tile_data(SOURCE_LAYER, cell)
		if DungeonMap.is_ground_type(data):
			set_cell(TARGET_LAYER, cell, SOURCE, ATLAS)
