extends Node2D

onready var level_text_counter = get_node("Game_UI/level_text/level_counter")
onready var level_text = get_node("Game_UI/level_text")
var portal_scene = preload("res://Scenes/StaticScenes/ZombiePortal/ZombiePortal.tscn")
var finish_portal = 0
signal stop_wave
signal camera_zoom_out
signal camera_zoom_in
var start_portal = 2
var portal_list = []
var game_level = 1
var portal_coordinates = [Vector2(9,2),Vector2(9,4),Vector2(9,6),Vector2(28,2), Vector2(28,4), Vector2(28,6)]
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

func item_solded(selected_item_price, selected_item):
	$Game_UI/Coin_Counter.decrease_coins(selected_item_price)
	$Game_UI/SelectPositionLabel.set_visible(true)
	hide_market()
	var created_turret = selected_item.instance()
	add_child(created_turret)
	pass

func connect_market():
	$Market.connect("item_sold",self, "item_solded")

func _ready():
	create_portals(start_portal)
	get_tile_borders()
	on_market_button_unvisible()
	connect_market()
	$Game_UI/SelectPositionLabel.set_visible(false)

func on_market_button_visible():
	$Game_UI/Market_Button.disabled = false
	pass
func hide_market():
	$Market.set_offset(Vector2(-420,0))

func show_market():
	$Market.set_offset(Vector2(-5,0))
	
func on_market_button_unvisible():
	$Game_UI/Market_Button.disabled = true
	hide_market()
	$player/Camera2D.current = true
	hide_grid()
	is_opened_market = false
	pass
	
func _process(delta):
	pass

func show_current_level():
	level_text_counter.add_color_override("default_color", Color(1,1,1))
	level_text.add_color_override("default_color", Color(1,1,1))
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
	pass

var max_border = Vector2()
var min_border = Vector2()
var is_opened_market = false

func show_grid():
	for i in range(min_border.x, max_border.x):
		for j in range(min_border.y, max_border.y):
			if get_node("TileMap").get_cell(i,j) == -1 and get_node("TileMap").get_cell(i,j+1) != -1: 				
				get_node("TileMap").set_cellv(Vector2(i,j),9)
			pass

func hide_grid():
	for i in range(min_border.x, max_border.x):
		for j in range(min_border.y, max_border.y):
			if get_node("TileMap").get_cell(i,j) == 9:				
				get_node("TileMap").set_cellv(Vector2(i,j),-1)
			pass

func _draw():
	if is_opened_market:
		show_grid()
		$GameAreaCam.current = true
	else:
		hide_grid()
		$player/Camera2D.current = true

func _on_TouchScreenButton_pressed():
	if !is_opened_market:
		show_market()
	else:
		hide_market()
	is_opened_market = !is_opened_market
	update()
	pass # Replace with function body.

var started_wave_count = 0
func wave_started():
	started_wave_count += 1
	if start_portal == started_wave_count:
		on_market_button_unvisible()
		pass
		
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			var pos = get_global_mouse_position()
			var tile_pos = get_node("TileMap").world_to_map(pos)
			print(tile_pos)
			$TileMap.set_cell(tile_pos.x ,tile_pos.y, 1)