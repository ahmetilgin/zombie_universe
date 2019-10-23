extends Area2D

const speed=450
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
	$AnimatedSprite.play("shoot2")
	pass

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	pass


func _on_bullet_body_entered(body):
	if "enemy" in body.name:
		body.dead(1) 
	if "big_enemy" in body.name:
		body.dead(1) 
	if "Punk_Zombie" in body.name:
		body.dead(1) 
	queue_free()

