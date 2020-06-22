extends KinematicBody2D
var target_point_world = Vector2()
var FollowPlayerTimer = Timer.new()
var player = null
var tile_map = null
var coin = preload("res://Scenes/StaticScenes/Coin/Coin.tscn")
var extra_bullet = preload("res://Scenes/StaticScenes/ExtraBullet/ExtraBullet.tscn")

var zombie_hurt_player = AudioStreamPlayer.new()
var zombie_dead_player = AudioStreamPlayer.new()
var zombie_hurt_sound = load("res://Resources/AudioFiles/Zombies/zombies/zombie2.wav")
var zombie_dead_sound = load("res://Resources/AudioFiles/Zombies/zombies/zombie21.wav")
var zombie_dead_timer = Timer.new()
var can_zombie_attack = true
var zombie_attack_timer = Timer.new()
var attack_ray_cast = RayCast2D.new()
var player_found_icon = TextureRect.new()
const gravity=20
const one_grid_jump_value = -462
var jumping_started = false
var jumping_peak = false
const FLASH_RATE =0.05
const N_FLASHES = 4
var flash_zombie_tween = Tween.new()

export (int) var hp=5
export (int) var speed=150
var motion=Vector2(0,0)
const UP=Vector2(0,-1)
var is_dead=false
var is_hurt=false
var acceleration = 20
var is_follow = false
var path = []
signal dead_counter_for_wave
var is_borned = false

func add_attack_ray_cast():
#	attack_ray_cast.set_position(Vector2(64,64))
	add_child(attack_ray_cast)
	attack_ray_cast.set_cast_to(Vector2(65,0))
	attack_ray_cast.set_position(Vector2(0,0))
	attack_ray_cast.set_enabled(true)

func create_zombie_follow_timer():
	FollowPlayerTimer.connect("timeout",self,"_on_FollowPlayerTimer_timeout") 
	add_child(FollowPlayerTimer) #to process
	FollowPlayerTimer.set_wait_time(0.01)
	FollowPlayerTimer.start() #to start

func add_zombie_sounds():
	zombie_dead_player.set_stream(zombie_dead_sound)
	zombie_hurt_player.set_stream(zombie_hurt_sound)
	zombie_hurt_player.volume_db = 1
	zombie_hurt_player.pitch_scale = 1
	zombie_dead_player.volume_db = 1
	zombie_dead_player.pitch_scale = 1	
	add_child(zombie_dead_player)
	add_child(zombie_hurt_player)

func create_zombie_dead_timer():
	zombie_dead_timer.set_one_shot(true)
	zombie_dead_timer.set_wait_time(2)
	add_child(zombie_dead_timer) #to process
	zombie_dead_timer.connect("timeout",self, "_zombie_dead_timer_timeout") 
	
func flash_zombie_tween():
	add_child(flash_zombie_tween)
	
func create_zombie_attack_timer():
	zombie_attack_timer.set_one_shot(true)
	zombie_attack_timer.set_wait_time(1)
	add_child(zombie_attack_timer) #to process
	zombie_attack_timer.connect("timeout",self, "_zombie_attack_timer_timeout") 

func create_zombie_found_player_label():
	pass
#	var stream_texture = load("res://Resources/Sprites/WarningIcon/warning.png")
#	var image_texture = ImageTexture.new()
#	var image = stream_texture.get_data()
#	image_texture.create_from_image(image, 0)
#	var textureRect = TextureRect.new()
#	textureRect.texture = image_texture
#	image_texture.set_size_override(Vector2(20,20))
#	image.resize (20,20)
#	textureRect.set_size(Vector2(20,20))
#	add_child(textureRect)

func _ready():
	var tile_map_root = get_parent()
	tile_map = tile_map_root.get_node("TileMap")
	player = tile_map_root.get_parent().get_node("player")
	$AnimatedSprite.play("default")
	add_zombie_sounds()
	create_zombie_dead_timer()
	create_zombie_follow_timer()
	create_zombie_attack_timer()
	add_attack_ray_cast()
	flash_zombie_tween()

func get_zombie_and_player_distance():
	return player.get_global_position().distance_to(get_global_position())

