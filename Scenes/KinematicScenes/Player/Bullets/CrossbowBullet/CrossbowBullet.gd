extends Area2D
var no_hurt = false
var  speed=1000
var motion=Vector2()
var direction=1
func set_bullet_direction(dir):
	direction=dir
	if dir==-1:
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.position.x+=45
		$CollisionShape2D.position.x+=45
	else:
		$AnimatedSprite.flip_h = true
	

func _physics_process(delta):
	motion.x=speed*delta*direction
	translate(motion)
	$AnimatedSprite.play("shoot2")

	
	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass



func _on_Crossbowbullet_body_entered(body):
	if "Zombie" in body.name and !no_hurt:
		body.dead(1,"player") 
		queue_free()
	else:
		no_hurt = true
		speed = 0
		$Timer.start()
	pass # Replace with function body.


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
