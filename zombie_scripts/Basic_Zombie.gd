extends KinematicBody2D

var target_point_world = Vector2()
var FollowPlayerTimer = Timer.new()
var velocity = Vector2()
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
	if len(path) > 0:
		var ARRIVE_DISTANCE = 20

		var direction = (target_point_world - get_global_position()).normalized()
		set_global_position(target_point_world)
		return get_global_position().distance_to(target_point_world) < ARRIVE_DISTANCE

func follow_path():	
	if move_to():
		path.pop_front()
		if len(path) > 0:
			target_point_world = path[0]	
	pass
		
		

func _get_path():
	path = get_parent().get_node('TileMap')._get_path(get_global_position(), player.get_global_position())
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

func _physics_process(delta):
	if is_dead==false:
		if is_hurt==false:
			motion.y+=gravity
			if is_follow:
				follow_path()
			else: 
				motion.x=speed*direction
				if direction==1:
					$AnimatedSprite.flip_h=false
				else:
					$AnimatedSprite.flip_h=true
				$AnimatedSprite.play("walk")

				motion=move_and_slide(motion,UP)
				if is_on_wall():
					direction*=-1
					$RayCast2D.position.x*=-1
				if $RayCast2D.is_colliding()==false:
					direction*=-1
					$RayCast2D.position.x*=-1
				if get_slide_count()>0:
					for i in range(get_slide_count()):
						if "player" in get_slide_collision(i).collider.name:
							get_slide_collision(i).collider.dead(1)
 
func _on_Timer_timeout():
	queue_free()


func _on_AnimatedSprite_animation_finished():
	is_hurt=false
	
func _set_zombie_position(new_position):
	$AnimatedSprite.position = new_position


func _on_FollowPlayerTimer_timeout():
	if get_global_position().distance_to(player.get_global_position()) > 500:
		_get_path()
		
	pass # Replace with function body.
