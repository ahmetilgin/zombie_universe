extends Node2D
var turret_grid 

onready var level_text_counter = get_node("Game_UI/level_text/level_counter")
onready var level_text = get_node("Game_UI/level_text")
var portal_scene = preload("res://Scenes/StaticScenes/ZombiePortal/ZombiePortal.tscn")
var player_scene = preload("res://Scenes/KinematicScenes/Player/Player.tscn")
var gameover_scene = preload("res://Scenes/Screens/GameOverScreen/GameoverScreen.tscn")
var market_scene = preload("res://Scenes/StaticScenes/Market/Market.tscn").instance()
var constants = preload("res://Stages/constants.gd").new()
var player = null

var finish_portal = 0
signal stop_wave
var start_portal = 1
var portal_list = []
var is_the_buy_button_clicked = false
var created_turret 
var instance = null
var created_instance_price
var game_level = 1
var tile_pos
var is_create_instance = false
var tile_grid = null
var countdown_timer = Timer.new()
var is_countdown_pause_timer = false
var pause_time = 100
var counttimer
var second_passed = true
var portal_coordinates = [Vector2(1,5),Vector2(34,5)]
var is_teleport_buying = false
var teleport_locs = []
var teleport_pair = []
var selected_teleport_location_count = 0
var wide_camera_zoom = Vector2(3,3)
var walls = {
	401: preload("res://Scenes/StaticScenes/fences/WoodFence/WoodFence.tscn"),
	402: preload("res://Scenes/StaticScenes/fences/IronFence/IronFence.tscn"),
	403: preload("res://Scenes/StaticScenes/fences/GoldFence/GoldFence.tscn"),
	404: preload("res://Scenes/StaticScenes/Trambolin/Trambolin.tscn")
}

var teleports = {
	500 : preload("res://Scenes/StaticScenes/Teleportal/Teleport.tscn")
}

var turret_paths = {
	801: preload("res://Scenes/KinematicScenes/Taretler/BasicTurret/BasicTurret.tscn"),
	802: preload("res://Scenes/KinematicScenes/Taretler/MachineTurret/MachineTurret.tscn"),
	803: preload("res://Scenes/KinematicScenes/Taretler/LaserTurret/LaserTurret.tscn"),
	804: preload("res://Scenes/KinematicScenes/Taretler/BazukaTurret/BazukaTurret.tscn"),
}

func create_portals(portal_count):
	for portal in portal_list:
		portal.queue_free()
	for i in range(0,portal_count):
		var portal = portal_scene.instance()
		$Background.add_child(portal)
		portal.connect("wave_finished",self, "wave_finish")
		portal.connect("wave_started",self, "wave_started")
		var portal_coordinate = randi() % portal_coordinates.size()
		var pixel_coordinate = $Background/TileMap.map_to_world(portal_coordinates[portal_coordinate])
		portal.set_global_position(pixel_coordinate + $Background/TileMap.cell_size / 2)
		portal_coordinates.erase(portal_coordinates[portal_coordinate])
		portal_list.push_back(portal)

func get_tile_borders():
	max_border = $Background/TileMap.get_max_border()
	min_border = $Background/TileMap.get_min_border()

func buy_health():
	player.healt_kit(20)
	pass

func buy_sword():
	pass
	
func buy_ammo():
	player.increase_bullet_count(20)
	pass
	
func buy_bullet(item_id):
	player.set_current_weapon(item_id)

func buy_player_item(item_id):
	if item_id == 101 or item_id == 102 or item_id == 103  or item_id == 107 or item_id == 108 or item_id == 109 or item_id == 110 or item_id == 111  or item_id == 112  or item_id == 113 :
		buy_bullet(item_id)
		pass
	elif item_id == 104:
		buy_health()
		pass
	elif item_id == 106:
		buy_ammo()
	pass
	hide_market()
	$Game_UI/Market_Button.pressed = false
	is_opened_market = false

func buy_wall(item_id):
	created_instance_price = constants.items[item_id][1]
	create_wall_instance(item_id)
	hide_market()
	show_accept_button()
	show_select_position(true)
	show_grid()

func buy_teleportal(item_id):
	created_instance_price = constants.items[item_id][1]
	is_teleport_buying = true 
	teleport_pair.push_back(create_teleport_instance(item_id))
	teleport_pair.push_back(create_teleport_instance(item_id))
	hide_market()
	show_accept_button()
	show_select_position(true)
	show_grid()
	
func show_select_position(is_visible):
	$Game_UI/SelectPositionLabel.set_visible(is_visible)

func buy_turret(item_id):
	created_instance_price = constants.items[item_id][1]
	hide_market()
	show_select_position(true)
	create_instance(item_id)
	instance.show_rotations()
	show_accept_button()
	show_grid()
	