func find_zombie_x_movement():
	$AnimatedSprite.play("run")
	var diffx = (target_point_world.x - tile_map.get_closest_point(get_global_position()).x)
	if diffx > 0 :
		motion.x = min(motion.x + acceleration, speed)
	elif diffx < 0:
		motion.x = max(motion.x - acceleration, -speed)

func can_zombie_jump(jump_diff):
	$AnimatedSprite.play("jump")
	if is_on_floor() and jump_diff.y < 0:
		motion.y = jump_grid_calculator(jump_diff.y)

func jump_grid_calculator(_jump_diff):
	var how_much_grid = -_jump_diff / (tile_map._half_cell_size.y * 2)
	var delta_sqrt = 1 - (4 * one_grid_jump_value * how_much_grid)
	var square_root = (-1 + sqrt(delta_sqrt)) / 2
	return -(square_root * gravity)

func find_cross_index():
	var cross_index = 0
	if len(path) > 2:
		for i in range(0,len(path) - 1):
			if path[i].x == path[i + 1].x and path[i].y != path[i + 1].y:
				cross_index = i
			else:
				break
	return cross_index

func check_zombie_found_player():
	if get_zombie_and_player_distance() < 80:
		if !FollowPlayerTimer.is_stopped():
			FollowPlayerTimer.stop()
			path = []
	else:
		if FollowPlayerTimer.is_stopped():
			FollowPlayerTimer.start()

func set_zombie_direction():
	if !jumping_peak:
		if sign(motion.x) < 0:
			$AnimatedSprite.flip_h = true
			attack_ray_cast.set_cast_to(Vector2(-65,0))
		elif sign(motion.x) > 0:
			$AnimatedSprite.flip_h = false
			attack_ray_cast.set_cast_to(Vector2(65,0))
				 
var is_zombie_action = false
func follow_path():
	if !is_zombie_action:
		check_zombie_found_player()

var init = false
func _get_path():
	var new_path = tile_map._get_path(get_global_position(), player.get_node("CenterPos").get_global_position(),get_name())
	if len(new_path) > 0:
		path = new_path
			
	var closest_point = tile_map.get_closest_point(get_global_position())
	var targetDiff = (target_point_world - closest_point)
	if(len(path) > 1):
		target_point_world = path[1]

	tile_map.set_target_point(target_point_world)
	
	if (targetDiff.y >= 0) and !jumping_peak:
		if !$RayCast2D.is_colliding() and targetDiff.y == 0 and !jumping_started:
			motion.y = -700
			print("asdasds")
		find_zombie_x_movement()
		pass
	else:
		motion.x = 0
		if($Timer.is_stopped()) and is_on_floor():
			$Timer.start()

func _set_is_follow(follow):
	is_follow = follow
	
func generate_coins():
	var coin_instance = coin.instance()
	coin_instance.set_global_position(Vector2(get_global_position().x + 64,get_global_position().y + 64))
	get_parent().call_deferred("add_child",coin_instance)
	
func generate_extra_bullet():
	var extra_bullet_instance = extra_bullet.instance()
	extra_bullet_instance.set_global_position(Vector2(get_global_position().x + 64,get_global_position().y + 64))
	get_parent().call_deferred("add_child",extra_bullet_instance)

func create_extra_resources():
	var power_up = randi() % 4 
	if power_up == 0 or power_up == 2 or power_up == 3:
		generate_coins()
	elif power_up == 1:
		generate_extra_bullet()
		
func dead(damage,whodead):
	hp-=damage
	flash_damage()
	if hp < 0 and !is_dead:
		is_dead=true
		if whodead=="player":
			player.increase_dead_counter()
		zombie_dead_player.play()
		motion=Vector2(0,0)
		$AnimatedSprite.play("dead")
		$CollisionShape2D.set_deferred("disabled",true)
		zombie_dead_timer.start()
	else:
		var back = 0;
		if player.get_global_position().x < get_global_position().x:
			back = 400
		else:
			back = -400
		motion = move_and_slide(Vector2(motion.x + back, motion.y) , UP)
		
func dead_from_turrent(damage,whodead,dir):
	hp-=damage
	flash_damage()
	if hp<0:
		if whodead=="player":
			player.increase_dead_counter()
		is_dead=true
		zombie_dead_player.play()
		motion=Vector2(0,0)
		$AnimatedSprite.play("dead")
		$CollisionShape2D.set_deferred("disabled",true)
		zombie_dead_timer.start()
	else:
