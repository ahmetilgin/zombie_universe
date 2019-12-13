extends Area2D
var can_create_zombie=true
var punk_zombie = preload("res://Scenes/KinematicScenes/Zombies/PunkZombie/PunkZombie.tscn")
var simple_zombie = preload("res://Scenes/KinematicScenes/Zombies/SimpleZombie/SimpleZombie.tscn")
var stalker_zombie = preload("res://Scenes/KinematicScenes/Zombies/StalkerZombie/StalkerZombie.tscn")
var generate_zombie_timer=Timer.new()
var generate_wave_timer=Timer.new()
var wave_paused_timer=Timer.new()
var can_wave_come=true
var wave_is_coming=true
var zombie_dead_counter=0
var zombie_generate_counter=0
var wave_is_contiune=false
var zombie_level=1
var wave_time_max_limit=10.0

func _ready():
	randomize()
	create_generate_wave_timer()
	create_generate_zombie_timer()
	create_wave_paused_timer()#bütün zombieler ölünce yeni dalga gelene kadar bekleme süresi oluşturuldu.

func _process(delta):
	
	$AnimatedSprite.play("move")
	if wave_is_coming:
		wave_is_contiune=true
		if can_create_zombie:
			generate_zombie_timer.start()
			can_create_zombie=false
	if can_wave_come:
		generate_wave_timer.start()
		can_wave_come=false
	if( zombie_dead_counter==zombie_generate_counter ) and !wave_is_contiune:#!wave_is_contiune ile dalganın başladığını ve olumle doğum eşit olsa bile,yeni dalga oluşturmaması için koyuldu.
		wave_paused_timer.start()
		wave_is_contiune=true
	pass

func create_generate_zombie_timer():
	generate_zombie_timer.set_one_shot(true)
	generate_zombie_timer.set_wait_time( 10)
	add_child(generate_zombie_timer) #to process
	generate_zombie_timer.connect("timeout",self, "_on_generate_zombie_timer_timeout") 
	
func create_generate_wave_timer():
	
	generate_wave_timer.set_one_shot(true)
	generate_wave_timer.set_wait_time(10)
	add_child(generate_wave_timer) #to process
	generate_wave_timer.connect("timeout",self, "_on_generate_wave_timer_timeout") 

func create_wave_paused_timer():
	
	wave_paused_timer.set_one_shot(true)
	wave_paused_timer.set_wait_time(10)
	add_child(wave_paused_timer) #to process
	wave_paused_timer.connect("timeout",self, "_on_wave_paused_timer_timeout") 
func select_zombie_for_level( _level):
	var zombie_by_level = _level
	if zombie_by_level < 10:
		zombie_by_level = 0
	elif zombie_by_level < 20:
		zombie_by_level = randi() % 2
	elif zombie_by_level < 30:
		zombie_by_level = randi() % 3
	return zombie_by_level
func zombie_count_for_level(_level):
	var zombie_time_by_level = _level
	var wave_time_limit = null
	
	wave_time_limit = wave_time_max_limit / zombie_time_by_level * 2
	generate_zombie_timer.set_wait_time( wave_time_limit)


func generate_Zombies():

	var zombie_instance = null
	
	var select_zombie = select_zombie_for_level(zombie_level)
	if select_zombie == 0:
		zombie_instance = simple_zombie.instance()
	elif select_zombie == 1:
		zombie_instance = stalker_zombie.instance()
	else: 
		zombie_instance = punk_zombie.instance()
		
	get_parent().call_deferred("add_child",zombie_instance)
	zombie_instance.set_global_position(Vector2(get_global_position().x,get_global_position().y))
	zombie_instance.connect("dead_counter_for_wave",self,"on_dead_counter_for_wave")
	pass # Replace with function body.
func on_dead_counter_for_wave():
	zombie_dead_counter += 1


func _on_generate_zombie_timer_timeout():
	zombie_generate_counter += 1
	can_create_zombie=true
	generate_Zombies()


	pass # Replace with function body.
func _on_generate_wave_timer_timeout():
	wave_is_coming=false
	wave_is_contiune=false
	zombie_level += 1
	
	
func _on_wave_paused_timer_timeout():
		can_wave_come=true
		wave_is_coming=true