func item_solded(item_id):
	is_the_buy_button_clicked = true
	var item_type = int(item_id / 100) * 100
	if item_type == 100:
		buy_player_item(item_id)
		pass
	elif item_type == 400:
		buy_wall(item_id)
		update()
		pass
	elif item_type == 500:
		buy_teleportal(item_id)
		player.get_node("Camera2D").set_zoom(wide_camera_zoom)
		pass
	elif item_type == 800:
		buy_turret(item_id)
		player.get_node("Camera2D").set_zoom(wide_camera_zoom)
		update()
		pass
	else:
		print("Satın Alma Arızası")

func connect_market():
	$Market.connect("item_sold",self, "item_solded")

func item_solded_failed():
	is_the_buy_button_clicked = false

func _create_market_scene():
	add_child(market_scene)

func _ready():
	get_tile_borders()
	player = player_scene.instance()
	var center_x = (max_border.x - min_border.x) / 2
	var center_y = (max_border.y - min_border.y) / 2
	add_child(player)
	var player_pos = $Background/TileMap.map_to_world(Vector2(center_x,center_y))
	print(player_pos)
	player.set_global_position(player_pos)
	_create_market_scene()
	disable_accept_button()
	create_portals(start_portal)
	connect_market()
	countdown_timer()
	get_node("Game_UI").add_child(gameover_scene.instance())
	on_time_countdown_unvisible()
	hide_market()
	hide_accept_button()

func enable_accept_button():
	$Game_UI/accept_button.disabled = false
	
func disable_accept_button():
	$Game_UI/accept_button.disabled = true 

func on_time_countdown_visible():
	$Game_UI/CountDownTimer.set_visible(true)
	is_countdown_pause_timer = true
	
func on_time_countdown_unvisible():
	$Game_UI/CountDownTimer.set_visible(false)
	
func on_market_button_visible():
	$Game_UI/Market_Button.disabled = false
	pass
	
func hide_market():
	$Market.set_offset(Vector2(0,1000))
		
func show_market():
	$Market.set_offset(Vector2(0,0))
	is_opened_market = true
	
func show_accept_button():
	$Game_UI/SelectPositionLabel.set_visible(true)
	$Game_UI/accept_button.set_visible(true)

func _process(delta):
	if second_passed and $Game_UI/CountDownTimer.visible :
		countdown_timer.start()
		second_passed = false

func show_current_level():
	level_text_counter.add_color_override("default_color", Color(1,1,1))
	level_text.add_color_override("default_color", Color(1,1,1))

func show_current_start_level():
	level_text_counter.add_color_override("default_color", Color(0.47,0.05127, 0.05127))
	level_text.add_color_override("default_color", Color(0.47,0.05127, 0.05127))
	level_text_counter.text = String(game_level)


func wave_finish():
	finish_portal += 1
	if start_portal == finish_portal:
		finish_portal = 0
		game_level += 1  
		for portal in portal_list:
			portal.wave_stop()
			portal.set_zombie_level(game_level)
		show_current_level()
		on_time_countdown_visible()

var max_border = Vector2()
var min_border = Vector2()
var is_opened_market = false

func show_grid():
	for i in range(min_border.x, max_border.x):
		for j in range(min_border.y, max_border.y):
			if $Background/TileMap.get_cell(i,j) == -1 and $Background/TileMap.get_cell(i,j + 1) != 14  and $Background/TileMap.get_cell(i,j+1) != -1: 				
				$Background/TileMap.set_cellv(Vector2(i,j),14)			
			pass

func clear_grid():
	for i in range(min_border.x, max_border.x):
		for j in range(min_border.y, max_border.y):
			if $Background/TileMap.get_cell(i,j) == 14 or $Background/TileMap.get_cell(i,j) == 15:				
				$Background/TileMap.set_cellv(Vector2(i,j),-1)
			pass

func hide_grid():
	for i in range(min_border.x, max_border.x):
		for j in range(min_border.y, max_border.y):
			if $Background/TileMap.get_cell(i,j) == 14:				
				$Background/TileMap.set_cellv(Vector2(i,j),-1)

func _draw():
	pass
		
func hide_accept_button():
	$Game_UI/SelectPositionLabel.set_visible(false)
	$Game_UI/accept_button.set_visible(false)
	
func _on_TouchScreenButton_pressed():
	if !is_opened_market:
		show_market()
	else:
		hide_market()
		if(is_create_instance):
			buy_cancel()
		is_opened_market = false
	update()
	pass # Replace with function body.
	
