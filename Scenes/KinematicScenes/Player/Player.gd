extends KinematicBody2D
signal dead_signal

const rasengan_bullet = preload("res://Scenes/KinematicScenes/Player/Bullets/GrenadeLauncherBullet/GLBullet.tscn")
const upgrade_bullet = preload("res://Scenes/KinematicScenes/Player/Bullets/UpgradedBullet/UpgratedBullet.tscn")
const tracked_bullet = preload("res://Scenes/KinematicScenes/Player/Bullets/TrackedBullet/TrackedBullet.tscn")
const crossbow_bullet = preload("res://Scenes/KinematicScenes/Player/Bullets/CrossbowBullet/CrossbowBullet.tscn")
const m4a1_bullet = preload("res://Scenes/KinematicScenes/Player/Bullets/M4A1Bullet/M4A1Bullet.tscn")
const M1Garand_bullet = preload("res://Scenes/KinematicScenes/Player/Bullets/M1GarandBullet/M1GarandBullet.tscn")
const m604e_bullet = preload("res://Scenes/KinematicScenes/Player/Bullets/M60E4Bullet/M60E4Bullet.tscn")
const MG42_bullet = preload("res://Scenes/KinematicScenes/Player/Bullets/MG42Bullet/MG42Bullet.tscn")
const PRD_bullet = preload("res://Scenes/KinematicScenes/Player/Bullets/PRDBullet/PRDBullet.tscn")
const Riflegun_bullet = preload("res://Scenes/KinematicScenes/Player/Bullets/RiflegunBullet/RiflegunBullet.tscn")



var blood_anim = preload("res://Scenes/StaticScenes/BloodAnimation/BloodAnimation.tscn")


var rasengan_bullet_sound = AudioStreamPlayer.new()
var upgrade_bullet_sound = AudioStreamPlayer.new()
var tracked_bullet_sound = AudioStreamPlayer.new()
var crossbow_bullet_sound = AudioStreamPlayer.new()
var m4a1_bullet_sound= AudioStreamPlayer.new()
var M1Garand_bullet_sound = AudioStreamPlayer.new()
var m604e_bullet_sound = AudioStreamPlayer.new()
var MG42_bullet_sound = AudioStreamPlayer.new()
var PRD_bullet_sound = AudioStreamPlayer.new()
var Riflegun_bullet_sound = AudioStreamPlayer.new()
var EmptyGun_sound = AudioStreamPlayer.new()
var SwordSlide_Sound = AudioStreamPlayer.new()

var tracked_bullet_file = load("res://Resources/AudioFiles/Ak47Bullet/ak47shot.wav")
var rasengan_bullet_file = load("res://Resources/AudioFiles/GunShoot/GrenadeLauncher.wav")
var upgrade_bullet_file = load("res://Resources/AudioFiles/Shots/shotgun.wav")
var crossbow_bullet_file = load("res://Resources/AudioFiles/GunShoot/Crossbow.wav")
var m4a1_bullet_file = load("res://Resources/AudioFiles/GunShoot/M4A1.wav")
var M1Garand_bullet_file = load("res://Resources/AudioFiles/GunShoot/M1Garand.wav")
var m604e_bullet_file = load("res://Resources/AudioFiles/GunShoot/M60E4.wav")
var MG42_bullet_file = load("res://Resources/AudioFiles/GunShoot/MG42.wav")
var PRD_bullet_file = load("res://Resources/AudioFiles/GunShoot/PRD.wav")
var Riflegun_bullet_file = load("res://Resources/AudioFiles/GunShoot/RifleGun.wav")
var EmptyGun_sound_file = load("res://Resources/AudioFiles/GunShoot/GunEmpty.wav")
var SwordSlide_Sound_file = load("res://Resources/AudioFiles/GunShoot/swordslash.wav")
#var rasengan_weapon = Image.new()
#var shotgun_weapon = Image.new()
#var ak47_weapon = Image.new()
#
#var weaponTexture = null

var bullet_type = {
	101: rasengan_bullet,
	102: upgrade_bullet,
	103: tracked_bullet,
	107: crossbow_bullet,
	108: m4a1_bullet,
	109: M1Garand_bullet,
	110: m604e_bullet,
	111: MG42_bullet,
	112: PRD_bullet,
	113: Riflegun_bullet,
}

