extends KinematicBody2D
signal dead_signal
const bullet = preload("res://Scenes/KinematicScenes/Player/Bullets/SimpleBullet/SimpleBullet.tscn")
const upgrade_bullet = preload("res://Scenes/KinematicScenes/Player/Bullets/UpgradedBullet/UpgratedBullet.tscn")
const tracked_bullet = preload("res://Scenes/KinematicScenes/Player/Bullets/TrackedBullet/TrackedBullet.tscn")
#touch screen option
var touch_right=false
var touch_left=false
var touch_up=false
var touch_down=false
var touch_fire=false
var touch_melee=false
var body_scale = 1


enum bullet_power{
	basic_bullet = 1
	upgrated_bullet = 2
}
# environment options
var tramb_count=1
const jump = -550
const gravity = 20
# player options
var hp = 100
var speed = 150
var max_speed = 300
var motion = Vector2(0,0)
var slide_speed = 500
var killed_counter = 0
var current_bullet = null
var current_bullet_power = 3
# player motions
var is_attack = false
var is_down = false
var is_dead = false
var is_hurt = false
var is_melee = false
var is_shift_stop = false
var bullet_size = 20
onready var bullet_number = get_node("../Game_UI/bullet_counter")
onready var player_health = get_node("../Game_UI/Player_Health")
onready var updated_tween = get_node("../Game_UI/Updated_Tween")
const basic_zombie = preload("res://Scenes/KinematicScenes/Zombies/SimpleZombie/SimpleZombie.tscn")
#basic zombie nerede kullanıyor??
var slow_shot_timer = Timer.new()
func _create_zombie_shot_slow_timer():
	slow_shot_timer.connect("timeout",self,"_on_slow_motion_timer_start") 
	add_child(slow_shot_timer) #to process
	slow_shot_timer.set_wait_time(0.1)

func increase_bullet_count(bullet_count):
	bullet_size += bullet_count
	bullet_number.text=String(bullet_size)
	
func _ready():
	_create_zombie_shot_slow_timer()

func _on_slow_motion_timer_start():
	Engine.time_scale = 1
	slow_shot_timer.stop()

func _set_current_bullet(bullet):
	current_bullet = bullet

func _check_bullet_count():
	return bullet_size > 0

func _fire_bullet():
	bullet_size-=1
	bullet_number.text=String(bullet_size)
	
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

func _change_collision_rotation():
		if $AnimatedSprite.flip_h==false:
			$Area2D/CollisionShape2D.disabled=false
		else:
			$mele_flip_h_true/CollisionPolygon2D.disabled=false

func _is_movable():
	return !is_melee && !is_attack && !is_down

func _is_idle():
	return !is_down && !is_melee && !is_attack && !is_hurt

func _play_animation(animation_state):
	$AnimationPlayer.play(animation_state)
	
func _play_idle_animation():

	_play_animation("idleAk47")

func _play_melee_animation():
	_play_animation("meleeAk47")

func _play_slide_animation():
	_play_animation("slideAk47")	
	
func _play_attack_animation():
	_play_animation("shootAk47")	

func _move_slide():
	$CollisionShape2D.scale = Vector2 (1, 0.7)
	$CollisionShape2D.position.y=25
	if $AnimatedSprite.flip_h==false:
		motion.x = slide_speed
	else:
		motion.x = -slide_speed

func _move_right():
	motion.x=min(motion.x + speed,max_speed)
	$AnimationPlayer.play("runAk47")
	animation_flip_h(false)
	$AnimatedSprite.flip_h=false
	if sign($Position2D.position.x)==-1:
		$Position2D.position.x*=-1
		
func _move_left():
	motion.x = max(motion.x-speed,-max_speed)
	$AnimationPlayer.play("runAk47")
	animation_flip_h(true)
	$AnimatedSprite.flip_h = true
	if sign($Position2D.position.x)==1:
		$Position2D.position.x*=-1

func animation_flip_h(choice):
	if choice == true:
		
		$human.scale.x = -body_scale
		
	elif choice == false:
		$human.scale.x = body_scale

		
	
func _set_shift_stop(shift_stop_state):
	is_shift_stop = shift_stop_state

func _is_shift_stop():
	return is_shift_stop

func _get_motion():
	return motion
	
func _clear_states():
	is_attack=false
	is_down=false
	is_hurt=false
	is_melee=false
	$CollisionShape2D.scale = Vector2 (1, 1)
	$CollisionShape2D.position.y=11
	
var UP = Vector2(0,-1)

