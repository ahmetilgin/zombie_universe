extends TileMap

var astar = AStar.new()
var map_size: = Vector2()
onready var _half_cell_size = cell_size / 2
var world_path = []
const BASE_LINE_WIDTH = 3.0
const DRAW_COLOR = Color('#0F0')
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
			min_x = pos.x
		elif pos.x > max_x:
			max_x = pos.x
		if pos.y < min_y:
			min_y = pos.y
		elif pos.y > max_y:
			max_y = pos.y
	

			
func calculate_point_index(point: Vector2) -> float:
	return point.x + map_size.x * point.y

func find_any_tile_neighbors(point):
	return false

func add_walkable_cells(obstacles := []) -> Array:
	var points: = []
	for x in range(max_x,min_x, -1):
		for y in range(max_y,min_y, -1):				
			var point: = Vector2(x, y)
			if (get_cell(point.x, point.y + 1) == INVALID_CELL and get_cell(point.x, point.y + 2) == INVALID_CELL) or get_cellv(point) != INVALID_CELL:
				continue
				
			var found_direction = false
			var last_point = -1
			for down_to_top in range(y,min_y, -1):
				if(((get_cell(x - 1,down_to_top) != INVALID_CELL) or get_cell(x + 1,down_to_top) != INVALID_CELL) and get_cell(x,down_to_top) == INVALID_CELL) or (((get_cell(x - 2,down_to_top) != INVALID_CELL) or get_cell(x + 2,down_to_top) != INVALID_CELL) and get_cell(x,down_to_top) == INVALID_CELL):			
					found_direction = true	
					last_point = down_to_top
			
			if found_direction:
				for down_to_top in range(y,last_point - 3, -1):
					var direction_point = Vector2(x,down_to_top)
					var index: = calculate_point_index(direction_point)
					if(!astar.has_point(index)):
						points.append(direction_point)
						astar.add_point(index, Vector3(point.x, point.y, 0))
			var index: = calculate_point_index(point)
			if(!astar.has_point(index)):
				points.append(point)
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
			Vector2(point.x, point.y - 1),
			Vector2(point.x, point.y + 1),
		])
		
		for point_relative in points_relative:
			var index_relative: = calculate_point_index(point_relative)
			if is_outside_bounds(point_relative):
				continue    

			if !astar.has_point(index_relative):
				continue
			connected_cells.append([map_to_world(point),map_to_world(point_relative)])
			astar.connect_points(index, index_relative, false)

func _ready() -> void:
	var obstacles: = get_used_cells()
	calculate_bounds(obstacles)
	map_size = Vector2(max_x, max_y)
	var cells = add_walkable_cells(obstacles)
	connect_walkable_cells(cells)
#	for connectedPoint in connected_cells:
#		if(get_cellv(connectedPoint) == -1):	
#			if(get_cellv(connectedPoint) == INVALID_CELL):
#				set_cellv(connectedPoint,tile_set.find_tile_by_name("177"))
#			else:
#				set_cellv(connectedPoint,3)
#				print("problem")

 
func _get_path(init_position: Vector2, target_position: Vector2, name) -> Array:
	init_pos = init_position
	target_pos = target_position

	var start_position = world_to_map(init_pos)
	var end_position = world_to_map(target_pos)
	var start_index: = calculate_point_index(start_position)
	var end_index: = calculate_point_index(end_position)
	update()
	if astar.has_point(start_index) and astar.has_point(end_index):
		var path: = find_path(start_position, end_position)
		founded_path[name] = []
		world_path = []
		for point in path:
			var point_world: = map_to_world(Vector2(point.x, point.y))
			world_path.append(point_world) 
			founded_path[name].append(point_world)

		return world_path
	else:
		return []
		
var current_target = Vector2()
func set_target_point(target):
	current_target = target

func _draw():
	draw_circle(init_pos , 64, PLAYER_COLOR)
	draw_circle(target_pos, 64, TARGET_COLOR)
	draw_circle(current_target, 32, Color("#fff"))
	for  cnt in connected_cells:
		draw_circle(cnt[0] , 25, Color("#f0f"))
		draw_circle(cnt[1] , 20, Color("#ff0"))
		draw_line(cnt[0],cnt[1], DRAW_COLOR, 3)
		
	
	
	for name in founded_path:
		for point_index in range(0,len(founded_path[name]) - 1):
				if len(founded_path[name]) > 2:
					draw_circle(founded_path[name][point_index], 10, TARGET_COLOR)
					draw_line(founded_path[name][point_index],founded_path[name][point_index + 1], DRAW_COLOR, 10)
				

func find_path(start_position: Vector2, end_position: Vector2) -> Array:
	var map_path = []
	map_path = astar.get_point_path(
		calculate_point_index(start_position),
		calculate_point_index(end_position))
	return map_path
