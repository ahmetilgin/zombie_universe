extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var portal_scene = preload("res://Scenes/StaticScenes/ZombiePortal/ZombiePortal.tscn")
var finish_portal = 0
signal stop_wave
var start_portal = 2
var portal_list = []
var portal_coordinates = [Vector2(9,2),Vector2(9,4),Vector2(9,6),Vector2(28,2), Vector2(28,4), Vector2(28,6)]
func create_portals(portal_count):
	for portal in portal_list:
		portal.queue_free()
	for i in range(0,portal_count):
		var portal = portal_scene.instance()
		add_child(portal)
		
		portal.connect("wave_finished",self, "wave_finish")
		var portal_coordinate = randi() % portal_coordinates.size()
		var pixel_coordinate = $TileMap.map_to_world(portal_coordinates[portal_coordinate])
		portal.set_global_position(pixel_coordinate + $TileMap.cell_size / 2)
		portal_coordinates.erase(portal_coordinates[portal_coordinate])
		portal_list.push_back(portal)
	pass # Replace with function body.
	
	
func get_tile_borders():
	max_border = get_node("TileMap").get_max_border()
	min_border = get_node("TileMap").get_min_border()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	
	create_portals(start_portal)
	get_tile_borders()
	market_button_create()
	on_market_button_unvisible()
	
func market_button_create():
	var portal = portal_scene.instance()
	add_child(portal)
	portal.connect("market_button_visible",self, "on_market_button_visible")
	portal.connect("market_button_unvisible",self, "on_market_button_unvisible")
	pass
func on_market_button_visible():
	$Game_UI/Market_Button.disabled = false
	pass
func on_market_button_unvisible():
	$Game_UI/Market_Button.disabled = true
	$Market.set_offset(Vector2(-420,0))
	hide_grid()
	is_opened_market = false
	pass
func _process(delta):
	pass

func wave_finish():
	finish_portal += 1
	if start_portal ==finish_portal:
		finish_portal = 0
		emit_signal("stop_wave")
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
	else:
		hide_grid()







func _on_TouchScreenButton_pressed():
	if !is_opened_market:
		$Market.set_offset(Vector2(-5,0))
	else:
		$Market.set_offset(Vector2(-420,0))
	is_opened_market = !is_opened_market
	update()
	pass # Replace with function body.
