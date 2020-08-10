extends Area2D
var can_create_zombie=true
var punk_zombie = preload("res://Scenes/KinematicScenes/Zombies/PunkZombie/PunkZombie.tscn")
var simple_zombie = preload("res://Scenes/KinematicScenes/Zombies/SimpleZombie/SimpleZombie.tscn")
var stalker_zombie = preload("res://Scenes/KinematicScenes/Zombies/StalkerZombie/StalkerZombie.tscn")
var zombie_level = 1
var generate_zombie_timer = Timer.new()
var generate_wave_timer = Timer.new()
var zombie_dead_counter = 0
var is_countdown_pause_timer = false
var wave_is_contiune = false
var wave_time = 5.0
var tile_map
var pause_time = 20
var counttimer 
var countdown_timer = Timer.new()
var available_cells = []
var first_wave_zombie_size = 15
var zombie_types = { 0 : simple_zombie , 
					 1 : stalker_zombie,
					 2 : punk_zombie,
						3 : punk_zombie,
						4 : punk_zombie,
						5 : punk_zombie,
						6 : punk_zombie,
						7 : punk_zombie
					}
									
signal wave_finished
signal wave_started
func get_used_cells():
	tile_map = get_parent().get_node("TileMap")
	var max_border = tile_map.get_max_border()
	var min_border = tile_map.get_min_border()
	for i in range(min_border.x + 1, max_border.x - 1) :
		for j in range(min_border.y + 1, max_border.y - 1):
			if(tile_map.get_cell(i,j + 1) != -1 and tile_map.get_cell(i,j) == -1):
				available_cells.append(Vector2(i,j))

func _ready():
	randomize()
	counttimer = pause_time
	show_current_start_level();
	get_used_cells()
	countdown_timer()
	on_time_countdown_unvisible()
	generate_zombies()

func countdown_timer():
	countdown_timer.set_wait_time(1)
	add_child(countdown_timer) #to process
	countdown_timer.connect("timeout",self, "_on_count_down_timer_timeout") 


func on_time_countdown_visible():
	get_parent().get_parent().get_node("Game_UI/CountDownTimer").set_visible(true)
	is_countdown_pause_timer = true
	
func on_time_countdown_unvisible():
	get_parent().get_parent().get_node("Game_UI/CountDownTimer").set_visible(false)

func _on_count_down_timer_timeout():
	counttimer -= 1
	if  (counttimer < 1):
		wave_start()
		counttimer = pause_time
	get_parent().get_parent().get_node("Game_UI/CountDownTimer/Time").text = String(counttimer)


func _process(delta):
	$AnimatedSprite.play("new")
	if( zombie_dead_counter == first_wave_zombie_size + zombie_level ):#!wave_is_contiune ile dalganın başladığını ve olumle doğum eşit olsa bile,yeni dalga oluşturmaması için koyuldu.
		wave_stop()
		wave_is_contiune = true
		zombie_dead_counter = 0

func wave_stop():
	zombie_level += 1
	countdown_timer.start()
	on_time_countdown_visible()
	
func wave_start():
	show_current_start_level()
	on_time_countdown_unvisible()
	countdown_timer.stop()
	generate_zombies()
	

func select_zombie_for_level( _level):
	var zombie_by_level = _level
	return int( floor(randi( ) % ((zombie_by_level / 3) +1 ) ))
	
func set_zombie_level(level):
	zombie_level = level

func generate_zombies():
	for i in range(0,zombie_level + first_wave_zombie_size):
		var zombie_instance =zombie_types.get(select_zombie_for_level(zombie_level)).instance()
		get_parent().call_deferred("add_child",zombie_instance)
		var new_pos = tile_map.map_to_world(available_cells[randi() % len(available_cells)] - Vector2(0,2)) + tile_map._half_cell_size
		zombie_instance.set_global_position(new_pos)
		zombie_instance.connect("dead_counter_for_wave",self,"on_dead_counter_for_wave")
	
func on_dead_counter_for_wave():
	zombie_dead_counter += 1

func _on_generate_zombie_timer_timeout():
	can_create_zombie = true
	generate_zombies()

func show_current_start_level():
	get_parent().get_parent().get_node("Game_UI/level_text/level_counter").add_color_override("default_color", Color(0.47,0.05127, 0.05127))
	get_parent().get_parent().get_node("Game_UI/level_text").add_color_override("default_color", Color(0.47,0.05127, 0.05127))
	get_parent().get_parent().get_node("Game_UI/level_text/level_counter").text = String(zombie_level)
	
func save():
	var data = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"position_x":get_global_position().x,
		"position_y":get_global_position().y,
		"level":zombie_level
	}
	return data
	
func load_data(node_data):
	set_global_position(Vector2(node_data["position_x"], node_data["position_y"]))
	zombie_level = int(node_data["level"])
	show_current_start_level()
	pass
