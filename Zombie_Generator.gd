extends Node
var basic_zombie = preload("res://zombie_scripts/Basic_Zombie.tscn")

func Generate_Zombies(player_position:Vector2):
	var zombie_locations = Array()
	for i in range(0,10):
		var zombie_location = Vector2()
		zombie_location.y = player_position.y
		zombie_location.x = rand_range(player_position.x,player_position.x + 100)
		zombie_locations.append(zombie_location)

	for zombie_location in zombie_locations:
		basic_zombie.instance()
		add_child(basic_zombie)
		basic_zombie._set_zombie_position(zombie_location)

	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