var gun_speed = {
	101: 0.5,
	102: 0.7,
	103: 0.7,
	107: 1,
	108: 1,
	109: 1,
	110: 0.5,
	111: 0.5,
	112: 0.5,
	113: 0.5,
}

#	rasengan_weapon.load("res://Resources/Sprites/Guns/rasengan.png")
#	shotgun_weapon.load("res://Resources/Sprites/Guns/shotgun.png")
#	ak47_weapon.load("res://Resources/Sprites/stickman/ak47.png")

var bullet_icons = {
	101: "res://Resources/Sprites/Guns/rasengan.png",
	102: "res://Resources/Sprites/Guns/shotgun.png",
	103: "res://Resources/Sprites/stickman/ak47.png",
	107: "res://Resources/Sprites/Guns/crossbow.png",
	108: "res://Resources/Sprites/Guns/M1Garand.png",
	109: "res://Resources/Sprites/Guns/m4a1.png",
	110: "res://Resources/Sprites/Guns/m604e.png",
	111: "res://Resources/Sprites/Guns/MG42png.png",
	112: "res://Resources/Sprites/Guns/PRD.png",
	113: "res://Resources/Sprites/Guns/riflegun.png",
}

var bullet_sound = {
	101: rasengan_bullet_sound,
	102: upgrade_bullet_sound,
	103: tracked_bullet_sound,
	107: crossbow_bullet_sound,
	108: m4a1_bullet_sound,
	109: M1Garand_bullet_sound,
	110: m604e_bullet_sound,
	111: MG42_bullet_sound,
	112: PRD_bullet_sound,
	113: Riflegun_bullet_sound,
}

var bullet_shoot_timer = Timer.new()
var empty_shoot_timer = Timer.new()
var is_empty_gun_ready = false


var bullet_time = {
	101: 1.0,
	102: 1.0,
	103: 0.15,
	107: 1.0,
	108: 0.2,
	109: 0.7,
	110: 0.1,
	111: 0.09,
	112: 0.1,
	113: 1.0,
}




var body_scale = 1


enum bullet_power{
	basic_bullet = 1
	upgrated_bullet = 2
}
# environment options
var tramb_count=1
const jump = -45 * 20
const gravity = 20
# player options
const max_hp = 1000
var hp = 100
var speed = 50
var max_speed = 450
var motion = Vector2(0,0)
var slide_speed = 700
var killed_counter = 0
var current_bullet = null
var current_bullet_power = 103
# player motions
var is_attack = false
var is_down = false
var is_dead = false
var is_move = false
var is_hurt = false
var is_jump = false
var is_melee = false
var is_shift_stop = false
var is_first_jump = false
var is_second_jump = false
var bullet_size = 9999
var change_color_tween= Tween.new()
var pulse_tween= Tween.new()
var is_in_time_start_weapon_fire = false 
var player_peak_height = Vector2()
var is_set_player_peak_height = false
const FLASH_RATE =0.05
const N_FLASHES = 4

var healty_color = Color.green
var caution_color = Color.yellow
var danger_color = Color.red
var pulse_color = Color.darkred
var flash_color = Color.orangered

var healt_perfect_value = max_hp * 0.8
var healt_caution_value = max_hp * 0.45
var healt_danger_value = max_hp * 0.20

var flash_tween= Tween.new()
var flash_healtbar_tween= Tween.new() 

onready var bullet_number = get_node("../Game_UI/bullet_counter")
onready var player_health = get_node("../Game_UI/Player_Health")
onready var player_health_back = get_node("../Game_UI/Player_Health_Back")
const basic_zombie = preload("res://Scenes/KinematicScenes/Zombies/SimpleZombie/SimpleZombie.tscn")
#basic zombie nerede kullanıyor??
var slow_shot_timer = Timer.new()

func _create_zombie_shot_slow_timer():
	slow_shot_timer.connect("timeout",self,"_on_slow_motion_timer_start") 
	add_child(slow_shot_timer) #to process
	slow_shot_timer.set_wait_time(0.1)
	
func color_change_tween():
	add_child(change_color_tween) #to process
	
func pulse_tween():
	add_child(pulse_tween) #to process
	pulse_tween.set_repeat(true)
	
func flash_tween():
	add_child(flash_tween) #to process
func flash_healtbar_tween():
	add_child(flash_healtbar_tween) #to process
	
func increase_bullet_count(bullet_count):
	bullet_size += bullet_count
	bullet_number.text=String(bullet_size)
	
