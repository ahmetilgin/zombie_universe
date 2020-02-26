extends KinematicBody2D

const turret_bullet = preload("res://Scenes/KinematicScenes/Turrent/TurretBullet/TurretBullet.tscn")
var zombie_has_spotted = false
var zombie_position = Vector2()
var bullet_timer = Timer.new()
var is_shooting_free = true
var turret_health = 100
var zombie_attack_timer = Timer.new()
var zombie_attack_power = 0
var change_color_tween= Tween.new()
var damage_healt_color_timer= Timer.new()
var healt_75 = null
var healt_50 = null
var healt_25 = null
func change_turret_health(health):
	zombie_attack_power = health
	if(zombie_attack_timer.is_stopped()):
		zombie_attack_timer.start()
	else :
		zombie_attack_timer.start()
	pass
func color_change_tween():
	add_child(change_color_tween) #to process
 

func damage_healt_color_timer():
	damage_healt_color_timer.set_one_shot(true)
	damage_healt_color_timer.set_wait_time(0.1)
	add_child(damage_healt_color_timer) #to process
	damage_healt_color_timer.connect("timeout",self, "on_damage_healt_color_timer") 	

 
func create_zombie_attack_timer():
	zombie_attack_timer.set_one_shot(true)
	zombie_attack_timer.set_wait_time(0.25)
	add_child(zombie_attack_timer) #to process
	zombie_attack_timer.connect("timeout",self, "_zombie_attack") 	

func create_turret_attack_timer():
	bullet_timer.set_one_shot(true)
	bullet_timer.set_wait_time(0.1)
	add_child(bullet_timer) #to process
	bullet_timer.connect("timeout",self, "_fire_bullet") 	

func _fire_bullet():
	is_shooting_free = true
	fire_on_zombie()

func _ready():
	create_turret_attack_timer()
	create_zombie_attack_timer()
	damage_healt_color_timer()
	color_change_tween()
	healt_75 = true
	healt_50 = true
	healt_25 = true
	
	pass # Replace with function body.

var current_rotation_degree = 0.1
var rotation_angle = 300
var rotation_angle_count = 0
# 30 kez + yönde 1 derece döndür 30 kez - yönde -1 derece döndür
func find_any_zombies():
	if is_shooting_free:
		if rotation_angle_count < rotation_angle:
			rotation_angle_count += 1
		else:
			current_rotation_degree = -1 * current_rotation_degree
			rotation_angle_count = 0
			
		$Base/Top.rotate(deg2rad(current_rotation_degree))
		
	if $Base/Top/Radar.is_colliding():
	
		if $Base/Top/Radar.get_collider() != null:
			if "Zombie" in $Base/Top/Radar.get_collider().name:		
			
				zombie_position = $Base/Top/Radar.get_collider().get_global_position()
				if is_shooting_free:
					bullet_timer.start()
					is_shooting_free = false
		
		
func fire_on_zombie():
	var bullet_instance = turret_bullet.instance()
	add_child(bullet_instance)
	bullet_instance.fire(zombie_position)
	
func _zombie_attack():
	turret_health = turret_health + zombie_attack_power
	$TurretHealth.set_value(turret_health)
	damage_healt_color_timer.start()
	healt_color()
	if(turret_health <= 0):
		queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	find_any_zombies()
	
func healt_color():
	
	if turret_health < 75 and turret_health > 75  and healt_75 :
		change_color_tween.interpolate_property($TurretHealth,'modulate',Color(0,1,0,1),
								Color(0,0.8,0,1),0.5,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		healt_75 = false
	 
	elif turret_health < 75 and turret_health > 25 and healt_50:
		change_color_tween.interpolate_property($TurretHealth,'modulate',Color(0,8,0,1),
								Color(1,1,0,1),0.5,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		healt_50 = false
	 
	elif  turret_health < 25   and healt_25:
		change_color_tween.interpolate_property($TurretHealth,'modulate',Color(1,1,0,1),
								Color(1,0,0,1),0.5,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		healt_25 = false
	change_color_tween.start()
	yield(change_color_tween, "tween_completed")
	
func on_damage_healt_color_timer():
	$TurretHealthBack.set_value(turret_health)
	pass
