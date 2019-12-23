extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
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


# Called when the node enters the scene tree for the first time.
func _ready():
	create_turret_attack_timer()
	pass # Replace with function body.

var current_rotation = 0
var rotation_direction = 0.001
func find_any_zombies():
	
	
	if(60 > $Base/Top/Radar.get_global_rotation_degrees() ):
		rotation_direction *= -1
	elif($Base/Top/Radar.get_global_rotation_degrees()  > 120):
		rotation_direction *= -1
	 
	$Base/Top.rotate(rotation_direction)
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
