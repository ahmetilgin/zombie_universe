extends KinematicBody2D
var total_distance
var target_point_world = Vector2()
var FollowPlayerTimer = Timer.new()
var velocity = Vector2(20,20)
onready var player = get_parent().get_node('player/CollisionShape2D')
const gravity=20
export (int) var hp=1
export (int) var speed=100
var motion=Vector2()
var direction=1
const UP=Vector2(0,-1)
var is_dead=false
var is_hurt=false

var is_follow = false
var path = []

func move_to():
	if len(path) > 1:
		var ARRIVE_DISTANCE = 50
		move_and_slide((target_point_world-get_global_position()) * 4)
		return get_global_position().distance_to(target_point_world) < ARRIVE_DISTANCE
	
func follow_path():	
	if len(path) > 2:
		$AnimatedSprite.flip_h = sign(path[1].x - get_global_position().x) != 1	
	if player.get_global_position().distance_to(get_global_position()) < 95:
		$AnimatedSprite.play("idle")
	else:
		$AnimatedSprite.play("walk")
		_get_path()
	if move_to():
		path.pop_front()
		if len(path) > 0:
			target_point_world = path[0]	
	pass
		
		

func _get_path():
	if len(path) < 2:
		path = get_parent().get_node('TileMap')._get_path(get_global_position(), player.get_global_position())
		path.pop_front()
	if not path or len(path) == 1:
			return
	target_point_world = path[0]
		
func _set_is_follow(follow):
	is_follow = follow


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
	if is_on_wall():
		for i in range(get_slide_count()):
			var playerFound = false
			if "player" in get_slide_collision(i).collider.name:
				playerFound = true
			if !playerFound:
				motion.y -= 200

func _physics_process(delta):
	if is_dead==false:
		if is_hurt==false:
			motion.y += gravity
			motion = move_and_slide(motion, UP)
			_jump_is_on_wall()
			follow_path()
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


