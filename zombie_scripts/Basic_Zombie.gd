extends KinematicBody2D

const gravity=20
export (int) var hp=1
export (int) var speed=100
var motion=Vector2()
var direction=1
const UP=Vector2(0,-1)
var is_dead=false
var is_hurt=false
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
			motion.x=speed*direction
			if direction==1:
				$AnimatedSprite.flip_h=false
			else:
				$AnimatedSprite.flip_h=true
			$AnimatedSprite.play("walk")
			motion.y+=gravity
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
