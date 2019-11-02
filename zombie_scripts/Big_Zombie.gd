extends KinematicBody2D
const FLOOR=Vector2(0,-1)
var motion=Vector2()
const gravity=10

var direction=1
export (int) var hp=5
export (int) var speed=100
var is_dead=false
onready var Player=get_parent().get_node("player")
var is_attack=false
var is_hurt=false
func dead(damage):
	
	hp-=damage
	if hp<0:		
		is_dead=true	
		motion=Vector2(0,0)
		$AnimatedSprite.position.y+=10
		$AnimatedSprite.play("dead")		
		$Timer.start()		
	else:
		is_hurt=true
		
		$AnimatedSprite.play("hurt")
		
func _physics_process(delta):
	$Area2D/CollisionShape2D.disabled=true
	if $AnimatedSprite.flip_h==true:
		$CollisionShape2D.position.x=20
	else:
		$CollisionShape2D.position.x=10
		 
	if is_dead==false:
		if is_hurt==false:
			
			if not -350<=Player.position.x-position.x or Player.position.x-position.x>=350:
				if is_attack==false:
					motion.y+=gravity
					motion.x=speed*direction
					if direction==1:
						$AnimatedSprite.flip_h=false
						
					else:
						$AnimatedSprite.flip_h=true
					$AnimatedSprite.play("walk")
					
					motion=move_and_slide(motion,FLOOR)
				
				
					if is_on_wall():
						direction*=-1
						$RayCast2D.position.x*=-1
					if $RayCast2D.is_colliding()==false:
						direction*=-1
						$RayCast2D.position.x*=-1
				
			else:
				$Area2D/CollisionShape2D.disabled=true
				motion.y+=gravity
				
				if  -55<=Player.position.x-position.x and -25>=Player.position.x-position.x  or Player.position.x-position.x<=37 and Player.position.x-position.x>=15 :
					is_attack=true
					motion.x=0
					if $AnimatedSprite.flip_h==true:
						$Area2D/CollisionShape2D.position.x=-20
					else:
						$Area2D/CollisionShape2D.position.x=36
					$Area2D/CollisionShape2D.disabled=false
					$AnimatedSprite.play("attack")
				elif Player.position.x<position.x:
					if is_attack==false:
						motion.x=-120
						$AnimatedSprite.flip_h=true
						$AnimatedSprite.play("run")
					
				elif Player.position.x >position.x:
					if is_attack==false:
						motion.x=120
						$AnimatedSprite.flip_h=false
						$AnimatedSprite.play("run")
				
				if -60<=Player.position.x-position.x and -58>=Player.position.x-position.x and is_on_floor()  or Player.position.x-position.x<=60 and Player.position.x-position.x>=58 and is_on_floor() :
					if is_attack==false:
						motion.y=-200
						motion.y+=1
						$AnimatedSprite.play("jump")
						if motion.y>205:
							motion=0
						if  -20>=Player.position.x-position.x   or Player.position.x-position.x>=20 :
							motion.x=0
							
						elif Player.position.x<position.x:
							motion.x=-300
							$AnimatedSprite.flip_h=true
						
						elif Player.position.x>position.x:
							motion.x=300
							$AnimatedSprite.flip_h=false

						else:
							motion.x=0
							"""
					if  -15>=Player.position.x-position.x and is_on_floor() and is_on_wall() or Player.position.x-position.x>=15 and is_on_floor() and is_on_wall() :
						motion.y=-400
						motion.y+=1
						$AnimatedSprite.play("jump")
						if motion.y>405:
							motion=0
						if Player.position.x+45<position.x:
							motion.x=-300
							$AnimatedSprite.flip_h=true
						
						elif Player.position.x -15>position.x:
							motion.x=300
							$AnimatedSprite.flip_h=false
						
						else:
							motion.x=0
				
					"""
				if get_slide_count()>0:
							for i in range(get_slide_count()):
								if "player" in get_slide_collision(i).collider.name:
									get_slide_collision(i).collider.dead(2)
						
				motion=move_and_slide(motion,FLOOR)
	else:
		
		if is_on_floor():
			$CollisionShape2D.set_deferred("disabled",true)
			if $AnimatedSprite.frame==4:
				$AnimatedSprite.position.y=10
		else:
			motion.y+=gravity
			motion=move_and_slide(motion,FLOOR)
		
func _on_Timer_timeout():
	queue_free()


func _on_AnimatedSprite_animation_finished():
	is_hurt=false
	is_attack=false
	if is_attack==false:
		$Area2D/CollisionShape2D.disabled=true

func _on_enemy_attack_body_entered(body):
	if "player" in body.name:
		body.dead(2) 
		
