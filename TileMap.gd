extends TileMap

var astar = AStar.new()
var map_size: = Vector2(120, 120)
onready var _half_cell_size = cell_size / 2
var world_path = []
const BASE_LINE_WIDTH = 3.0
const DRAW_COLOR = Color('#fff')
const PLAYER_COLOR = Color('#00f')
const TARGET_COLOR = Color('#f00')
var init_pos = Vector2()
var target_pos = Vector2()

func calculate_point_index(point: Vector2) -> float:
    return point.x + map_size.x * point.y

func add_walkable_cells(obstacles := []) -> Array:
	var points: = []
	for y in range(0,100):
		for x in range(0,100):
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
	init_pos = init_position
	target_pos = target_position
	var start_position = world_to_map(init_position)
	var end_position = world_to_map(target_position)

	var path: = find_path(start_position, end_position)
	world_path = []
	for point in path:
		var point_world: = map_to_world(Vector2(point.x, point.y))
		world_path.append(point_world + _half_cell_size)
	update()
	return world_path

func _draw():
	var i = 1
	draw_circle(init_pos , 10, PLAYER_COLOR)
	draw_circle(target_pos, 10, TARGET_COLOR)
	if len(world_path) > 2:
		for point_index in range(0,len(world_path) - 1):
			draw_circle(world_path[point_index] , 10 , DRAW_COLOR)



func find_path(start_position: Vector2, end_position: Vector2) -> Array:
#    remove_unit(start_position)
#    remove_unit(end_position)
	var map_path = []
	map_path = astar.get_point_path(
		calculate_point_index(start_position),
		calculate_point_index(end_position))
	return map_path
