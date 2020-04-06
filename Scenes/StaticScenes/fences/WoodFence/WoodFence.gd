extends KinematicBody2D

var zombie_has_spotted = false
var is_shooting_free = true
var fence_health = 100
var zombie_attack_timer = Timer.new()
var zombie_attack_power = 0
var flash_fence_tween = Tween.new()
var flash_color = Color.red 
const FLASH_RATE =0.05
const N_FLASHES = 4

var healt_perfect = null
var healt_caution = null
var healt_danger = null
func change_fence_health(health):
	zombie_attack_power = health
	if(zombie_attack_timer.is_stopped()):
		zombie_attack_timer.start()
	 
		 
	pass
func flash_fence_tween():
	add_child(flash_fence_tween)
	
 
func create_zombie_attack_timer():
	zombie_attack_timer.set_one_shot(true)
	zombie_attack_timer.set_wait_time(0.75)
	add_child(zombie_attack_timer) #to process
	zombie_attack_timer.connect("timeout",self, "_zombie_attack") 	



func _ready():
	$WoodFenceBack.play("idle")
	$WoodFenceFront.play("idle")
	create_zombie_attack_timer()
	flash_fence_tween()
 
	 
	healt_perfect= true
	healt_caution = true
	healt_danger = true
	
	pass # Replace with function body.

var current_rotation_degree = 0.1
var rotation_angle = 300
var rotation_angle_count = 0
# 30 kez + yönde 1 derece döndür 30 kez - yönde -1 derece döndür
 
 
func _zombie_attack():
	fence_health = fence_health + zombie_attack_power
	flash_damage()
	healt_color()
	if(fence_health <= 0):
		queue_free()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func healt_color():
	
	if  fence_health > 75  and healt_perfect :
		$WoodFenceBack.play("damage1")
		$WoodFenceFront.play("damage1")
 
		healt_perfect = false
	 
	elif fence_health < 75 and fence_health > 35 and healt_caution:
		$WoodFenceBack.play("damage2")
		$WoodFenceFront.play("damage2")
 
		healt_caution = false
	 
	elif  fence_health < 35   and healt_danger:
		$WoodFenceBack.play("damage3")
		$WoodFenceFront.play("damage3")
 
		healt_danger = false
 
	
 
func flash_damage():
	for i in range(N_FLASHES * 2):
		var color = $WoodFenceBack.modulate if i % 2 == 1 else  flash_color
		var color2 = $WoodFenceFront.modulate if i % 2 == 1 else  flash_color
		var time = FLASH_RATE * i +FLASH_RATE
		flash_fence_tween.interpolate_callback($WoodFenceBack,time, "set", "modulate", color)
		flash_fence_tween.interpolate_callback($WoodFenceFront,time, "set", "modulate", color2)
	flash_fence_tween.start()
	
 