func _create_bullet_shoot_timer():
	bullet_shoot_timer.set_one_shot(true)
	bullet_shoot_timer.connect("timeout",self,"_on_bullet_shoot_timer") 
	add_child(bullet_shoot_timer) #to process
	bullet_shoot_timer.set_wait_time(bullet_time[current_bullet_power])

func _on_bullet_shoot_timer():
	is_in_time_start_weapon_fire = false
	
func set_shoot_timer(shoot_time):
	bullet_shoot_timer.set_wait_time(shoot_time)

func set_sounds():
	SwordSlide_Sound.set_stream(SwordSlide_Sound_file)
	rasengan_bullet_sound.set_stream(rasengan_bullet_file)
	upgrade_bullet_sound.set_stream(upgrade_bullet_file)
	tracked_bullet_sound.set_stream(tracked_bullet_file)
	crossbow_bullet_sound.set_stream(crossbow_bullet_file)
	m4a1_bullet_sound.set_stream(m4a1_bullet_file)
	M1Garand_bullet_sound.set_stream(M1Garand_bullet_file)
	m604e_bullet_sound.set_stream(m604e_bullet_file)
	MG42_bullet_sound.set_stream(MG42_bullet_file)
	PRD_bullet_sound.set_stream(PRD_bullet_file)
	Riflegun_bullet_sound.set_stream(Riflegun_bullet_file)
	EmptyGun_sound.set_stream(EmptyGun_sound_file)
	SwordSlide_Sound.volume_db = 1
	SwordSlide_Sound.pitch_scale = 1	
	rasengan_bullet_sound.volume_db = 1
	rasengan_bullet_sound.pitch_scale = 1	
	upgrade_bullet_sound.volume_db = 1
	upgrade_bullet_sound.pitch_scale = 1
	tracked_bullet_sound.volume_db = 1
	tracked_bullet_sound.pitch_scale = 1	
	crossbow_bullet_sound.volume_db = 1
	crossbow_bullet_sound.pitch_scale = 1	
	m4a1_bullet_sound.volume_db = 1
	m4a1_bullet_sound.pitch_scale = 1
	M1Garand_bullet_sound.volume_db = 1
	M1Garand_bullet_sound.pitch_scale = 1	
	m604e_bullet_sound.volume_db = 1
	m604e_bullet_sound.pitch_scale = 1	
	MG42_bullet_sound.volume_db = 1
	MG42_bullet_sound.pitch_scale = 1
	PRD_bullet_sound.volume_db = 1
	PRD_bullet_sound.pitch_scale = 1	
	Riflegun_bullet_sound.volume_db = 1
	Riflegun_bullet_sound.pitch_scale = 1	
	EmptyGun_sound.volume_db = 1
	EmptyGun_sound.pitch_scale = 1
	add_child(SwordSlide_Sound)
	add_child(rasengan_bullet_sound)
	add_child(upgrade_bullet_sound)
	add_child(tracked_bullet_sound)
	add_child(crossbow_bullet_sound)
	add_child(m4a1_bullet_sound)
	add_child(M1Garand_bullet_sound)
	add_child(m604e_bullet_sound)
	add_child(MG42_bullet_sound)
	add_child(PRD_bullet_sound)
	add_child(Riflegun_bullet_sound)
	add_child(EmptyGun_sound)
func load_images():
	pass
#	rasengan_weapon.load("res://Resources/Sprites/Guns/rasengan.png")
#	shotgun_weapon.load("res://Resources/Sprites/Guns/shotgun.png")
#	ak47_weapon.load("res://Resources/Sprites/stickman/ak47.png")

func _create_empty_shoot_timer():
	empty_shoot_timer.set_one_shot(false)
	empty_shoot_timer.connect("timeout",self,"_on_empty_shoot_timer") 
	add_child(empty_shoot_timer) #to process
	empty_shoot_timer.set_wait_time(0.1)
func _on_empty_shoot_timer():
	is_empty_gun_ready = true
	
func _ready():
	_create_empty_shoot_timer()
	_create_bullet_shoot_timer()
	_create_zombie_shot_slow_timer()
	flash_tween()
	pulse_tween()
	color_change_tween()
	flash_healtbar_tween()
	set_sounds()
	load_images()

	if OS.get_name() == "Windows" or OS.get_name() == "OSX" or OS.get_name() == "X11":
		$Controller/move.set_visible(false)
		$Controller/action.set_visible(false)

