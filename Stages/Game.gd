extends Node2D
var turret_grid 

onready var level_text_counter = get_node("Game_UI/level_text/level_counter")
onready var level_text = get_node("Game_UI/level_text")
var portal_scene = preload("res://Scenes/StaticScenes/ZombiePortal/ZombiePortal.tscn")
var player_scene = preload("res://Scenes/KinematicScenes/Player/Player.tscn")
var gameover_scene = preload("res://Scenes/Screens/GameOverScreen/GameoverScreen.tscn")
var constants = preload("res://Stages/constants.gd").new()
var player = null

var finish_portal = 0
signal stop_wave
signal camera_zoom_out
signal camera_zoom_in
var start_portal = 1
var portal_list = []
var is_the_buy_button_clicked = false
var sales_successful = false
var created_turret 
var turret_instance
var created_turret_price
var game_level = 1
var tile_pos
var sales_fail = false
var is_create_instance = false
var tile_grid 
var countdown_timer = Timer.new()
var is_countdown_pause_timer = false
var pause_time = 19
var counttimer
var second_passed = true
var portal_coordinates = [Vector2(9,2),Vector2(9,4),Vector2(9,6)]

var walls = {
	401: preload("res://Scenes/StaticScenes/Trambolin/Trambolin.tscn"),
	402: preload("res://Scenes/StaticScenes/Trambolin/Trambolin.tscn"),
	403: preload("res://Scenes/StaticScenes/Trambolin/Trambolin.tscn"),
	404: preload("res://Scenes/StaticScenes/Trambolin/Trambolin.tscn")
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
		add_child(portal)
		portal.connect("wave_finished",self, "wave_finish")
		portal.connect("wave_started",self, "wave_started")
		var portal_coordinate = randi() % portal_coordinates.size()
		var pixel_coordinate = $TileMap.map_to_world(portal_coordinates[portal_coordinate])
		portal.set_global_position(pixel_coordinate + $TileMap.cell_size / 2)
		portal_coordinates.erase(portal_coordinates[portal_coordinate])
		portal_list.push_back(portal)
	pass # Replace with function body.
	
func get_tile_borders():
	max_border = get_node("TileMap").get_max_border()
	min_border = get_node("TileMap").get_min_border()

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
	if item_id == 101 or item_id == 102 or item_id == 103 :
		buy_bullet(item_id)
		pass
	elif item_id == 104:
		buy_health()
		pass
	elif item_id == 106:
		buy_ammo()
	pass

func buy_wall(item_id):
	create_wall_instance(item_id)
	pass

func buy_portal(item_id):
	pass
	
func show_select_position(is_visible):
	$Game_UI/SelectPositionLabel.set_visible(is_visible)
	$Game_UI/accept_button.set_visible(is_visible)


func buy_turret(item_id):
	created_turret_price = constants.items[item_id][1]
	hide_market()
	show_select_position(true)
	create_instance(item_id)
	turret_instance.show_rotations()
	pass
	
func item_solded(item_id):
	is_the_buy_button_clicked = true
	var item_type = int(item_id / 10) * 10
	if item_type == 100:
		buy_player_item(item_id)
		pass
	elif item_type == 400:
		buy_wall(item_id)
		pass
	elif item_type == 500:
		buy_portal(item_id)
		pass
	elif item_type == 800:
		buy_turret(item_id)
		pass
	else:
		print("Satın Alma Arızası")


func connect_market():
	$Market.connect("item_sold",self, "item_solded")

func item_solded_failed():
	is_the_buy_button_clicked = false
	sales_fail = true

func _ready():
	player = player_scene.instance()
	create_portals(start_portal)
	get_tile_borders()
	connect_market()
	countdown_timer()
	$Game_UI/SelectPositionLabel.set_visible(false)
	add_child(player)
	get_node("CanvasLayer").add_child(gameover_scene.instance())
	on_market_button_unvisible()
	on_time_countdown_unvisible()

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
	turret_cancelled()
	
func show_market():
	$Market.set_offset(Vector2(0,0))
	$Game_UI/accept_button.set_visible(true)
	
	
func on_market_button_unvisible():
	$Game_UI/Market_Button.disabled = true
	is_not_accept_button_set_visible()
	hide_market()
	$player/Camera2D.current = true
	
	hide_grid()
	is_opened_market = false
	pass
	
func _process(delta):
	if second_passed and $Game_UI/CountDownTimer.visible :
		countdown_timer.start()
		second_passed = false
	pass

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
		on_market_button_visible()
		on_time_countdown_visible()
	pass

var max_border = Vector2()
var min_border = Vector2()
var is_opened_market = false

func show_grid():
	for i in range(min_border.x, max_border.x):
		for j in range(min_border.y, max_border.y):
			if get_node("TileMap").get_cell(i,j) == -1 and get_node("TileMap").get_cell(i,j+1) != -1: 				
				get_node("TileMap").set_cellv(Vector2(i,j),14)
				
			pass

func hide_grid():
	for i in range(min_border.x, max_border.x):
		for j in range(min_border.y, max_border.y):
			if get_node("TileMap").get_cell(i,j) == 14:				
				get_node("TileMap").set_cellv(Vector2(i,j),-1)
			pass

func _draw():
	if is_opened_market:
		show_grid()
		$GameAreaCam.current = true
	else:
		hide_grid()
		$player/Camera2D.current = true
		is_not_accept_button_set_visible()
		
func is_not_accept_button_set_visible():
	$Game_UI/accept_button.set_visible(false)
	is_the_buy_button_clicked = false
	
func _on_TouchScreenButton_pressed():
	if !is_opened_market:
		show_market()
	else:
		hide_market()
	is_opened_market = !is_opened_market
	update()
	pass # Replace with function body.
	
func turret_cancelled():
	if is_create_instance :
		if !sales_successful:
			$Game_UI/Coin_Counter.increase_coins(created_turret_price)
			turret_instance.queue_free()
		else:
			sales_successful = false
		
		is_create_instance = false

var started_wave_count = 0

func wave_started():
	started_wave_count += 1
	if start_portal == started_wave_count:
		started_wave_count = 0
		on_market_button_unvisible()
		on_time_countdown_unvisible()
		show_current_start_level()
		if is_item_solded_failed() :
			item_solded_failed()
		pass
		
func is_item_solded_failed():
	return is_the_buy_button_clicked
	
func _unhandled_input(event):
	if event is InputEventMouseButton :
		if event.pressed:
			var pos = get_global_mouse_position()
			tile_grid = get_node("TileMap").world_to_map(pos)
			select_turret_position()
			
func select_turret_position():
	if  get_node("TileMap").get_cell(tile_grid.x,tile_grid.y) == 14   and is_the_buy_button_clicked:
		turret_grid =tile_grid
		if is_create_instance   and( sales_fail ):
			sales_fail = false
			if !sales_successful:
				$Game_UI/Coin_Counter.increase_coins(created_turret_price)
			else:
				sales_successful = false
			is_create_instance = false
		if is_create_instance:
			tile_pos =  get_node("TileMap").map_to_world(tile_grid)
			turret_instance.set_global_position(Vector2(tile_pos.x + 32,tile_pos.y ) )
			
func create_instance(turret):
	turret_instance = turret_paths[turret].instance()
	is_create_instance = true
	add_child(turret_instance)
	
func create_wall_instance(wall):
	turret_instance = walls[wall].instance()
	is_create_instance = true
	add_child(turret_instance)
	

func _on_acceptbutton_pressed():
	sales_successful = true
	turret_instance.hide_rotations()
	pass # Replace with function body.


func countdown_timer():
	countdown_timer.set_one_shot(true)
	countdown_timer.set_wait_time( 1 )
	add_child(countdown_timer) #to process
	countdown_timer.connect("timeout",self, "_on_count_down_timer_timeout") 
	
func _on_count_down_timer_timeout():
	if is_countdown_pause_timer :
		counttimer = pause_time
		is_countdown_pause_timer = false
	counttimer -= 1
	if  (counttimer < 0):
		counttimer = pause_time
	$Game_UI/CountDownTimer/Time.text = String(counttimer)
	second_passed = true
