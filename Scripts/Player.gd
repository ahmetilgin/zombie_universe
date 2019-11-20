extends KinematicBody2D
signal dead_signal
const bullet = preload("res://Resources/Bullet.tscn")
const upgrade_bullet = preload("res://Resources/Fire_Bullet.tscn")

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
var current_bullet_power = 1
# player motions
var is_attack = false
var is_down = false
var is_dead = false
var is_hurt = false
var is_melee = false
var is_shift_stop = false
const max_bullet_size=30
var bullet_size = 30
onready var bullet_number = get_node("../Game_UI/bullet_counter")
onready var player_health = get_node("../Game_UI/Player_Health")
onready var updated_tween = get_node("../Game_UI/Updated_Tween")
const basic_zombie = preload("res://Resources/Basic_Zombie.tscn")

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
	$AnimatedSprite.play(animation_state)
	
func _play_idle_animation():
	_play_animation("idle")

func _play_melee_animation():
	_play_animation("melee")

func _play_slide_animation():
	_play_animation("slide")	
	
func _play_attack_animation():
	_play_animation("attack")	

func _move_slide():
	$CollisionShape2D.scale = Vector2 (1, 0.7)
	$CollisionShape2D.position.y=20
	if $AnimatedSprite.flip_h==false:
		motion.x = slide_speed
	else:
		motion.x = -slide_speed

func _move_right():
	motion.x=min(motion.x + speed,max_speed)
	_play_animation("run")
	$AnimatedSprite.flip_h=false
	if sign($Position2D.position.x)==-1:
		$Position2D.position.x*=-1
		
func _move_left():
	motion.x = max(motion.x-speed,-max_speed)
	_play_animation("run")
	$AnimatedSprite.flip_h = true
	if sign($Position2D.position.x)==1:
		$Position2D.position.x*=-1
		
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
	$CollisionShape2D.position.y=0
	
var UP = Vector2(0,-1)

func _physics_process(delta):
	if $AnimatedSprite.flip_h==true:
		$CollisionShape2D.position.x=30
		$collision_2.position.x=30
	else:
		$CollisionShape2D.position.x=18
		$collision_2.position.x=18
	
	motion.y += gravity 
	if !_is_dead():
		$Area2D/CollisionShape2D.disabled=true
		$mele_flip_h_true/CollisionPolygon2D.disabled=true
		_set_shift_stop(false)
		if Input.is_action_pressed("ui_right"):
			if _is_movable():
				_move_right()		
		elif Input.is_action_pressed("ui_left"):
			if _is_movable():
				_move_left()
		else:
			if _is_idle():
				_set_shift_stop(true)
				_play_idle_animation()							
		if Input.is_action_just_pressed("ui_down"):
			if is_hurt==false && is_on_floor():
				if is_melee==false:
					is_down=true
					_set_is_down(true)
					_play_slide_animation()
					_move_slide()
		if Input.is_action_just_pressed("ui_focus_prev"):
			if _is_movable():
					_set_is_melee(true)
					_play_melee_animation()
					_change_collision_rotation()
		if Input.is_action_just_pressed("ui_focus_next"):
			if _is_movable() && _check_bullet_count():
				_fire_bullet()
				get_node("Camera2D").shake(1,10,1)
				_set_is_attack(true)

				
				_play_attack_animation()
				if current_bullet_power == 1:
					$ShotSound.play()
					_set_current_bullet(bullet.instance())
				elif current_bullet_power == 2:
					$ShotGun.play()
					_set_current_bullet(upgrade_bullet.instance())
				get_parent().add_child(current_bullet)
				_set_bullet_direction(sign($Position2D.position.x))
				current_bullet.position = $Position2D.global_position
		if is_on_floor():
			if Input.is_action_just_pressed("ui_up"):
				motion.y = jump
			if _is_shift_stop():
				motion.x = lerp(motion.x, 0, 0.2)
		else:
				if _is_movable():
					if motion.y < 0:
						$AnimatedSprite.play("jump")
					else:
						$AnimatedSprite.play("fall")
					if _is_shift_stop():
						motion.x=lerp(motion.x,0,0.5)
						
		motion = move_and_slide(motion,UP)
		if get_slide_count()>0:
			for i in range(get_slide_count()):
				if "Basic_Zombie" in get_slide_collision(i).collider.name:
					dead(1,"zombie")
				if "Big_Zombie" in get_slide_collision(i).collider.name:
					dead(2,"zombie")
				if "Punk_Zombie" in get_slide_collision(i).collider.name:
					dead(3,"zombie")
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
			$AnimatedSprite.play("dead")
			emit_signal("dead_signal")
			$player_dead_timer.start()#karakter hareket etmeyince timerin içine girmiyor
		else:
			is_hurt=true
			$AnimatedSprite.play("hurt")
			


func _on_AnimatedSprite_animation_finished():
	_clear_states()

func upgrade_power_up():
	current_bullet_power = 2

func _on_Area2D_body_entered(body):
	if "Zombie" in body.name:
		body.dead(1,"zombie") 

func _on_mele_flip_h_true_body_entered(body):
	if "Zombie" in body.name:
		body.dead(1,"zombie") 

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