func _on_slow_motion_timer_start():
	Engine.time_scale = 1
	slow_shot_timer.stop()

func _set_current_bullet(bullet):
	current_bullet = bullet

func empty_gun():
	if is_empty_gun_ready:
		EmptyGun_sound.play()
	empty_shoot_timer.start()
	is_empty_gun_ready = false
	pass
func _check_bullet_count():
	return bullet_size > 0

func _fire_bullet():
	bullet_size-=1
	bullet_number.text=String(bullet_size)
	
func set_current_weapon(bullet_power):
	var stream_texture = load(bullet_icons[bullet_power])
	var image_texture = ImageTexture.new()
	var image = stream_texture.get_data()
	image.lock() # so i can modify pixel data
	current_bullet_power = bullet_power
	image_texture.create_from_image(image, 0)
	set_shoot_timer(bullet_time[current_bullet_power])

	#$human/body2/ak47.set_texture(image_texture)
	image.unlock()
	
	
func _set_bullet_direction(direction):
	current_bullet.set_bullet_direction(direction)

func _set_player_options(_max_speed, _speed):
	speed = _speed
	max_speed = _max_speed

func _decrease_health(health):
	hp -= health

func _increare_health(health):
	hp += health
	
func _is_dead():
	return is_dead

func _set_dead(dead_state):
	is_dead = dead_state
	
func _set_is_down(down_state):
	is_down = down_state

func _set_is_melee(melee_state):
	is_melee = melee_state

func _set_is_attack(attack_state):
	is_attack = attack_state


func _is_movable():
	return !is_melee && !is_attack && !is_down
	

func _is_idle():
	return !is_down && !is_melee && !is_attack && !is_move
	
func _play_melee_sound():
	SwordSlide_Sound.play()
	
func _play_animation(animation_state):
	var anim = animation_state + "_" + str(current_bullet_power) 
	if animation_state == "run" or animation_state == "attack":
		$AnimatedSprite.set_speed_scale(gun_speed[current_bullet_power])
	$AnimatedSprite.play(anim)
	
func _play_idle_animation():
	_play_animation("idle")

func _play_jump_animation():
	_play_animation("jump")
	is_jump = true

func _play_melee_animation():
	_play_animation("melee")

func _play_slide_animation():
	_play_animation("slide")	
	
func _play_attack_animation():
	if !is_attack:
		_play_animation("attack")	

func _play_run_animation():
	if !is_jump:
		_play_animation("run")
		
func _play_fall_animation():
	_play_animation("fall")
	
func _move_slide():
	if !$AnimatedSprite.is_flipped_h():
		motion.x = slide_speed  *gun_speed[current_bullet_power]
	else:
		motion.x = -slide_speed * gun_speed[current_bullet_power]

func _move_right():
	is_move = true
	motion.x=min(motion.x + speed, max_speed *  gun_speed[current_bullet_power])
	animation_flip_h(false)
	_play_run_animation()
	if sign($Position2D.position.x)==-1:
		$Position2D.position.x*=-1

func _move_left():
	is_move = true
	motion.x = max(motion.x-speed ,-max_speed *  gun_speed[current_bullet_power])
	_play_run_animation()
	animation_flip_h(true)
	if sign($Position2D.position.x)==1:
		$Position2D.position.x*=-1

		

func animation_flip_h(choice):
	$AnimatedSprite.flip_h = choice	

func _set_shift_stop(shift_stop_state):
	is_shift_stop = shift_stop_state

func _is_shift_stop():
	return is_shift_stop

func _get_motion():
	return motion
	
func _clear_states():
	is_down = false
	is_melee = false
	is_move = false
	is_hurt = false
	is_jump = false
	

var UP = Vector2(0,-1)
func check_left_pressed():
	if Input.is_action_pressed("ui_left"):
		if _is_movable():
			_move_left()
	if Input.is_action_just_released("ui_left") : 
		is_move = false

func check_right_pressed():
	if Input.is_action_pressed("ui_right") :
			if _is_movable():
				_move_right()
	if Input.is_action_just_released("ui_right"):
		is_move = false

func check_down_pressed():
	if Input.is_action_just_pressed("ui_down") :
		_set_is_down(true)
		_move_slide()
		_play_slide_animation()

					
func check_space_pressed():
	if Input.is_key_pressed(KEY_SPACE):
			Engine.time_scale = 0.1
			slow_shot_timer.start()
					
