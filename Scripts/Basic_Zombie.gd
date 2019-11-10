extends KinematicBody2D
var total_distance
var target_point_world = Vector2()
var FollowPlayerTimer = Timer.new()
var velocity = Vector2(20,20)
onready var player = get_parent().get_node('player/CollisionShape2D')
onready var tile_map = get_parent().get_node('TileMap')
const gravity=20
export (int) var hp=1
export (int) var speed=100
var motion=Vector2(0,0)
const UP=Vector2(0,-1)
var is_dead=false
var is_hurt=false
var acceleration = 10
var is_follow = false
var path = []

func move_to():
	if len(path) > 1:
		var ARRIVE_DISTANCE = 50
		var direction = get_global_position().direction_to(target_point_world)
		motion += direction	
		if direction.x > 0:
			motion.x = min(motion.x + acceleration, speed)
		else:
			motion.x = max(motion.x - acceleration, -speed)
		
		
		# zıplamadan önce 
		# gidilecek yolda ki kırılma ilk 3 nokta için direk kırılıyorsa 
		# x i degisiyorsa  ve y si degismiyorsa küçük zıplasın
		# bir yukarı bir sola <-- --> bir yukari bir sağa giriş
		#					 	 | 
		#					 Player Pozisyonu
		var is_small_jump = true

		if len(path) > 2:
			# x aynı y farklı
			is_small_jump = (path[0].x == path[1].x)  and (path[0].y != path[1].y)  and (path[1].y == path[2].y) and (path[1].x != path[2].x)
			
	
		if direction.y < 0 && is_on_floor():
			if !is_small_jump:
				motion.y += -700
			else:
				motion.y += -300
		return get_global_position().distance_to(target_point_world) < ARRIVE_DISTANCE
	
func follow_path():	
	if len(path) > 2:
		$AnimatedSprite.flip_h = sign(path[1].x - get_global_position().x) != 1	
	if player.get_global_position().distance_to(get_global_position()) < 100:
		$AnimatedSprite.play("idle")
		motion = Vector2(0, 0)
	else:
		$AnimatedSprite.play("walk")
		_get_path()
		if move_to():
			path.pop_front()
			if len(path) > 0:
				target_point_world = path[0]	
	pass
		
		

func _get_path():
	path = get_parent().get_node('TileMap')._get_path(get_global_position(), player.get_global_position())
	path.pop_front()
	if not path or len(path) == 1:
			return
	target_point_world = path[0]
		
func _set_is_follow(follow):
	is_follow = follow
	FollowPlayerTimer.connect("timeout",self,"_on_FollowPlayerTimer_timeout") 
	#timeout is what says in docs, in signals
	#self is who respond to the callback
	#_on_timer_timeout is the callback, can have any name
	add_child(FollowPlayerTimer) #to process
	FollowPlayerTimer.set_wait_time(5)
	FollowPlayerTimer.start() #to start

func dead(damage):
	
	hp-=damage
	if hp<0:
		
		is_dead=true
		motion=Vector2(0,0)
		$AnimatedSprite.position.y+=10
		$AnimatedSprite.play("dead")
		$CollisionShape2D.set_deferred("disabled",true)
		$Timer.start()
	else:
		is_hurt=true
		
		$AnimatedSprite.play("hurt")	

func _jump_is_on_wall():
	if is_on_wall() && is_on_floor():
		for i in range(get_slide_count()):
			var playerFound = false
			if "player" in get_slide_collision(i).collider.name:
				playerFound = true
			if !playerFound:
				motion.y -= 200

func move_like_basic_zombie():
	if len(path) == 0:
		pass

func _physics_process(delta):
	if is_dead==false:
		if is_hurt==false:
			motion.y += gravity
			follow_path()
			#_jump_is_on_wall()
			motion = move_and_slide(motion, UP)

#			if get_slide_count()>0:
#				for i in range(get_slide_count()):
#					if "player" in get_slide_collision(i).collider.name:
#						pass
						#(i).collider.dead(1)
 
func _on_Timer_timeout():
	queue_free()


func _on_AnimatedSprite_animation_finished():
	is_hurt=false
	
func _set_zombie_position(new_position):
	$AnimatedSprite.position = new_position


func _on_FollowPlayerTimer_timeout():	
	pass