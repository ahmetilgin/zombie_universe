extends Area2D

const speed=1000
var motion=Vector2()
var direction=1
func set_bullet_direction(dir):
	direction=dir
	if dir==-1:
		$AnimatedSprite.flip_h=true
		$AnimatedSprite.position.x+=45
		$CollisionShape2D.position.x+=45
	

func _physics_process(delta):
	motion.x=speed*delta*direction
	translate(motion)
	$AnimatedSprite.play("shoot")
	pass





func _on_upgradebllet_body_entered(body):
	if "Zombie" in body.name:
		body.dead(2) 
	queue_free()



func _on_VisibilityNotifier2D_screen_exited():
	
	queue_free()
	pass