func check_melee_pressed():
	if Input.is_action_just_pressed("ui_focus_prev") :
		if _is_movable():
				_set_is_melee(true)
				_play_melee_sound()
				_play_melee_animation()

func check_fire_pressed():
	if Input.is_action_pressed("ui_focus_next") :
		if  _check_bullet_count() and !is_in_time_start_weapon_fire:
			bullet_shoot_timer.start()
			_fire_bullet()
			is_in_time_start_weapon_fire = true
			_play_attack_animation()
			_set_is_attack(true)		
			bullet_sound[current_bullet_power].play()
			_set_current_bullet(bullet_type[current_bullet_power].instance())
			get_parent().add_child(current_bullet)
			_set_bullet_direction(sign($Position2D.position.x))
			current_bullet.position = $Position2D.global_position
		elif !_check_bullet_count():
				empty_gun()
	if Input.is_action_just_released("ui_focus_next") :
		is_attack = false

func check_first_and_second_jump():
		if (Input.is_action_just_pressed("ui_up") ) and is_first_jump and !is_second_jump:
			_play_jump_animation()
			motion.y = jump
			is_second_jump = true
			is_first_jump = false
		if is_on_floor():
			if (Input.is_action_just_pressed("ui_up") ) and !is_first_jump:
				motion.y = jump
				is_first_jump = true
				is_second_jump = false
				_play_jump_animation()
				

func check_falling():	
	if($RayCast2D.is_colliding() and "TileMap" in $RayCast2D.get_collider().name ):
			is_set_player_peak_height = false
	if !is_on_floor()  and motion.y > 0:
		if(!is_set_player_peak_height):
			is_set_player_peak_height = true
			player_peak_height = get_global_position()
			print("Zıplama yüksekliği",player_peak_height)
		_play_fall_animation()
		

func _physics_process(delta):
	Engine.time_scale = 1.0
	motion.y += gravity 
	if !_is_dead():
		_set_shift_stop(false)
		check_right_pressed()
		check_left_pressed()
		check_down_pressed()
		check_space_pressed()
		check_melee_pressed()
		check_fire_pressed()
		check_first_and_second_jump();
		check_falling()
		if is_on_floor() and _is_idle():
			_play_idle_animation()
			motion.x = lerp(motion.x, 0, 0.2)	
	else:
		if is_on_floor():
			$CollisionShape2D.set_deferred("disabled",true)

	motion = move_and_slide(motion,UP)
			
func dead(damage,whodead):
	if !_is_dead():
		_decrease_health(damage)
		flash_damage()
		damage_healt_color_change()
		healt_color_decrease()
		player_health.set_value(hp)

		if hp < 0:
			_set_dead(true)
			motion=Vector2(0,0)
			_play_animation("dead")
			emit_signal("dead_signal")
			$player_dead_timer.start()#karakter hareket etmeyince timerin içine girmiyor
		else:
			is_hurt=true
			_play_animation("hurt")

#func _on_AnimatedSprite_animation_finished():
#	_clear_states()

func upgrade_power_up():
	current_bullet_power = 2
var blood_position_calibration = Vector2(10,30) #kanın zombi üzerinde ince kalibrasyonu
func _on_Area2D_body_entered(body):
	if "Zombie" in body.name:
		body.dead(1,"Zombie") 
		var blood_instance = blood_anim.instance()
		body.add_child(blood_instance)
		blood_instance.set_global_position(body.get_global_position() + blood_position_calibration)


