extends Area2D

var punk_zombie = preload("res://Scenes/KinematicScenes/Zombies/PunkZombie/PunkZombie.tscn")
var simple_zombie = preload("res://Scenes/KinematicScenes/Zombies/SimpleZombie/SimpleZombie.tscn")
var stalker_zombie = preload("res://Scenes/KinematicScenes/Zombies/StalkerZombie/StalkerZombie.tscn")
 
func _ready():
	randomize()
 
	




func generate_Zombies():

	var zombie_instance = null
	var select_zombie = randi() % 3 
	if select_zombie == 0:
		zombie_instance = simple_zombie.instance()
	elif select_zombie == 1:
		zombie_instance = punk_zombie.instance()
	else: 
		zombie_instance = stalker_zombie.instance()
		
	get_parent().call_deferred("add_child",zombie_instance)
	zombie_instance.set_global_position(Vector2(get_global_position().x,get_global_position().y))
	pass # Replace with function body.



func _on_generate_zombie_timer_timeout():
	generate_Zombies()

	pass # Replace with function body.
