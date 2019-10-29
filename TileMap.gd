extends TileMap

var astar = AStar.new()
var map_size: = Vector2(256, 256)
onready var _half_cell_size = cell_size / 2
var world_path = []
const BASE_LINE_WIDTH = 3.0
const DRAW_COLOR = Color('#fff')


func calculate_point_index(point: Vector2) -> float:
    return point.x + map_size.x * point.y

func add_walkable_cells(obstacles := []) -> Array:
    var points: = []
    for y in range(map_size.y):
        for x in range(map_size.x):
            var point: = Vector2(x, y)
            if point in obstacles:
                continue
                
            points.append(point)
            var index: = calculate_point_index(point)
            astar.add_point(index, Vector3(point.x, point.y, 0))
    return points

func is_outside_bounds(point: Vector2) -> bool:
    return point.x < 0\
        or point.y < 0 or point.x >= map_size.x or point.y >= map_size.y
		
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
            astar.connect_points(index, index_relative, false)

func _ready() -> void:
    var obstacles: = get_used_cells()
    var cells: Array = add_walkable_cells(obstacles)
    connect_walkable_cells(cells)

func _get_path(init_position: Vector2, target_position: Vector2) -> Array:
	print(cell_size)
	var start_position: = init_position / cell_size
	start_position.x = round(start_position.x)
	start_position.y = round(start_position.y+ 1)
	var end_position: = target_position / cell_size
	end_position.x = round(end_position.x)
	end_position.y = round(end_position.y+ 1)
	print("Calculated GridEnd = ", start_position)
	print("Calculated GridEnd = ", end_position)
	var path: = find_path(start_position, end_position)
	world_path = []
	var last_point = map_to_world(Vector2(init_position.x, init_position.y)) + _half_cell_size

	for point in path:
		var point_world: = map_to_world(Vector2(point.x, point.y))
		world_path.append(point_world)
	update()
	return world_path

func _draw():
	if len(world_path) > 2:
		for point_index in range(0,len(world_path) - 1):
			draw_line(world_path[point_index] + _half_cell_size, world_path[point_index + 1] + _half_cell_size, DRAW_COLOR, BASE_LINE_WIDTH, true)



func find_path(start_position: Vector2, end_position: Vector2) -> Array:
#    remove_unit(start_position)
#    remove_unit(end_position)

    var path: = []
    if astar.has_point(calculate_point_index(end_position)):
        var map_path = astar.get_point_path(
            calculate_point_index(start_position),
            calculate_point_index(end_position))
        for point in map_path:
            path.append(point)

#    add_unit(start_position)
#    add_unit(end_position)

    path.pop_front()
    return path

func get_pawn(coordinate: Vector2) -> Dictionary:
    var coord = world_to_map(coordinate)
    for unit in get_children():
        if world_to_map(unit.position) == coord:
            return { "some": unit }
    return { "none": 0 }