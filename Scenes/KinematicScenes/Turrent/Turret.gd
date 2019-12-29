extends KinematicBody2D

const turret_bullet = preload("res://Scenes/KinematicScenes/Turrent/TurretBullet/TurretBullet.tscn")
var zombie_has_spotted = false
var zombie_position = Vector2()
var bullet_timer = Timer.new()
var is_shooting_free = true
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
		if "Zombie" in $Base/Top/Radar.get_collider().name:		
			zombie_position = $Base/Top/Radar.get_collider().get_global_position()
			if is_shooting_free:
				bullet_timer.start()
				is_shooting_free = false
		
		
func fire_on_zombie():
	var bullet_instance = turret_bullet.instance()
	add_child(bullet_instance)
	bullet_instance.fire(zombie_position)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	find_any_zombies()
