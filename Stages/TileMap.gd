extends TileMap

var astar = AStar2D.new()
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
	
func get_closest_point(point):
	var word_to_map = Vector2(world_to_map(point).x,world_to_map(point).y)
	var closest_point = astar.get_point_position(astar.get_closest_point(word_to_map))
	return map_to_world(Vector2(closest_point.x,closest_point.y)) + _half_cell_size
			
func calculate_point_index(point: Vector2) -> float:
	return point.x + map_size.x * point.y

func find_any_tile_neighbors(point):
	return false

func add_walkable_cells(obstacles := []) -> Array:
	var points: = []
	for x in range(max_x,min_x, -1):
		for y in range(max_y,min_y, -1):				
			var point: = Vector2(x, y)
			if !((get_cell(point.x, point.y + 2) != INVALID_CELL) and get_cell(point.x, point.y + 1) == INVALID_CELL):
				continue
			var index: = calculate_point_index(point)
			if(!astar.has_point(index)):
				points.append(point)
				astar.add_point(index, Vector2(point.x, point.y), 1)
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
			
var corners = []
var left_corners = []
var right_corners = []

func check_corner(point):
	var is_corner = false
	for corner in corners:
		if corner.x == point.x and corner.y == point.y:
			is_corner = true
	return is_corner

func check_left_corner(point):
	var is_corner = false
	for corner in left_corners:
		if corner.x == point.x and corner.y == point.y:
			is_corner = true
	return is_corner

func check_right_corner(point):
	var is_corner = false
	for corner in right_corners:
		if corner.x == point.x and corner.y == point.y:
			is_corner = true
	return is_corner

func get_corners(cells):
	for cell in cells:
		var right = cell - Vector2(1,0)
		var left = cell - Vector2(-1,0)
		var up = cell - Vector2(0,1)
		var up_two = up - Vector2(0,1)
		if(astar.has_point(calculate_point_index(right)) and !astar.has_point(calculate_point_index(left))) and get_cellv(left) == INVALID_CELL and get_cellv(up) == INVALID_CELL and get_cellv(up_two) == INVALID_CELL:
			left_corners.append(cell)
			
		if(astar.has_point(calculate_point_index(left)) and !astar.has_point(calculate_point_index(right))) and get_cellv(right) == INVALID_CELL and get_cellv(up) == INVALID_CELL and get_cellv(up_two) == INVALID_CELL:
			right_corners.append(cell)
		
		if(!astar.has_point(calculate_point_index(left)) and !astar.has_point(calculate_point_index(right))) and get_cellv(up) == INVALID_CELL and get_cellv(up_two) == INVALID_CELL:
			corners.append(cell)
			pass

var detect_offset = 12
var direct_offset = 10

func do_top_to_down_detect(start_cell,cell):
	for direct_connection in range(start_cell.y, start_cell.y + direct_offset):
		if(get_cellv(Vector2(start_cell.x,direct_connection)) != INVALID_CELL):
			break
		if(astar.has_point(calculate_point_index(Vector2(start_cell.x,direct_connection)))):
			lines.append([cell,Vector2(start_cell.x,direct_connection)])
			astar.connect_points(calculate_point_index(cell),calculate_point_index(Vector2(start_cell.x,direct_connection)), true)
			break
func connect_corners(cells):	
	for cell in corners:
		var start_cell = Vector2()
		if get_cellv(cell+ Vector2(1,0)) != INVALID_CELL and get_cellv(cell+ Vector2(-1,0)) == INVALID_CELL:
			start_cell = cell + Vector2(-3,0)
			do_top_to_down_detect(start_cell, cell)
		if get_cellv(cell+ Vector2(-1,0)) != INVALID_CELL and get_cellv(cell+ Vector2(1,0)) == INVALID_CELL:
			start_cell = cell + Vector2(3,0)
			do_top_to_down_detect(start_cell, cell)	
		if	get_cellv(cell+ Vector2(-1,0)) == INVALID_CELL and get_cellv(cell+ Vector2(1,0)) == INVALID_CELL:
			start_cell = cell + Vector2(3,0)
			do_top_to_down_detect(start_cell, cell)
			start_cell = cell + Vector2(-3,0)
			do_top_to_down_detect(start_cell, cell)
			pass
			


	
		
	for cell in left_corners:
		for connection_offset in range(2,5):
			var start_cell = cell + Vector2(connection_offset,0)		
			for direct_connection in range(start_cell.y, start_cell.y + direct_offset):
				if(get_cellv(Vector2(start_cell.x,direct_connection)) != INVALID_CELL):
					break
				if(astar.has_point(calculate_point_index(Vector2(start_cell.x,direct_connection)))):
					lines.append([cell,Vector2(start_cell.x,direct_connection)])
					astar.connect_points(calculate_point_index(cell),calculate_point_index(Vector2(start_cell.x,direct_connection)), true)
					break
	
			for j in range(start_cell.y - detect_offset, start_cell.y + detect_offset):
				for i in range(start_cell.x,start_cell.x + detect_offset, 1):
					if !check_right_corner(Vector2(i,j)):
						continue
					lines.append([cell,Vector2(i,j)])
					astar.connect_points(calculate_point_index(cell),calculate_point_index(Vector2(i,j)), true)
					
	for connection_offset in range(2,5):
		for cell in right_corners:
			var start_cell = cell + Vector2(-connection_offset,0)
			for direct_connection in range(start_cell.y, start_cell.y + direct_offset):
				if(get_cellv(Vector2(start_cell.x,direct_connection)) != INVALID_CELL):
					break
				if(astar.has_point(calculate_point_index(Vector2(start_cell.x,direct_connection)))):
					lines.append([cell,Vector2(start_cell.x,direct_connection)])
					astar.connect_points(calculate_point_index(cell),calculate_point_index(Vector2(start_cell.x,direct_connection)), true)
					break
			
			for j in range(start_cell.y - detect_offset, start_cell.y + detect_offset):
				for i in range(start_cell.x,start_cell.x - detect_offset, -1):
					if !check_left_corner(Vector2(i,j)):
						continue
					lines.append([cell,Vector2(i,j)])
					astar.connect_points(calculate_point_index(cell),calculate_point_index(Vector2(i,j)), true)

