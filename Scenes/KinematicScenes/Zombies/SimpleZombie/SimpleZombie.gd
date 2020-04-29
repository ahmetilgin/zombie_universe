extends KinematicBody2D
var target_point_world = Vector2()
var FollowPlayerTimer = Timer.new()
onready var player = get_parent().get_node('player')
onready var tile_map = get_parent().get_node('TileMap')
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

const FLASH_RATE =0.05
const N_FLASHES = 4
var flash_zombie_tween = Tween.new()

export (int) var hp=5
export (int) var speed=200
var motion=Vector2(0,0)
const UP=Vector2(0,-1)
var is_dead=false
var is_hurt=false
var acceleration = 10
var is_follow = false
var path = []
signal dead_counter_for_wave
var body_scale = 0.45
var body_rotation = 35.5

func add_attack_ray_cast():
#	attack_ray_cast.set_position(Vector2(64,64))
	add_child(attack_ray_cast)
	attack_ray_cast.set_cast_to(Vector2(30,0))
	attack_ray_cast.set_position(Vector2(90,90))
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
	add_zombie_sounds()
	create_zombie_dead_timer()
	create_zombie_follow_timer()
	create_zombie_attack_timer()
	add_attack_ray_cast()
	flash_zombie_tween()
#	create_zombie_found_player_label()


func get_zombie_and_player_distance():
	return player.get_global_position().distance_to(get_global_position())

func find_zombie_x_movement(direction):
	if direction.x > 0:
		motion.x = min(motion.x + acceleration, speed)
	else:
		motion.x = max(motion.x - acceleration, -speed)
			
func can_zombie_jump(direction,cross_index):
	var target_distance = 0
	if direction.y < 0 && is_on_floor():
		if  player.is_on_floor():
			var player_pos = player.get_global_position()
			var zombie_pos = get_global_position()
			if player_pos.y < zombie_pos.y:
				var diff = player_pos.y - zombie_pos.y
				motion.y += max(diff * 3, -1000)

func find_cross_index():
	var cross_index = 0
	if len(path) > 2:
		for i in range(0,len(path) - 1):
			if path[i].x == path[i + 1].x and path[i].y != path[i + 1].y:
				cross_index = i
			else:
				break
	return cross_index
	
func move_to():
	if len(path) > 1:
		var direction = get_global_position().direction_to(target_point_world)
		find_zombie_x_movement(direction)
		can_zombie_jump(direction,find_cross_index())
		var ARRIVE_DISTANCE = 25
		return get_global_position().distance_to(target_point_world) < ARRIVE_DISTANCE
	
func get_next_target_point():
	if move_to():
		path.pop_front()
		if len(path) > 0:
			target_point_world = path[0]	

func check_zombie_found_player():
	if get_zombie_and_player_distance() < 80:
		_zombie_attack_to_player(5)
		motion.x= 0
		if !FollowPlayerTimer.is_stopped():
			FollowPlayerTimer.stop()
			path = []
	else:
		$AnimationPlayer.play("Run")
		if FollowPlayerTimer.is_stopped():
			FollowPlayerTimer.start()
		get_next_target_point()

func set_zombie_direction():
	if len(path) > 2:
		if sign(path[1].x - get_global_position().x) != 1:
			$Zombie.scale.x = -body_scale
			attack_ray_cast.scale.x = -1
			attack_ray_cast.set_position(Vector2(10,90))
		
		else:
			$Zombie.scale.x = body_scale
			attack_ray_cast.scale.x = 1
			attack_ray_cast.set_position(Vector2(40,90))
			 
var is_zombie_action = false
func follow_path():
	if !is_zombie_action:
		set_zombie_direction()
		check_zombie_found_player()
	pass

func _get_path():
	path = get_parent().get_node('TileMap')._get_path($CollisionShape2D.get_global_position(), player.get_global_position(),get_name())
	path.pop_front()
	if len(path) > 2:
		target_point_world = path[1]
		
		
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
	var power_up = randi() % 3
	if power_up == 0:
		generate_coins()
	elif power_up == 1:
		generate_extra_bullet()
		

func dead(damage,whodead):
	hp-=damage
	flash_damage()
	if hp < 0 and !is_dead:
		is_dead=true
		if whodead=="player":
			get_parent().get_node("player").increase_dead_counter()

		zombie_dead_player.play()
		motion=Vector2(0,0)
	
		$AnimationPlayer.play("Dead")
		$CollisionShape2D.set_deferred("disabled",true)
		zombie_dead_timer.start()
	else:
#		is_hurt=true
#		zombie_hurt_player.play()
		var back = 0;
		if get_parent().get_node("player").get_global_position().x < get_global_position().x:
			back = 400
		else:
			back = -400
		motion = move_and_slide(Vector2(motion.x + back, motion.y) , UP)

func dead_from_turrent(damage,whodead,dir):
	hp-=damage
	flash_damage()
	if hp<0:
		if whodead=="player":
			get_parent().get_node("player").increase_dead_counter()
		is_dead=true
		zombie_dead_player.play()
		motion=Vector2(0,0)
		$AnimationPlayer.play("Dead")
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
		

func jump():
	motion.y -= 1000

		
func chech_zombie_colliding():
	is_zombie_action = false
	if attack_ray_cast.is_colliding():
		var playerFound = false
		if "player" in attack_ray_cast.get_collider().name:
			playerFound = true
			_zombie_attack_to_player(5)
			is_zombie_action = true
		elif "Top"  in attack_ray_cast.get_collider().name:
			$AnimationPlayer.play("Attack")
			var colliding_turret = attack_ray_cast.get_collider().get_parent().get_parent()
			colliding_turret.change_turret_health(-20)
			is_zombie_action = true
		elif "Turret"  in attack_ray_cast.get_collider().name:
			$AnimationPlayer.play("Attack")
			var colliding_turret = attack_ray_cast.get_collider()
			colliding_turret.change_turret_health(-20)
			is_zombie_action = true
		elif  "Fence"in attack_ray_cast.get_collider().name:
			$AnimationPlayer.play("Attack")
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

func move_like_basic_zombie():
	if len(path) == 0:
		pass

func _physics_process(delta):
	motion.y += gravity
	if is_dead==false:
		follow_path()
		motion = move_and_slide(motion , UP)
		chech_zombie_colliding()
 
func _zombie_dead_timer_timeout():
	create_extra_resources()
	queue_free()
	emit_signal("dead_counter_for_wave")

func _on_FollowPlayerTimer_timeout():
	_get_path()

func _zombie_attack_timer_timeout():
	can_zombie_attack = true
	
func _zombie_attack_to_player(damage):
	if can_zombie_attack:
		zombie_attack_timer.start()
		$AnimationPlayer.play("Attack")
		player.dead(damage,"zombie")
		can_zombie_attack = false
	

func _on_AnimationPlayer_animation_finished(Hurt):
	is_hurt=false
func flash_damage():
	for i in range(N_FLASHES * 2):
		var zombie_visible = true if i % 2 == 1 else  false
		var time = FLASH_RATE * i +FLASH_RATE
		flash_zombie_tween.interpolate_callback($Zombie,time, "set", "visible", zombie_visible)
	flash_zombie_tween.start()
