extends Area2D
var can_create_zombie=true
var punk_zombie = preload("res://Scenes/KinematicScenes/Zombies/PunkZombie/PunkZombie.tscn")
var simple_zombie = preload("res://Scenes/KinematicScenes/Zombies/SimpleZombie/SimpleZombie.tscn")
var stalker_zombie = preload("res://Scenes/KinematicScenes/Zombies/StalkerZombie/StalkerZombie.tscn")
var generate_zombie_timer=Timer.new()
var generate_wave_timer=Timer.new()
var can_wave_come=true
func _ready():
	randomize()
	create_generate_wave_timer()
	create_generate_zombie_timer()
	generate_wave_timer.start()
func _process(delta):
	if can_wave_come:
		
		if can_create_zombie:
			generate_zombie_timer.start()
			can_create_zombie=false
	pass

func create_generate_zombie_timer():
	generate_zombie_timer.set_one_shot(true)
	generate_zombie_timer.set_wait_time(2)
	add_child(generate_zombie_timer) #to process
	generate_zombie_timer.connect("timeout",self, "_on_generate_zombie_timer_timeout") 
func create_generate_wave_timer():
	
	generate_wave_timer.set_one_shot(true)
	generate_wave_timer.set_wait_time(40)
	add_child(generate_wave_timer) #to process
	generate_wave_timer.connect("timeout",self, "_on_generate_wave_timer_timeout") 

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
	can_create_zombie=true
	generate_Zombies()


	pass # Replace with function body.
func _on_generate_wave_timer_timeout():
	can_wave_come=false