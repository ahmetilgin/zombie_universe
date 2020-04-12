extends Area2D
var can_create_zombie=true
var punk_zombie = preload("res://Scenes/KinematicScenes/Zombies/PunkZombie/PunkZombie.tscn")
var simple_zombie = preload("res://Scenes/KinematicScenes/Zombies/SimpleZombie/SimpleZombie.tscn")
var stalker_zombie = preload("res://Scenes/KinematicScenes/Zombies/StalkerZombie/StalkerZombie.tscn")
var zombie_level = 1
var generate_zombie_timer = Timer.new()
var generate_wave_timer = Timer.new()
var wave_paused_timer = Timer.new()
var can_wave_come = true
var wave_is_coming = true
var zombie_dead_counter = 0
var wave_zombie_limit 
var zombie_generate_time
var zombie_generate_counter = 0
var wave_is_contiune = false
var wave_time = 10.0
var first_wave_zombie_size = 1
var zombie_types = { 0 : simple_zombie , 
					 1 : stalker_zombie,
					 2 : punk_zombie }
					


signal wave_finished
signal wave_started
func _ready():
	randomize()
	zombie_count_for_level(zombie_level)
	create_generate_wave_timer()
	create_generate_zombie_timer()
	create_wave_paused_timer()#bütün zombieler ölünce yeni dalga gelene kadar bekleme süresi oluşturuldu.


func _process(delta):
	$AnimatedSprite.play("new")
	if wave_is_coming:
		wave_is_contiune = true
		if can_create_zombie:
			generate_zombie_timer.start()
			can_create_zombie = false
	if can_wave_come:
		generate_wave_timer.start()
		can_wave_come = false
	if( zombie_dead_counter == wave_zombie_limit ) and !wave_is_contiune:#!wave_is_contiune ile dalganın başladığını ve olumle doğum eşit olsa bile,yeni dalga oluşturmaması için koyuldu.
		emit_signal("wave_finished")
		wave_is_contiune = true
		zombie_dead_counter = 0
		zombie_generate_counter = 0

	pass

func create_generate_zombie_timer():
	generate_zombie_timer.set_one_shot(true)
	generate_zombie_timer.set_wait_time( zombie_generate_time)
	add_child(generate_zombie_timer) #to process
	generate_zombie_timer.connect("timeout",self, "_on_generate_zombie_timer_timeout") 
	
func create_generate_wave_timer():
	generate_wave_timer.set_one_shot(true)
	generate_wave_timer.set_wait_time(wave_time)
	add_child(generate_wave_timer) #to process
	generate_wave_timer.connect("timeout",self, "_on_generate_wave_timer_timeout") 

func create_wave_paused_timer():
	wave_paused_timer.set_one_shot(true)
	wave_paused_timer.set_wait_time(60)
	add_child(wave_paused_timer) #to process
	wave_paused_timer.connect("timeout",self, "_on_wave_paused_timer_timeout") 

func select_zombie_for_level( _level):
	var zombie_by_level = _level
	return int( floor(randi( ) % ((zombie_by_level / 10) +1 ) ))
	
func zombie_count_for_level(_level):
	var zombie_size_by_level = _level + 1
	wave_zombie_limit = first_wave_zombie_size + zombie_size_by_level
	zombie_generate_time = wave_time / wave_zombie_limit 
	generate_zombie_timer.set_wait_time( zombie_generate_time)

func set_zombie_level(level):
	zombie_level = level

func generate_Zombies():
	var zombie_instance =zombie_types.get( select_zombie_for_level(zombie_level)).instance()
	get_parent().call_deferred("add_child",zombie_instance)
	zombie_instance.set_global_position(Vector2(get_global_position().x,get_global_position().y))
	zombie_instance.connect("dead_counter_for_wave",self,"on_dead_counter_for_wave")
	
func on_dead_counter_for_wave():
	zombie_dead_counter += 1

func _on_generate_zombie_timer_timeout():
	zombie_generate_counter += 1
	can_create_zombie = true
	generate_Zombies()

func _on_generate_wave_timer_timeout():
	wave_is_coming = false
	wave_is_contiune = false
	
func wave_stop():
	wave_paused_timer.start()
	zombie_count_for_level(zombie_level)

func _on_wave_paused_timer_timeout():
	can_wave_come = true
	wave_is_coming = true
	emit_signal("wave_started")
	
