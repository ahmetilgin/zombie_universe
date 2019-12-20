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
	
# Called when the node enters the scene tree for the first time.
func _ready():
	create_portals(start_portal)

func _process(delta):
	
	pass

func wave_finish():
	finish_portal += 1
	if start_portal ==finish_portal:
		finish_portal = 0
		emit_signal("stop_wave")
	pass
