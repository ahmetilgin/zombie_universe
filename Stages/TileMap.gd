extends TileMap

var astar = AStar.new()
var map_size: = Vector2()
onready var _half_cell_size = cell_size / 2
var world_path = []
const BASE_LINE_WIDTH = 3.0
const DRAW_COLOR = Color('#fff')
const PLAYER_COLOR = Color('#00f')
const TARGET_COLOR = Color('#f00')
var init_pos = Vector2()
var target_pos = Vector2()
var connected_cells = []

var founded_path = {}

var max_x = 0
var min_x = 0
var max_y = 0
var min_y = 0


func get_max_border():
	return Vector2(max_x,max_y)

func get_min_border():
	return Vector2(min_x, min_y)

func calculate_bounds(obstacles):
	for pos in obstacles:
		if pos.x < min_x:
			min_x = int(pos.x)
		elif pos.x > max_x:
			max_x = int(pos.x)
		if pos.y < min_y:
			min_y = int(pos.y)
		elif pos.y > max_y:
			max_y = int(pos.y)
	max_x = max_x + 2
	max_y = max_y + 2
	

			
func calculate_point_index(point: Vector2) -> float:
	return point.x + map_size.x * point.y

func find_any_tile_neighbors(point):
	return false

func add_walkable_cells(obstacles := []) -> Array:
	var points: = []
	for x in range(min_x,max_x):
		for y in range(min_y,max_y):
			var point: = Vector2(x, y)
			if point in obstacles:
				continue

			points.append(point)
			var index: = calculate_point_index(point)
			astar.add_point(index, Vector3(point.x, point.y, 0))
	return points

func is_outside_bounds(point: Vector2) -> bool:
	return point.x <= min_x\
		or point.y <= min_y or point.x >= map_size.x or point.y >= map_size.y
		

	


func connect_walkable_cells(points: Array) -> void:
	for point in points:
		var index: = calculate_point_index(point)
		var points_relative: = PoolVector2Array([
			Vector2(point.x + 1, point.y),
			Vector2(point.x - 1, point.y),
			Vector2(point.x, point.y + 1),
			Vector2(point.x, point.y - 1),
		])

		for point_relative in points_relative:
			var index_relative: = calculate_point_index(point_relative)
			if is_outside_bounds(point_relative):
				continue    
			if not astar.has_point(index_relative):
				continue	
			connected_cells.append(point_relative)
			set_cellv(point_relative, 8)
			astar.connect_points(index, index_relative, false)

func _ready() -> void:
	var obstacles: = get_used_cells()
	calculate_bounds(obstacles)
	map_size = Vector2(max_x, max_y)
	var cells = add_walkable_cells(obstacles)
	connect_walkable_cells(cells)
#	for connectedPoint in connected_cells:
#		set_cellv(connectedPoint,8)

func _get_path(init_position: Vector2, target_position: Vector2, name) -> Array:
	init_pos = init_position
	target_pos = target_position

	var start_position = world_to_map(init_position)
	var end_position = world_to_map(target_position)
	var start_index: = calculate_point_index(start_position)
	var end_index: = calculate_point_index(end_position)

	if astar.has_point(start_index) and astar.has_point(end_index):
		var path: = find_path(start_position, end_position)
		founded_path[name] = []
		world_path = []
		for point in path:
			var point_world: = map_to_world(Vector2(point.x, point.y))
			world_path.append(point_world + _half_cell_size) 
			founded_path[name].append(point_world + _half_cell_size)
		update()
		return world_path
	else:
		return []
		

	
func _draw():
	draw_circle(init_pos , 2, PLAYER_COLOR)
	draw_circle(target_pos, 2, TARGET_COLOR)
	if len(founded_path) > 2:
		for name in founded_path:
			for point_index in range(0,len(founded_path[name]) - 1):
				draw_circle(founded_path[name][point_index] , 1 , DRAW_COLOR)

func find_path(start_position: Vector2, end_position: Vector2) -> Array:
	var map_path = []
	map_path = astar.get_point_path(
		calculate_point_index(start_position),
		calculate_point_index(end_position))
	return map_path