func buy_cancel():
	clear_grid()
	$Game_UI/Coin_Counter.increase_coins(created_instance_price)
	player.get_node("Camera2D").set_zoom(Vector2(1,1))
	hide_accept_button()
	if is_teleport_buying:
		for teleport in teleport_pair:
			var wr = weakref(teleport);
			if (!wr.get_ref()):
				teleport.queue_free()
		teleport_pair.clear()
		selected_teleport_location_count = 0
		teleport_locs.clear()
		is_teleport_buying = false
	else:
		instance.queue_free()
	is_create_instance = false
	disable_accept_button()
	
var started_wave_count = 0
func wave_started():
	started_wave_count += 1
	if start_portal == started_wave_count:
		started_wave_count = 0
		on_time_countdown_unvisible()
		show_current_start_level()
		
func _unhandled_input(event):
	if event is InputEventMouseButton :
		if event.pressed and event.button_index == BUTTON_LEFT and is_the_buy_button_clicked:
			var pos = get_global_mouse_position()
			if tile_grid == null:
				var grid = $Background/TileMap.world_to_map(pos)
				if ($Background/TileMap.get_cellv(grid) ==14):
					tile_grid = grid
			else:
				if $Background/TileMap.get_cell(tile_grid.x,tile_grid.y) == 15 && !is_teleport_buying :
					$Background/TileMap.set_cell(tile_grid.x,tile_grid.y,14)
				pass
			var grid = $Background/TileMap.world_to_map(pos)
			print(grid)
			if ($Background/TileMap.get_cellv(grid) ==14):
				tile_grid = grid
			if !is_teleport_buying:
				select_turret_position()
			else:
				select_teleport_position()
				
func select_turret_position():
	if(tile_grid != null):
		if  $Background/TileMap.get_cell(tile_grid.x,tile_grid.y) == 14:
			enable_accept_button()
			$Background/TileMap.set_cell(tile_grid.x,tile_grid.y,15) 
			
func select_teleport_position():
	if(tile_grid != null):
		if  $Background/TileMap.get_cell(tile_grid.x,tile_grid.y) == 14:
			$Background/TileMap.set_cell(tile_grid.x,tile_grid.y, 15) 
			selected_teleport_location_count += 1
			teleport_locs.push_back(tile_grid)
			if selected_teleport_location_count>= 2:
				enable_accept_button()
				if selected_teleport_location_count > 2:
					$Background/TileMap.set_cell(teleport_locs[0].x,teleport_locs[0].y, 14)
					teleport_locs.remove(0) 


func finish_teleport_buy():
	teleport_pair[0].set_global_position($Background/TileMap.map_to_world(teleport_locs[0]))
	teleport_pair[1].set_global_position($Background/TileMap.map_to_world(teleport_locs[1]))
	
	teleport_pair[0].set_other_pos($Background/TileMap.map_to_world(teleport_locs[1]))
	teleport_pair[1].set_other_pos($Background/TileMap.map_to_world(teleport_locs[0]))
	selected_teleport_location_count = 0
	teleport_locs.clear()
	is_teleport_buying = false
	teleport_pair.clear()
	hide_accept_button()
	clear_grid()
	hide_market()

func create_instance(turret):
	instance = turret_paths[turret].instance()
	is_create_instance = true
	instance.set_global_position(Vector2(-500,-500))
	$Background.add_child(instance)
	
func create_wall_instance(wall):
	instance = walls[wall].instance()
	instance.set_global_position(Vector2(-500,-500))
	is_create_instance = true
	$Background.add_child(instance)
	
func create_teleport_instance(teleport):
	instance = teleports[teleport].instance()
	instance.set_global_position(Vector2(-500,-500))
	is_create_instance = true
	$Background.add_child(instance)
	return instance

func finish_turret_buy():
	turret_grid = tile_grid	
	if is_create_instance:
		tile_pos =  $Background/TileMap.map_to_world(tile_grid)
		instance.set_global_position(Vector2(tile_pos.x + 32,tile_pos.y ) )
	clear_grid()
	hide_market()
	hide_accept_button()
	is_the_buy_button_clicked = false
	tile_grid = null
	disable_accept_button()

func _on_acceptbutton_pressed():	
	if !is_teleport_buying:
		finish_turret_buy()
	else:
		finish_teleport_buy()
	player.get_node("Camera2D").set_zoom(Vector2(1,1))
	$Game_UI/Market_Button.pressed = false
	is_opened_market = false
	is_create_instance = false
	disable_accept_button()	

func countdown_timer():
	countdown_timer.set_one_shot(true)
	countdown_timer.set_wait_time(1)
	add_child(countdown_timer) #to process
	countdown_timer.connect("timeout",self, "_on_count_down_timer_timeout") 
	
func _on_count_down_timer_timeout():
	if is_countdown_pause_timer :
		counttimer = pause_time
		is_countdown_pause_timer = false
	counttimer -= 1
	if  (counttimer < 1):
		counttimer = pause_time
	$Game_UI/CountDownTimer/Time.text = String(counttimer)
	second_passed = true
	
