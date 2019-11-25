extends Node2D

var punk_zombie = preload("res://Resources/Punk_Zombie.tscn")
var basic_zombie = preload("res://Resources/Basic_Zombie.tscn")
var big_zombie = preload("res://Resources/Big_Zombie.tscn")
var coin = preload("res://Resources/Coin.tscn")
onready var player = get_parent().get_node("player")
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
	randomize()
	calculate_bounds()
	generate_Zombies()
	generate_coins()

func generate_coins():
	var rand_list = []
	for i in range(0,10):
		var coin_instance = coin.instance()
		var dir = -1
		if (randi() % 2) == 1:
			dir = 1
		
		var rand_pos = randi() % 10
		if not (rand_pos in rand_list):
			rand_list.append(rand_pos)
		
		coin_instance.set_global_position(Vector2(dir*player.get_global_position().x+(rand_pos* 10),player.get_global_position().y + dir * 10))
		get_parent().call_deferred("add_child",coin_instance)

func generate_Zombies():
	for i in range(0,5):
		var zombie_instance = null
		var select_zombie = randi() % 3 
		if select_zombie == 0:
			zombie_instance = basic_zombie.instance()
		elif select_zombie == 1:
			zombie_instance = big_zombie.instance()
		else: 
			zombie_instance = punk_zombie.instance()
		var new_location = Vector2((randi() % (20 * max_x)) + (10 * min_x) ,  min_y - 100)
		get_parent().call_deferred("add_child",zombie_instance)
		zombie_instance.set_global_position((new_location) + Vector2(1000,-500))
	pass # Replace with function body.