func healt_kit(healt):
	_increare_health(healt)
	if hp > max_hp:
		hp = max_hp
	change_color_tween.start()
	change_color_tween.interpolate_property(player_health_back,'value',player_health_back.get_value(),
								hp,0.6,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	change_color_tween.interpolate_property(player_health,'value',player_health.get_value(),
							hp,0.6,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	player_health_back.set_value(hp)
	player_health.set_value(hp)
	healt_color_increase()
	
func healt_color_increase():
	if  hp >= healt_perfect_value :
		change_color_tween.interpolate_property(player_health,'tint_progress', caution_color,healty_color,
								0.5,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		pulse_tween.set_active(false)
	elif hp < healt_perfect_value and hp > healt_caution_value:
		change_color_tween.interpolate_property(player_health,'tint_progress',danger_color, caution_color,
								0.5,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		pulse_tween.set_active(false)
	elif  hp <= healt_caution_value and hp > healt_danger_value:
		change_color_tween.interpolate_property(player_health,'tint_progress',pulse_color, danger_color,
								0.5,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		pulse_tween.set_active(false)
	
		


func tramboline_jump(tramboline_position):
	is_set_player_peak_height = false
	motion.y = -1.5 * (tramboline_position - player_peak_height).y - 500;
	motion.y = max(motion.y,-1800)

	pass

	
	
func healt_color_decrease(): #?  sürekli iflere girmesin mi girsinmi
	if  hp >= healt_perfect_value   :
		change_color_tween.interpolate_property(player_health,'tint_progress',Color(0,1,0,1),
								healty_color,0.5,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	
		 
		pulse_tween.set_active(false)
	elif hp < healt_perfect_value and hp > healt_caution_value :
		change_color_tween.interpolate_property(player_health,'tint_progress',healty_color,
								caution_color,0.5,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		 
		pulse_tween.set_active(false)

	elif  hp <= healt_caution_value and hp > healt_danger_value :
		change_color_tween.interpolate_property(player_health,'tint_progress',caution_color,
								danger_color,0.5,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
		pulse_tween.set_active(false)
	elif  hp <= healt_danger_value  :
		pulse_tween.set_active(true)
		pulse_tween.interpolate_property(player_health,"tint_progress",pulse_color,danger_color,1.2,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
		pulse_tween.start()
	change_color_tween.start()
	yield(change_color_tween, "tween_completed")

func flash_damage():	
	pass
#	for i in range(N_FLASHES * 2):
#		var color = player_health.tint_progress  if i % 2 == 1 else  flash_color
#		var human_visible = true if i % 2 == 1 else false
#		var time = FLASH_RATE * i +FLASH_RATE
#		flash_tween.interpolate_callback($human,time, "set", "visible", human_visible)
#		flash_healtbar_tween.interpolate_callback(player_health,time, "set", "tint_progress", color)
#	flash_tween.start()
#	flash_healtbar_tween.start()
	
func damage_healt_color_change():
	change_color_tween.start()
	change_color_tween.interpolate_property(player_health_back,'value',player_health_back.get_value(),
								hp,0.6,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	player_health_back.set_value(hp)
	pass

#func _unhandled_input(event):
#	if event is InputEventMouseButton :
#		if event.pressed and event.button_index == BUTTON_LEFT:
#			var pos = get_global_mouse_position()
#			set_global_position(pos)

func _on_jump_counter_time_timeout():
	tramb_count=1
	pass # Replace with function body.

func _on_player_dead_timer_timeout():
	pass
	#skor hesaplama yerine gitmesi gerekir.
	#game over kaç saniyede bitirdi, zombi oldürdü, yıldız topladı vs. puan
	#sonra ana ekrana döner
	 
func increase_dead_counter():
	killed_counter += 1
	pass

func _on_right_pressed():
	$Controller/move/right.modulate=Color(0.341176, 0.341176, 0.341176)

func _on_left_pressed():
	$Controller/move/left.modulate=Color(0.341176, 0.341176, 0.341176)

func _on_up_pressed():
	$Controller/action/up.modulate=Color(0.341176, 0.341176, 0.341176)

func _on_down_pressed():
	$Controller/action/down.modulate=Color(0.341176, 0.341176, 0.341176)

func _on_gun_shoot_pressed():
	$Controller/action/gun_shoot.modulate = Color(1, 1, 1)

func _on_melee_attack_pressed():
	$Controller/action/melee_attack.modulate = Color(1, 1, 1)

func _on_right_released():
	$Controller/move/right.modulate = Color(1, 1, 1)
	pass # Replace with function body.

func _on_left_released():
	$Controller/move/left.modulate = Color(1, 1, 1)
	pass # Replace with function body.

func _on_up_released():
	$Controller/action/up.modulate=Color(1, 1, 1)
	pass # Replace with function body.

func _on_down_released():
	$Controller/action/down.modulate=Color(1, 1, 1)
	pass # Replace with function body.

func _on_gun_shoot_released():
	$Controller/action/gun_shoot.modulate=Color(1, 1, 1)
	pass # Replace with function body.

func _on_melee_attack_released():
	$Controller/action/melee_attack.modulate=Color(1, 1, 1)
	pass # Replace with function body.


func _on_AnimatedSprite_animation_finished():
	_clear_states()
	pass # Replace with function body.


