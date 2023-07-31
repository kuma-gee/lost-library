# https://abitawake.com/news/articles/procedural-generation-with-godot-create-dungeons-using-a-bsp-tree
extends TileMap

@export var map_w := 80
@export var map_h := 50
@export var min_room_size := 8
@export var min_room_factor := 0.4

var wall_source = 0
var wall_layer = 0
var wall_tile = Vector2i(0, 0)
var wall_terrain_set = 0
var wall_terrain_id = 1

var ground_source = 2
var ground_layer = 0
var ground_tile = Vector2i(2, 2)

var tree = {}
var leaves = []
var leaf_id = 0
var rooms = []

func _ready():
	generate()

func generate():
	clear()
	fill_roof()
	start_tree()
	create_leaf(0)
	create_rooms()
	join_rooms()
	clear_deadends()

func fill_roof():
	var cells = []
	for x in range(0, map_w):
		for y in range(0, map_h):
			cells.append(Vector2i(x, y))
			set_cell(wall_layer, Vector2i(x, y), wall_source, wall_tile)
	
	# set_cells_terrain_connect(wall_layer, cells, wall_terrain_set, wall_terrain_id)

func start_tree():
	rooms = []
	tree = {}
	leaves = []
	leaf_id = 0

	tree[leaf_id] = { "x": 1, "y": 1, "w": map_w-2, "h": map_h-2 }
	leaf_id += 1

func create_leaf(parent_id):
	var x = tree[parent_id].x
	var y = tree[parent_id].y
	var w = tree[parent_id].w
	var h = tree[parent_id].h

	# used to connect the leaves later
	tree[parent_id].center = { x = floor(x + w/2), y = floor(y + h/2) }

	# whether the tree has space for a split
	var can_split = false

	# randomly split horizontal or vertical
	# if not enough width, split horizontal
	# if not enough height, split vertical
	var split_type = ['h', 'v'].pick_random()
	if   (min_room_factor * w < min_room_size):  split_type = "h"
	elif (min_room_factor * h < min_room_size):  split_type = "v"

	var leaf1 = {}
	var leaf2 = {}

	# try and split the current leaf,
	# if the room will fit
	if (split_type == "v"):
		var room_size = min_room_factor * w
		if (room_size >= min_room_size):
			var w1 = randi_range(room_size, (w - room_size))
			var w2 = w - w1
			leaf1 = { x = x, y = y, w = w1, h = h, split = 'v' }
			leaf2 = { x = x+w1, y = y, w = w2, h = h, split = 'v' }
			can_split = true
	else:
		var room_size = min_room_factor * h
		if (room_size >= min_room_size):
			var h1 = randi_range(room_size, (h - room_size))
			var h2 = h - h1
			leaf1 = { x = x, y = y, w = w, h = h1, split = 'h' }
			leaf2 = { x = x, y = y+h1, w = w, h = h2, split = 'h' }
			can_split = true

	# rooms fit, lets split
	if can_split:
		leaf1.parent_id    = parent_id
		tree[leaf_id]      = leaf1
		tree[parent_id].l  = leaf_id
		leaf_id += 1

		leaf2.parent_id    = parent_id
		tree[leaf_id]      = leaf2
		tree[parent_id].r  = leaf_id
		leaf_id += 1

		# append these leaves as branches from the parent
		leaves.append([tree[parent_id].l, tree[parent_id].r])

		# try and create more leaves
		create_leaf(tree[parent_id].l)
		create_leaf(tree[parent_id].r)

func create_rooms():
	for id in tree:
		var leaf = tree[id]
		if leaf.has("l"): continue # if node has children, don't build rooms

		if randf() <= 0.75:
			var room = {}
			room.id = id;
			room.w  = randi_range(min_room_size, leaf.w) - 1
			room.h  = randi_range(min_room_size, leaf.h) - 1
			room.x  = leaf.x + floor((leaf.w-room.w)/2) + 1
			room.y  = leaf.y + floor((leaf.h-room.h)/2) + 1
			room.split = leaf.split

			room.center = Vector2()
			room.center.x = floor(room.x + room.w/2)
			room.center.y = floor(room.y + room.h/2)
			rooms.append(room);

	# draw the rooms on the tilemap
	for i in range(rooms.size()):
		var r = rooms[i]
		for x in range(r.x, r.x + r.w):
			for y in range(r.y, r.y + r.h):
				set_cell(ground_layer, Vector2i(x, y), ground_source, ground_tile)

func join_rooms():
	for sister in leaves:
		var a = sister[0]
		var b = sister[1]
		connect_leaves(tree[a], tree[b])

func connect_leaves(leaf1, leaf2):
	var x = min(leaf1.center.x, leaf2.center.x)
	var y = min(leaf1.center.y, leaf2.center.y)
	var w = 1
	var h = 1

	# Vertical corridor
	if (leaf1.split == 'h'):
		x -= floor(w/2.0)+1
		h = abs(leaf1.center.y - leaf2.center.y)
	else:
		# Horizontal corridor
		y -= floor(h/2.0)+1
		w = abs(leaf1.center.x - leaf2.center.x)

	# Ensure within map
	x = 0 if (x < 0) else x
	y = 0 if (y < 0) else y

	for i in range(x, x+w):
		for j in range(y, y+h):
			# if get_cell_source_id(wall_layer, Vector2(i, j)) != -1:
			set_cell(ground_layer, Vector2i(i, j), ground_source, ground_tile)
			
func clear_deadends():
	var done = false

	while !done:
		done = true

		for cell in get_used_cells(ground_layer):
			if get_cell_atlas_coords(wall_layer, cell) != ground_tile: continue

			var roof_count = check_nearby(cell.x, cell.y)
			if roof_count == 3:
				set_cell(wall_layer, cell, wall_source, wall_tile)
				done = false

# check in 4 dirs to see how many tiles are roofs
func check_nearby(x, y):
	var count = 0
	if get_cell_atlas_coords(wall_layer, Vector2(x, y-1)) == wall_tile:  count += 1
	if get_cell_atlas_coords(wall_layer, Vector2(x, y+1)) == wall_tile:  count += 1
	if get_cell_atlas_coords(wall_layer, Vector2(x-1, y)) == wall_tile:  count += 1
	if get_cell_atlas_coords(wall_layer, Vector2(x+1, y)) == wall_tile:  count += 1
	return count
