extends Node2D

var basic_zombie = preload("res://zombie_scripts/Punk_Zombie.tscn")
onready var tilemap = get_parent().get_node("TileMap")
var max_x = 0
var min_x = 0
var max_y = 0
var min_y = 0

func calculate_bounds():
	var used_cells = tilemap.get_used_cells()
	for pos in used_cells:
        if pos.x < min_x:
            min_x = int(pos.x)
        elif pos.x > max_x:
            max_x = int(pos.x)
        if pos.y < min_y:
            min_y = int(pos.y)
        elif pos.y > max_y:
            max_y = int(pos.y)

		

func _ready():
	calculate_bounds()
	generate_Zombies()

func generate_Zombies():
	for i in range(0,10):
		var zombie_instance = basic_zombie.instance()
		var new_location = Vector2((randi() % (10 * max_x)) + (10 * min_x) ,  min_y - 100)
		print(new_location)
		get_parent().call_deferred("add_child",zombie_instance)
		zombie_instance.position  = (new_location) + Vector2(1000,-500)
	pass # Replace with function body.