var lines = []
var connected_points = []
func _ready() -> void:
	var obstacles: = get_used_cells()
	calculate_bounds(obstacles)
	map_size = Vector2(max_x, max_y)
	connected_points = add_walkable_cells(obstacles)
	get_corners(connected_points)
	connect_corners(connected_points)
	connect_walkable_cells(connected_points)
	connected_points.sort()
#	for connectedPoint in connected_cells:
#		if(get_cellv(connectedPoint) == -1):	
#			if(get_cellv(connectedPoint) == INVALID_CELL):
#				set_cellv(connectedPoint,tile_set.find_tile_by_name("177"))
#			else:
#				set_cellv(connectedPoint,3)
#				print("problem")

# pixelden gride döndürmek için world_to_map
# gridden pixele döndürmek için map_to_world + half_cell_size
var founded_zombie_target_path = {}
func find_random_target_position(target_position,init_position, name):
		
	if founded_zombie_target_path.has(name):
		if(init_position.distance_to(world_to_map(founded_zombie_target_path[name])) < 10):
			return target_position
		return founded_zombie_target_path[name]
	
	
	var closest_points = []
	closest_points.append(astar.get_point_position(astar.get_closest_point(target_position + Vector2(randi() % 10,  0 ))))
	closest_points.append(astar.get_point_position(astar.get_closest_point(target_position + Vector2(-(randi() % 10),  0 ))))
	if closest_points.size() == 0:
		return target_position
	founded_zombie_target_path[name] = map_to_world(closest_points[randi() % closest_points.size()]) + _half_cell_size
	return  founded_zombie_target_path[name]
	
	
var old_player_pos = Vector2(0,0) 

func _get_path(init_position: Vector2, target_position: Vector2, name) -> Array:
#	if abs(old_player_pos.distance_to(target_position)) > 500:
#		founded_zombie_target_path.clear()
#		old_player_pos = target_position
	init_position = get_closest_point(init_position)
	target_position = get_closest_point(target_position)
#	if init_position.distance_to(target_position) > 1000:
#		target_position = find_random_target_position(world_to_map(target_position),world_to_map(init_position),name)
	
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
			var id = calculate_point_index(point)
			if astar.get_point_weight_scale(id) > 10000:
				print(id, ": sifirlandi")
				astar.set_point_weight_scale(id, 1)
			astar.set_point_weight_scale(id, astar.get_point_weight_scale(id) + 1)
			var point_world: = map_to_world(Vector2(point.x, point.y))
			world_path.append(point_world + _half_cell_size) 
			founded_path[name].append(point_world + _half_cell_size)
		return world_path
	else:
		return []
		
var current_target = Vector2()
func set_target_point(target):
	current_target = target

func _draw():
#	draw_circle(init_pos , 64, PLAYER_COLOR)
#	draw_circle(target_pos, 64, TARGET_COLOR)
#	draw_circle(current_target, 84, Color("#fff"))
#	for  cnt in connected_cells:
#		draw_circle(cnt[0] + _half_cell_size, 25, Color("#f0f"))
#		draw_circle(cnt[1] + _half_cell_size , 20, Color("#ff0"))
#		draw_line(cnt[0] + _half_cell_size,cnt[1] + _half_cell_size, DRAW_COLOR, 3)
#
#	for connection in lines:
#		draw_line(map_to_world(connection[0]) + _half_cell_size,map_to_world(connection[1])+_half_cell_size, DRAW_COLOR, 3)
#
#	for corner in corners:
#		draw_circle(map_to_world(corner) + _half_cell_size, 30,Color("FFF") )
#
#	for corner in left_corners:
#		draw_circle(map_to_world(corner) + _half_cell_size, 30,Color("000") )
#
#	for corner in right_corners:
#		draw_circle(map_to_world(corner) + _half_cell_size, 30,Color("F00") )
	for name in founded_path:
		for point_index in range(0,len(founded_path[name]) - 1):
				if len(founded_path[name]) > 2:
					draw_line(founded_path[name][point_index],founded_path[name][point_index + 1], DRAW_COLOR, 10)
	for target in founded_zombie_target_path:
		draw_circle(founded_zombie_target_path[target], 100, TARGET_COLOR)
	pass

	
func find_path(start_position: Vector2, end_position: Vector2) -> Array:
	var map_path = []
	map_path = astar.get_point_path(
		calculate_point_index(start_position),
		calculate_point_index(end_position))
	return map_path