func _physics_process(delta):

	motion.y += gravity 
	if !_is_dead():
		$Area2D/CollisionShape2D.disabled=true
		$mele_flip_h_true/CollisionPolygon2D.disabled=true
		_set_shift_stop(false)
		if Input.is_action_pressed("ui_right") or touch_right:
			if _is_movable():
				_move_right()

		elif Input.is_action_pressed("ui_left") or touch_left:
			if _is_movable():
				_move_left()
		else:
			if _is_idle():
				_set_shift_stop(true)
				_play_idle_animation()							
		if Input.is_action_just_pressed("ui_down") or touch_down:
			if is_hurt==false && is_on_floor():
				if is_melee==false:
					_set_is_down(true)
					_play_slide_animation()
					_move_slide()
					touch_down = false
		if Input.is_key_pressed(KEY_SPACE):
			Engine.time_scale = 0.1
			slow_shot_timer.start()
		if Input.is_action_just_pressed("ui_focus_prev") or touch_melee:
			if _is_movable():
					_set_is_melee(true)
					_play_melee_animation()
					_change_collision_rotation()
		if Input.is_action_pressed("ui_focus_next") or touch_fire:
			if _is_movable() && _check_bullet_count():
				_fire_bullet()
				#get_node("Camera2D").shake(1,10,1)
				_set_is_attack(true)		
				_play_attack_animation()
				if current_bullet_power == 1:
					$ShotSound.play()
					_set_current_bullet(bullet.instance())
				elif current_bullet_power == 2:
					$ShotGun.play()
					_set_current_bullet(upgrade_bullet.instance())
				elif  current_bullet_power == 3:
					$Ak47Sound.play()
					_set_current_bullet(tracked_bullet.instance())
				get_parent().add_child(current_bullet)
				_set_bullet_direction(sign($Position2D.position.x))
				current_bullet.position = $Position2D.global_position
		if is_on_floor():
			if Input.is_action_just_pressed("ui_up") or touch_up:
				motion.y = jump
			if _is_shift_stop():
				motion.x = lerp(motion.x, 0, 0.2)
		else:
				if _is_movable():
					if motion.y < 0:
						$AnimationPlayer.play("fallAk47")
					else:
						$AnimationPlayer.play("jumpAk47")
					if _is_shift_stop():
						motion.x=lerp(motion.x,0,0.5)						
		motion = move_and_slide(motion,UP)
		
	else:
		if is_on_floor():
			$CollisionShape2D.set_deferred("disabled",true)
		else:
			motion.y += gravity
			motion = move_and_slide(motion,UP)
			
func dead(damage,whodead):
	if !_is_dead():
		hp -= damage
		player_health.set_value(hp)
		updated_tween.interpolate_property(player_health,"value",player_health.value,hp,0.4,Tween.TRANS_SINE,Tween.EASE_IN_OUT)
		updated_tween.start()
		if hp < 0:
			_set_dead(true)
			motion=Vector2(0,0)
			$AnimationPlayer.play("deadAk47")
			emit_signal("dead_signal")
			$player_dead_timer.start()#karakter hareket etmeyince timerin içine girmiyor
		else:
			is_hurt=true
			$AnimationPlayer.play("HurtAk47")

func _on_AnimatedSprite_animation_finished():
	_clear_states()

func upgrade_power_up():
	current_bullet_power = 2

func _on_Area2D_body_entered(body):
	if "Zombie" in body.name:
		body.dead(1,"Zombie") 

func _on_mele_flip_h_true_body_entered(body):
	if "Zombie" in body.name:
		body.dead(1,"Zombie") 

func tramboline_jump():

		tramb_count+=1
		
		motion.y=jump-50*tramb_count
		if tramb_count>6:
			tramb_count=6
		$jump_counter_time.start()
		
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
	touch_right=true
	$Controller/Node2D/right.modulate=Color(0.341176, 0.341176, 0.341176)

func _on_left_pressed():
	touch_left=true
	$Controller/Node2D/left.modulate=Color(0.341176, 0.341176, 0.341176)

func _on_up_pressed():
	touch_up=true
	$Controller/Node2D/up.modulate=Color(0.341176, 0.341176, 0.341176)

func _on_down_pressed():
	touch_down=true
	$Controller/Node2D/down.modulate=Color(0.341176, 0.341176, 0.341176)

func _on_gun_shoot_pressed():
	touch_fire=true
	$Controller/Node2D/gun_shoot.modulate = Color(1, 1, 1)

func _on_melee_attack_pressed():
	touch_melee=true
	$Controller/Node2D/melee_attack.modulate = Color(1, 1, 1)

func _on_right_released():
	$Controller/Node2D/right.modulate = Color(1, 1, 1)
	touch_right = false
	pass # Replace with function body.

func _on_left_released():
	$Controller/Node2D/left.modulate = Color(1, 1, 1)
	touch_left = false
	pass # Replace with function body.

func _on_up_released():
	$Controller/Node2D/up.modulate=Color(1, 1, 1)
	touch_up = false
	pass # Replace with function body.

func _on_down_released():
	$Controller/Node2D/down.modulate=Color(1, 1, 1)
	touch_down = false
	pass # Replace with function body.

func _on_gun_shoot_released():
	$Controller/Node2D/gun_shoot.modulate=Color(1, 1, 1)
	touch_fire = false
	pass # Replace with function body.

func _on_melee_attack_released():
	$Controller/Node2D/melee_attack.modulate=Color(1, 1, 1)
	touch_melee = false
	pass # Replace with function body.



func _on_AnimationPlayer_shootAk47_finished(shootAk47):
	_clear_states()
	pass # Replace with function body.


func _on_AnimationPlayer_slideAk47_finished(slideAk47):
	_clear_states()
	pass # Replace with function body.

func _on_AnimationPlayer_hurtAk47_finished(HurtAk47):
	_clear_states()
	pass # Replace with function body.

func _on_AnimationPlayer_meleeAk47_finished(meleeAk47):
	pass # Replace with function body.
