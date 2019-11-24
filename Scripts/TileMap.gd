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


var max_x = 0
var min_x = 0
var max_y = 0
var min_y = 0

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
	if get_cell(point.x, point.y + 1) != INVALID_CELL:
		return true
	if get_cell(point.x , point.y + 2) != INVALID_CELL:
		return false
	if get_cell(point.x, point.y - 1) != INVALID_CELL:
		return true
	if get_cell(point.x - 1, point.y) != INVALID_CELL:
		return true
	if get_cell(point.x + 1, point.y) != INVALID_CELL:
		return true
	if get_cell(point.x - 1, point.y - 1) != INVALID_CELL:
		return true
	if get_cell(point.x + 1, point.y - 1) != INVALID_CELL:
		return true
	if get_cell(point.x - 1, point.y - 1) != INVALID_CELL:
		return true
	if get_cell(point.x + 1, point.y + 1) != INVALID_CELL:
		return true
	if get_cell(point.x -1 , point.y + 1) != INVALID_CELL:
		return true
	var left_top = point + Vector2(-2,-3)
	var right_bottom = point + Vector2(3,3)
	for x in range(left_top.x,right_bottom.x):
		for y in range(left_top.y, right_bottom.y):
			if get_cellv(Vector2(x,y)) != INVALID_CELL:
				return false
	return true
	
func add_walkable_cells(obstacles := []) -> Array:
	var points: = []
	for x in range(min_x + 3,max_x):
		for y in range(min_y + 3,max_y):
			var point: = Vector2(x, y)
			if point in obstacles:
				continue
				
			if find_any_tile_neighbors(point):
				continue
				
#			var points_relative: = PoolVector2Array([
#				Vector2(point.x + 1, point.y),
#				Vector2(point.x - 1, point.y),
#				Vector2(point.x, point.y + 1),
#				Vector2(point.x, point.y - 1),
#				Vector2(point.x - 1, point.y - 1),
#				Vector2(point.x + 1, point.y + 1),
#				Vector2(point.x - 1, point.y + 1),
#				Vector2(point.x + 1, point.y - 1),
#			])
#
#			if left_and_right_area_control(points_relative):
#				continue
		
			points.append(point)
			var index: = calculate_point_index(point)
			astar.add_point(index, Vector3(point.x, point.y, 0))
	return points

func is_outside_bounds(point: Vector2) -> bool:
    return point.x <= min_x\
        or point.y <= min_y or point.x >= map_size.x or point.y >= map_size.y
		

	

func left_and_right_area_control(points_relative):
	# sağ tarafta tile varsa o an ki point geçersiz
	var right_has_tile = get_cellv(points_relative[0])  != INVALID_CELL
	var left_has_tile = get_cellv(points_relative[1]) != INVALID_CELL
	
	var bottom_has_tile = get_cellv(points_relative[2]) != INVALID_CELL
	var top_has_tile = get_cellv(points_relative[3]) != INVALID_CELL
	
	var left_top_has_tile = get_cellv(points_relative[4]) != INVALID_CELL
	var right_bottom_has_tile = get_cellv(points_relative[5]) != INVALID_CELL
	
	var left_bottom_has_tile = get_cellv(points_relative[6]) != INVALID_CELL
	var right_top_has_tile = get_cellv(points_relative[7]) != INVALID_CELL
	
	if bottom_has_tile:
		return true
	else:
		return false
	
	if (right_has_tile or left_has_tile) and bottom_has_tile:
		return false
		
	return (right_top_has_tile or left_bottom_has_tile or right_bottom_has_tile or left_top_has_tile or left_has_tile or right_has_tile or top_has_tile or bottom_has_tile)
		


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

			astar.connect_points(index, index_relative, false)

func _ready() -> void:
	var obstacles: = get_used_cells()
	calculate_bounds(obstacles)
	map_size = Vector2(max_x, max_y)
	var cells = add_walkable_cells(obstacles)
	connect_walkable_cells(cells)
	#for connectedPoint in connected_cells:
	#	set_cellv(connectedPoint,21)

func _get_path(init_position: Vector2, target_position: Vector2) -> Array:
	init_pos = init_position
	target_pos = target_position
	var grid_start = init_position / cell_size
	var grid_end = target_position / cell_size
	var start_position = Vector2(round(grid_start.x),round(grid_start.y))
	var end_position = Vector2(round(grid_end.x),round(grid_end.y))
	var start_index: = calculate_point_index(start_position)
	var end_index: = calculate_point_index(end_position)

	if astar.has_point(start_index) and astar.has_point(end_index):
		var path: = find_path(start_position, end_position)
		world_path = []
		for point in path:
			var point_world: = map_to_world(Vector2(point.x, point.y))
			world_path.append(point_world + _half_cell_size) 
		update()
		return world_path
	else:
		return []
		


func _draw():
	draw_circle(init_pos , 2, PLAYER_COLOR)
	draw_circle(target_pos, 2, TARGET_COLOR)
	if len(world_path) > 2:
		for point_index in range(0,len(world_path) - 1):
			draw_circle(world_path[point_index] , 1 , DRAW_COLOR)

func find_path(start_position: Vector2, end_position: Vector2) -> Array:
	var map_path = []
	map_path = astar.get_point_path(
		calculate_point_index(start_position),
		calculate_point_index(end_position))
	return map_path