#		is_hurt=true
#		zombie_hurt_player.play()
		var back = 0;
		if get_parent().get_node(whodead).get_global_position().x > get_global_position().x:
			back = 400
		else:
			back = -400
		motion = move_and_slide(Vector2(dir.x*(motion.x + back), dir.y*(motion.y + back) - gravity) , UP)	

func chech_zombie_colliding():
	is_zombie_action = false
	if attack_ray_cast.is_colliding():
		var playerFound = false
		if "player" in attack_ray_cast.get_collider().name:
			playerFound = true
			_zombie_attack_to_player(5)
			is_zombie_action = true
		elif "Top"  in attack_ray_cast.get_collider().name:
			$AnimatedSprite.play("attack")
			var colliding_turret = attack_ray_cast.get_collider().get_parent().get_parent()
			colliding_turret.change_turret_health(-20)
			is_zombie_action = true
		elif "Turret"  in attack_ray_cast.get_collider().name:
			$AnimatedSprite.play("attack")
			var colliding_turret = attack_ray_cast.get_collider()
			colliding_turret.change_turret_health(-20)
			is_zombie_action = true
		elif  "Fence"in attack_ray_cast.get_collider().name:
			$AnimatedSprite.play("attack")
			var colliding_fence = attack_ray_cast.get_collider() 
			colliding_fence .change_fence_health(-20)
			is_zombie_action = true
		elif  "Zombie" in attack_ray_cast.get_collider().name:
			var colliding_zombie = attack_ray_cast.get_collider()
			var back = 0;
			if colliding_zombie.get_global_position().x > get_global_position().x:
				back = 15
			else:
				back = -15
			colliding_zombie.motion += Vector2(back, 0)
		elif "Trambolin" in attack_ray_cast.get_collider().name:
			motion.y -= 100



func find_zombie_jump_on_peak():

	if !is_on_floor(): 
		pass
	var diff = (target_point_world - get_global_position())
	if jumping_started and !jumping_peak:
		motion.x =lerp(0,diff.x + ((diff.x / abs(diff.x) * speed)),1)
		
func _physics_process(delta):
	if !is_borned:
		return
	set_zombie_direction()
	motion.y += gravity
	if is_dead == false:
		follow_path()
		if !is_on_floor() and !jumping_started and motion.y < 0:
			jumping_started = true
			
		if jumping_started and motion.y < 0:
			find_zombie_jump_on_peak()

		if jumping_started and motion.y >= 0:
			jumping_peak = true
			find_zombie_jump_on_peak()
			
		if jumping_started and jumping_peak and is_on_floor():
			jumping_started = false
			jumping_peak = false

		
		motion = move_and_slide(motion , UP)
		chech_zombie_colliding()
 
func _zombie_dead_timer_timeout():
	create_extra_resources()
	queue_free()
	emit_signal("dead_counter_for_wave")

func _on_FollowPlayerTimer_timeout():
	if is_borned and is_on_floor() and !is_zombie_action and !is_dead:
		_get_path()

func _zombie_attack_timer_timeout():
	can_zombie_attack = true
	
func _zombie_attack_to_player(damage):
	if can_zombie_attack:
		zombie_attack_timer.start()
		$AnimatedSprite.play("attack")
		player.dead(damage,"zombie")
		can_zombie_attack = false
		
func flash_damage():
	for i in range(N_FLASHES * 2):
		var zombie_visible = true if i % 2 == 1 else  false
		var time = FLASH_RATE * i +FLASH_RATE
		flash_zombie_tween.interpolate_callback($AnimatedSprite,time, "set", "visible", zombie_visible)
	flash_zombie_tween.start()


func _on_Timer_timeout():
	var diff = (target_point_world - tile_map.get_closest_point(get_global_position()))
	can_zombie_jump(diff)


func _on_AnimatedSprite_animation_finished():
	is_hurt=false
	is_borned = true
	pass # Replace with function body.


func _on_BornTimer_timeout():
	is_borned = false
	$AnimatedSprite.play("born")
	pass # Replace with function body.
